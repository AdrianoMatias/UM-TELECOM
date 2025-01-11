public class Aditivo_de_Contrato_Class {     
    @AuraEnabled
    public static List<Titulo_Financeiro__c> getContractItems(String recordId) { 
        try {
            return [SELECT Contrato__r.ContractNumber, Status_Financeiro__c, Contrato__r.StartDate, Contrato__r.EndDate
					FROM Titulo_Financeiro__c
					WHERE Contrato__r.AccountId = :recordId];             
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }          
    }
}