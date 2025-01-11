public with sharing class InvocableCriarPedidoMaterialSAP {
    @InvocableMethod    
    public static List<Result> execute(List<Request> requestList){
        
        Result result = new Result();
        result.vSucesso = true;

        String wOId = requestList[0].workOrderId;

        String token = getToken();
        WorkOrder wo = getData(wOId);
        String jsonBody = buildJsonBody(wo);
        HttpRequest req = new HttpRequest();
        HttpResponse response = sendRequestPOST(req, 'POST', 'callout:ApiInventoryTransferRequestsSAP', 12000, jsonBody, token);
        handlerResponse(req, response, result);

        if (result.vSucesso) {
            String docNum = extractDocNum(response.getBody());
            handlerDocNum(docNum, result);
        }
        
        List<Result> results = new List<Result>();
        results.add(result);
        return results;          
    }
    private static String getToken() {

        List<SAP_Integration__mdt> credential1 = [SELECT CompanyDB__c, UserName__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'SessionToken'];
        String bodyJsonAcesso = '{"CompanyDB": "'+credential1[0].CompanyDB__c+'","UserName": "'+credential1[0].UserName__c+'","Password": "'+credential1[0].Password__c+'"}';
        
        HttpResponse resAcesso = HttpUtils.getInstance().sendRequestAcesso('POST', 'callout:ApiAutenticacaoSAP', bodyJsonAcesso, null , 120000, null);
        String responseBodyAcesso = resAcesso.getbody();
        Integer responseCodeAcesso = resAcesso.getStatusCode();
        
        if(responseCodeAcesso == 200){
            JSONParser parser = JSON.createParser(responseBodyAcesso);
            while(parser.nextToken()!= null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();
                    if(parser.getCurrentName() == 'SessionId'){
                        return String.valueOf(parser.getText());
                    }
                }
            }
        }
        return '';
    }
    private static WorkOrder getData(Id wOId) {
        return [SELECT Id, WorkOrderNumber,  Account.Codigo_SAP_cliente__c, Circuito__r.Numero_do_circuito__c,
                       (select id, Produto__r.ProductCode, Quantidade__c, Valor__c  from Item_designado__r)
                  FROM WorkOrder 
                 WHERE Id =:  wOId];
    }
    private static String buildJsonBody(WorkOrder wo) {

        JSONGenerator gen = JSON.createGenerator(true); 
        gen.writeStartObject();

        gen.writeNumberField('BPLID', 1);
        gen.writeStringField('DocDate', String.valueOf(Date.today()));
        gen.writeStringField('DueDate', String.valueOf(Date.today()));
        gen.writeStringField('TaxDate', String.valueOf(Date.today()));
        gen.writeStringField('CardCode', wo.Account.Codigo_SAP_cliente__c);
        gen.writeStringField('Comments', 'OS Salesforce número ' + wo.WorkOrderNumber + '- Implantação de circuito: ' + wo.Circuito__r.Numero_do_circuito__c);
        gen.writeStringField('FromWarehouse', 'PE.EST');
        gen.writeStringField('ToWarehouse', 'EST.PE');
        gen.writeStringField('U_UM_OsSalesforce', wo.Id);

        gen.writeFieldName('StockTransferLines');
        gen.writeStartArray();

        for (ItemDesignado__c itemDesignado : wo.Item_designado__r) {
            gen.writeStartObject();
            gen.writeStringField('ItemCode', itemDesignado.Produto__r.ProductCode);
            gen.writeStringField('Quantity', String.valueOf(itemDesignado.Quantidade__c));
            gen.writeStringField('UnitPrice', String.valueOf(itemDesignado.Valor__c));
            gen.writeStringField('FromWarehouseCode', 'PE.EST'); // Fixo, conforme o exemplo
            gen.writeStringField('WarehouseCode', 'EST.PE'); // Fixo, conforme o exemplo
            gen.writeStringField('DistributionRule', '303'); // Fixo, conforme o exemplo
            gen.writeEndObject();
        }

        gen.writeEndArray();

        gen.writeEndObject();

        return gen.getAsString();
    }
    public static HttpResponse sendRequestPOST(HttpRequest req, String metodo, String endPoint, Integer timeout, String jsonBody, String token){
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+token); 
        if(jsonBody != null) req.setBody(jsonBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    private static void handlerResponse(HttpRequest req, HttpResponse response, Result result) {
        if(response.getStatusCode() != 201) {
            result.vSucesso = false;
            result.vErrorMessage = 'Erro: Código de resposta ' + response.getStatusCode() + ' - ' + response.getStatus();
        } else {
            result.vSucesso = true;
        }
        String message = (result.vSucesso) ? 'Sucesso' : 'Erro';
        insert ControleDeServicoBO.getInstance().gerarLogPai(message, 'InvocableCriarPedidoMaterialSAP', 'POST - Tranferência de Estoque', req.getBody(), response.getBody(),response.getStatus(), response.getStatusCode(), System.Now(), False);
    }
    private static String extractDocNum(String jsonBody) {
            JSONParser parser = JSON.createParser(jsonBody);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'DocNum')) {
                    parser.nextToken();
                    return parser.getText();
                }
            }
            return null; // Retornar nulo se não encontrar o DocNum
    }
    private static void handlerDocNum(String docNum, Result result) {
        if(String.isBlank(docNum)) {
            result.vSucesso = false;
            result.vErrorMessage = 'Erro: DocNum não encontrado!';
        } else {
            result.vSucesso = true;
            result.vDocNum = Integer.valueOf(docNum);
        }
    }    
    public class Request {
        @InvocableVariable(label='Work Order Id' required=true)
        public String workOrderId;        
    }
    public class Result {
        @InvocableVariable(label='Sucesso' required=true)
        public Boolean vSucesso;
        @InvocableVariable(label='Mensagem de Erro')
        public String vErrorMessage;
        @InvocableVariable(label='Número do documento')
        public Integer vDocNum;        
    }
}