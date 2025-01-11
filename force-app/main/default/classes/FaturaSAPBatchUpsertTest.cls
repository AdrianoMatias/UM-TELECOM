@isTest
public class FaturaSAPBatchUpsertTest {
   @isTest
    static void testMethod1(){

		String accountId = TestFactoryData.createAccount('123').Id;
        String contractId = TestFactoryData.createContract(accountId, '123').Id;

        Fatura__c fat = new Fatura__c(Conta__c = accountId, 
                                  	  Contrato__c = contractId,
                                      NumeroFaturaSAP__c = 999,
                                  	  StatusDaFatura__c = 'Aberta');

        Test.startTest();
        Database.executeBatch(new FaturaSAPBatchUpsert(new List<Fatura__c>{fat}), 1);
		Test.stopTest();

        List<Fatura__c> faturaList = [Select Id, StatusDaFatura__c From Fatura__c Where Conta__c = :accountId And Contrato__c = :contractId];
    
        Assert.areEqual(1, faturaList.size(), 'faturaList deveria ser 1');
    }
}