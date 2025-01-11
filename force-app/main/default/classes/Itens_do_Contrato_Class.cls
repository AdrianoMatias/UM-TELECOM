public class Itens_do_Contrato_Class {     
    @AuraEnabled
    public static List<Item_do_Contrato__c> getContractItems(String recordId) { 
        try {
            return [SELECT Name, Oportunidade__r.Name, Numero_do_circuito__c, Endereco_de_Destino__c
               		FROM Item_do_Contrato__c
               		WHERE Contrato__c = :recordId AND Status__c = 'INICIADO'];             
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }          
    }
    
    @AuraEnabled
    public static String getAccountId(String recordId) {
        try {
            return [SELECT AccountId
               		FROM Contract
               		WHERE Id = :recordId].accountId;             
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
}