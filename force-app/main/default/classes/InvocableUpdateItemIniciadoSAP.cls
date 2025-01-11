public class InvocableUpdateItemIniciadoSAP {
    
    @InvocableMethod
    public static List<Results> invokeAPI(List<Requests> requestList) {
        List<Results> listaRetorno = new List<Results>();
        Results responseVariable = new Results();
        HttpRequest reqTest = new HttpRequest();
        HttpResponse resPOSTToken = new HttpResponse();
        HttpResponse resPATCHItem = new HttpResponse();
        String vItemId, bodyJsonAcesso, responseBodyToken, responseStatusToken, vToken, vBodyItem, responseBodyItem, responseStatusPatch, vTodayPrazoVigencia = '';
        String vToday = String.valueOf(System.Today());
        Integer responseCodeAcesso, responseCodePatch;
        
        vItemId = requestList[0].vItemId;
        
        system.debug('vItemId: '+vItemId);
        
        Item_do_Contrato__c item = [SELECT Contrato__r.Codigo_do_contrato__c, Contrato__r.ContractTerm, NumeroItemContrato__c FROM Item_do_Contrato__c WHERE Id =: vItemId];
        
        List<SAP_Integration__mdt> credential1 = [SELECT CompanyDB__c, UserName__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'SessionToken'];
        
        bodyJsonAcesso = '{"CompanyDB": "'+credential1[0].CompanyDB__c+'","UserName": "'+credential1[0].UserName__c+'","Password": "'+credential1[0].Password__c+'"}';
        
        //1ª Requisição - Token
        if(Test.isRunningTest()){
            responseBodyToken = '{"SessionId":"TESTE123"}';
            HttpMock httpMock = new HttpMock(200, 'OK', responseBodyToken, new Map<String,String>());
            resPOSTToken = httpMock.respond(reqTest);
        }else{
            resPOSTToken = HttpUtils.getInstance().sendRequestAcesso('POST', 'callout:ApiAutenticacaoSAP', bodyJsonAcesso, null , 120000, null);
            System.debug('resPOSTToken ' + resPOSTToken); 
            System.debug('resPOSTToken.getStatusCode ' + resPOSTToken.getStatusCode());    
            System.debug('resPOSTToken.getbody() ' + resPOSTToken.getbody());  
        }
        
        responseBodyToken = resPOSTToken.getbody();
        responseCodeAcesso = resPOSTToken.getStatusCode();
        responseStatusToken = resPOSTToken.getStatus();
        
        if(responseCodeAcesso == 200){
            
            JSONParser parser = JSON.createParser(responseBodyToken);
            while(parser.nextToken()!= null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();
                    if(parser.getCurrentName() == 'SessionId'){
                        vToken = String.valueOf(parser.getText());
                        system.debug('vToken: ' + vToken);
                    }
                }
            }
            
            if(item.Contrato__r.ContractTerm != null && item.Contrato__r.ContractTerm > 0)
                vTodayPrazoVigencia = String.valueOf(Date.today().addMonths(item.Contrato__r.ContractTerm));
            
            vBodyItem = '{"ServiceContract_Lines": [{"LineNum": '+item.NumeroItemContrato__c+',"U_dtAtivcaoIni": "'+vToday+'","U_FLX_Status":"I", "U_DtEncerramento": "'+vTodayPrazoVigencia+'"}]}';
            
            //2ª Requisição - Atualização do Item no SAP
            if(Test.isRunningTest()){
                responseBodyItem = '{"ItemId":"TESTE123"}';
                HttpMock httpMock = new HttpMock(204, 'OK', responseBodyItem, new Map<String,String>());
                resPATCHItem = httpMock.respond(reqTest);
            }else{
                
                List<NamedCredential> listCredContrato = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'ApiContratoSAP' LIMIT 1];
                
                resPATCHItem = HttpUtils.getInstance().sendRequestUpdateItemIniciado('PATCH', listCredContrato[0].Endpoint, 120000, vBodyItem, vToken, item.Contrato__r.Codigo_do_contrato__c);
                System.debug('resPATCHItem ' + resPATCHItem);                                                  
                System.debug('resPATCHItem.getStatusCode ' + resPATCHItem.getStatusCode()); 
                System.debug('resPATCHItem.getbody() ' + resPATCHItem.getbody()); 
            }
            
            responseBodyItem = resPATCHItem.getbody();
            responseCodePatch = resPATCHItem.getStatusCode();
            responseStatusPatch = resPATCHItem.getStatus();
            
            if(responseCodePatch == 204){
                
                Item_do_Contrato__c idc = new Item_do_Contrato__c();
                idc.id = vItemId;
                idc.Status__c = 'INICIADO';
                update idc;
                
                insert ControleDeServicoBO.getInstance().gerarLogPai('Sucesso', 'InvocableUpdateItemIniciadoSAP', 'PATCH - Item do Contrato: '+vItemId, vBodyItem, responseBodyItem, responseStatusPatch, responseCodePatch, System.Now(), False);
                responseVariable.vSucesso = True;
            } else {
                //Criação Log de erro do Patch
                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableUpdateItemIniciadoSAP', 'PATCH - Item do Contrato: '+vItemId, vBodyItem, responseBodyItem, responseStatusPatch, responseCodePatch, System.Now(), False);          
                responseVariable.vSucesso = false;
            }
            
        } else {
            //Criação Log de erro do Token
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableUpdateItemIniciadoSAP', 'POST - Token - Item do Contrato: '+vItemId, bodyJsonAcesso, responseBodyToken, responseStatusToken, responseCodeAcesso, System.Now(), False);
            responseVariable.vSucesso = false;
        }
        
        listaRetorno.add(responseVariable);
        return listaRetorno;
    }
    
    public class Requests {
        @InvocableVariable(label='Id do Item' required=true)
        public String vItemId;
    }
    
    public class Results {
        @InvocableVariable(label='Integração Sucesso' required=true)
        public Boolean vSucesso;
    }
    
}