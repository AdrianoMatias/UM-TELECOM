@isTest
public class InvocableUpdateItemIniciadoSAP_Test {
    
    @testSetup
    static void dataCreation() {
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço', Codigo_do_contrato__c = '123456789', ContractTerm = 12);
        insert cont;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST1234', isActive = true);
        insert prod;
        
        Item_do_Contrato__c item = new Item_do_Contrato__c();
        item.Name = 'Test Item 1';
        item.Quantidade__c = 100.00;
        item.Valor__c = 200.00;
        item.Contrato__c = cont.Id;
        item.NumeroItemContrato__c = 1;
        item.Produto__c = prod.Id;
        insert item;
    }
    
    static testMethod void testInvokeAPI_Success() {
        
        Item_do_Contrato__c itemQuery = [SELECT Id FROM Item_do_Contrato__c LIMIT 1];
        
        InvocableUpdateItemIniciadoSAP.Requests request = new InvocableUpdateItemIniciadoSAP.Requests();
        request.vItemId = itemQuery.Id;
        
        List<InvocableUpdateItemIniciadoSAP.Requests> requestList = new List<InvocableUpdateItemIniciadoSAP.Requests>();
        requestList.add(request);
        
        Test.startTest();
        List<InvocableUpdateItemIniciadoSAP.Results> results = InvocableUpdateItemIniciadoSAP.invokeAPI(requestList);
        Test.stopTest();
        
        System.assertEquals(true, results[0].vSucesso);
    }
    
}