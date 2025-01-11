public class NewOpportunity {
	@AuraEnabled
    public static Opportunity newOpportunity(String name, Date closeDate, Decimal amount, String tipo, Id accountId, Id contractId, String description) {
		Opportunity o = new Opportunity(Name = name,
                                       closeDate = closeDate,
                                       Tipo_de_alteracao__c = tipo,
                                       Amount = amount,
                                       Meses__c = 12,
                                       AccountId = accountId,
                                       ContractId = contractId,
                                       StageName = 'Mapeamento',
                                       Description = description);
        
        try {
            insert o;
            return o;
        } catch (DmlException e) {
            System.debug(e.getMessage());
            return null;
        }
    }  
    
    @AuraEnabled
    public static Id getAccountId(Id recordId) {
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