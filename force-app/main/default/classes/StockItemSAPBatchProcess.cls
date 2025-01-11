global class StockItemSAPBatchProcess implements Database.Batchable<SObject>, Schedulable, Database.AllowsCallouts {
    
    @TestVisible    
    private class StockResponse {
        public String oDataContext;
        public List<StockItem> value;
    }
    
    @TestVisible
    private class StockItem {
        public String CodigodoItem;
        public Decimal SaldoDisponivel;
        public Decimal UltimoPrecoCompra;

        // Construtor
        public StockItem(String CodigodoItem, Decimal SaldoDisponivel, Decimal UltimoPrecoCompra) {
            this.CodigodoItem = CodigodoItem;
            this.SaldoDisponivel = SaldoDisponivel;
            this.UltimoPrecoCompra = UltimoPrecoCompra;
        }
    }
    
    @InvocableMethod
    public static void invokeBatch() {
        StockItemSAPBatchProcess batch = new StockItemSAPBatchProcess();
        Database.executeBatch(batch, 200);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(this, 200);
    }

    global Iterable<SObject> start(Database.BatchableContext BC) {

        List<Product2> tempProcessList = new LIst<Product2>();

        String message = '';

        String token = getToken();
        HttpRequest req = new HttpRequest();
        HttpResponse response = sendRequest(req, 'GET', 'callout:ApiSaldoEstoqueSAP', 12000, null, token);
        
        if(response.getStatusCode() != 200) {
            message = 'Erro';
        } else {
            message = 'Sucesso';

            StockResponse stockResponse = (StockResponse)JSON.deserialize(response.getBody(), StockResponse.class);
            for (StockItem item : stockResponse.value) {
                tempProcessList.add(new Product2(ProductCode = item.CodigodoItem, 
                                                 EstoqueDisponivelNoSAP__c = item.SaldoDisponivel,
                                                 UltimoPrecoDeCompra__c = item.UltimoPrecoCompra,
                                                 UltimaAtualizacaoDoSaldoNoSap__c = Datetime.now()
                                                 )
                                   );
           }
        }
        insert ControleDeServicoBO.getInstance().gerarLogPai(message, 'StockItemSAPBatchProcess', 'GET', req.getBody(), response.getBody(),response.getStatus(), response.getStatusCode(), System.Now(), False);
        
        return tempProcessList;
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {

        List<Product2> products = (List<Product2>)scope;
        if (!products.isEmpty()) {
            Set<String> productCodes = new Set<String>();
            for (Product2 product : products) {
                productCodes.add(product.ProductCode);
            }
    
            // Consultar registros Product2 existentes com os ProductCodes
            Map<String, Product2> existingProducts = new Map<String, Product2>();
            for (Product2 product : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN :productCodes]) {
                existingProducts.put(product.ProductCode, product);
            }

            // Filtrar os produtos para incluir apenas os existentes na base de dados
            List<Product2> productsToUpdate = new List<Product2>();
            for (Product2 product : products) {
                if (existingProducts.containsKey(product.ProductCode)) {
                    // Definindo o Id é crucial para garantir que o registro será atualizado em vez de inserido
                    product.Id = existingProducts.get(product.ProductCode).Id;
                    productsToUpdate.add(product);
                }
            }

            // Realizar a operação de upsert apenas nos produtos existentes
            if (!productsToUpdate.isEmpty()) {
                update productsToUpdate;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        
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
    public static HttpResponse sendRequest(HttpRequest req, String metodo, String endPoint, Integer timeout, String jsonBody, String token){
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+token); 
        if(jsonBody != null) req.setBody(jsonBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }    
}