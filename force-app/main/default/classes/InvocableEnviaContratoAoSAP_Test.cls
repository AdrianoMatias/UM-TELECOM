@isTest
public class InvocableEnviaContratoAoSAP_Test {
    
    @isTest
    static void invocableSuccess1() {
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103', Codigo_SAP_cliente__c = 'C568956');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço', DiaVencimento__c = '12', ContractTerm = 12);
        insert cont;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST1234', isActive = true);
        insert prod;
        
        Item_do_Contrato__c item1 = new Item_do_Contrato__c();
        item1.Conta__c = acc.Id;
        item1.Name = 'Test Item 1';
        item1.Quantidade__c = 100.00;
        item1.Valor__c = 200.00;
        item1.Contrato__c = cont.Id;
        item1.NumeroItemContrato__c = 1;
        item1.Produto__c = prod.Id;
        insert item1;
      
        List<String> queryString1 = new List<String>{cont.Id};
            
        Test.startTest();
        InvocableEnviaContratoAoSAP.invokeBatchEnviaContratoSAP(queryString1);
        Test.stopTest();
    }
    
    @isTest
    static void invocableSuccess2() {
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103', Codigo_SAP_cliente__c = 'C568956');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço', DiaVencimento__c = '12', ContractTerm = 12, Codigo_do_contrato__c = '45122');
        insert cont;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST1234', isActive = true);
        insert prod;
        
        Item_do_Contrato__c item2 = new Item_do_Contrato__c();
        item2.Name = 'Test Item 2';
        item2.Conta__c = acc.Id;
        item2.Quantidade__c = 100.00;
        item2.Valor__c = 200.00;
        item2.Contrato__c = cont.Id;
        item2.NumeroItemContrato__c = 2;
        item2.Produto__c = prod.Id;
        insert item2;
        
        List<String> queryString1 = new List<String>{cont.Id};
            
        Test.startTest();
        InvocableEnviaContratoAoSAP.invokeBatchEnviaContratoSAP(queryString1);
        Test.stopTest();
    }
    
}