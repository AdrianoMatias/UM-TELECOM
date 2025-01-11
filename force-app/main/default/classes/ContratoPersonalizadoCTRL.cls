public class ContratoPersonalizadoCTRL {
    
	@AuraEnabled
    public static Map<String, String> getDataDocument(String idContrato){
        try {
            Map<String, String> retorno = new Map<String, String>();
            retorno.put('hasContent','false');

            List<Contract> contratos = [SELECT Id, DocumentId__c, Enviar_Contratos_Padroes__c FROM Contract WHERE Id = :idContrato];
            if(contratos.size() > 0){
                List<ContentDocument> contents = [SELECT Id, Title FROM ContentDocument WHERE Id = :contratos.get(0).DocumentId__c];
                if(contents.size()>0){
                    ContentDocument content = contents.get(0);

                    retorno.put('idFile',content.Id);
                    retorno.put('nameFile',content.Title);
                    retorno.put('enviarContratosPadroes',String.valueOf(contratos.get(0).Enviar_Contratos_Padroes__c));
                    retorno.put('hasContent','true');
                }
            }

            return retorno;
        } catch(Exception ex) {
            throw new AuraHandledException( ex.getMessage() );
        }
    }

    @AuraEnabled
    public static void updateContract(String idFile, String nameFile, String idContrato) {
        try {
            List<Contract> contratos = [SELECT Id, DocumentId__c FROM Contract WHERE Id = :idContrato];
            if(contratos.size() > 0){
                Contract contrato = contratos.get(0);
                if(String.isNotBlank(contrato.DocumentId__c)){
                    List<ContentDocument> contents = [SELECT Id FROM ContentDocument WHERE Id = :contrato.DocumentId__c];
                    if(contents.size()>0){
                        delete contents;
                    }
                }
                contrato.DocumentId__c = idFile;
                update contrato;
            }
        } catch(Exception ex) {
            throw new AuraHandledException( ex.getMessage() );
        }
    }

    @AuraEnabled
    public static void deleteDocument(String idContrato){
        try {
            List<Contract> contratos = [SELECT Id, DocumentId__c FROM Contract WHERE Id = :idContrato];
            if(contratos.size() > 0){
                Contract contrato = contratos.get(0);
                if(String.isNotBlank(contrato.DocumentId__c)){
                    List<ContentDocument> contents = [SELECT Id FROM ContentDocument WHERE Id = :contrato.DocumentId__c];
                    if(contents.size()>0){
                        delete contents;
                    }
                }
                contrato.DocumentId__c = null;
                update contrato;
            }
        } catch(Exception ex) {
            throw new AuraHandledException( ex.getMessage() );
        }
    }

    @AuraEnabled
    public static void marcarEnvio(String idContrato, Boolean checked){
        List<Contract> contratos = [SELECT Id, Enviar_Contratos_Padroes__c FROM Contract WHERE Id = :idContrato];
        try {
            Contract contrato = contratos.get(0);
            contrato.Enviar_Contratos_Padroes__c = checked;
            update contrato;
        } catch(Exception ex) {
            throw new AuraHandledException( ex.getMessage() );
        }
    }
}