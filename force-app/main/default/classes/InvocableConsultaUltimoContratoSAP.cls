public class InvocableConsultaUltimoContratoSAP {
    @InvocableMethod    
    public static List<Results> Executa(){
        List<Results> listaRetorno = new List<Results>();
        String response, vNumContrato, vToken, queryParameter;
        Integer responseCodeAcesso, responseCodeGet;
        Results responseVariable = new Results();
        
        List<SAP_Integration__mdt> credential1 = [SELECT CompanyDB__c, UserName__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'SessionToken'];
        List<SAP_Integration__mdt> credential2 = [SELECT URL_Parameters__c FROM SAP_Integration__mdt WHERE DeveloperName = 'ParameterUltimoContrato'];
        
        String bodyJsonAcesso = '{"CompanyDB": "'+credential1[0].CompanyDB__c+'","UserName": "'+credential1[0].UserName__c+'","Password": "'+credential1[0].Password__c+'"}';
        
        HttpResponse res1 = HttpUtils.getInstance().sendRequestAcesso('POST', 'https://services.umcloud.com.br:48124/b1s/v1/Login', bodyJsonAcesso, null , 120000, null);
        System.debug('res1 ' + res1); 
        System.debug('res1.getStatusCode ' + res1.getStatusCode());    
        System.debug('res1.getbody() ' + res1.getbody());  
        response = res1.getbody();
        responseCodeAcesso = res1.getStatusCode();
        
        //Fazer Rquisição no SAP para trazer o número do último Contrato
        if(responseCodeAcesso == 200){
            
            JSONParser parser = JSON.createParser(response);
            while(parser.nextToken()!= null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();
                    if(parser.getCurrentName() == 'SessionId'){
                        vToken = String.valueOf(parser.getText());
                        system.debug('vToken: ' + vToken);
                    }
                }
            }
            
            queryParameter = credential2[0].URL_Parameters__c;
            
            HttpResponse res2 = HttpUtils.getInstance().sendRequestGetUltimoContrato('GET', 'https://services.umcloud.com.br:48124/b1s/v1/ServiceContracts?', 120000, vToken, queryParameter);
            System.debug('res2 ' + res2); 
            System.debug('res2.getStatusCode ' + res2.getStatusCode()); 
            System.debug('res2.getbody() ' + res2.getbody()); 
            response = res2.getbody();
            responseCodeGet = res2.getStatusCode();
            
            if(responseCodeGet == 200){
                
                JSONParser parser2 = JSON.createParser(response);
                while(parser2.nextToken()!= null) {
                    if(parser2.getCurrentToken() == JSONToken.FIELD_NAME) {
                        parser2.nextValue();
                        if(parser2.getCurrentName() == 'ContractID'){
                            vNumContrato = String.valueOf(parser2.getText());
                            system.debug('vNumContrato: ' + vNumContrato);
                        }
                    }
                }
                responseVariable.vNumeroUltimoContrato = vNumContrato;
            } else {
                responseVariable.vNumeroUltimoContrato = '9998';
            }
        }
        
        listaRetorno.add(responseVariable);
        return listaRetorno;
    }
    
    public class Results {
        @InvocableVariable(label='UltimoNumeroCadastrado' required=true)
        public String vNumeroUltimoContrato;
    }
}