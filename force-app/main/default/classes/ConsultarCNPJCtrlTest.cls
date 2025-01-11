@isTest
public class ConsultarCNPJCtrlTest {
    
    @testSetup
    static void dataCreation() {
        Account accObj = new Account();
        accObj.Name = 'Account Test';
        System.Database.insert(accObj);

        CNPJConfig__c conCONFIG = new CNPJConfig__c();
        conCONFIG.Name = 'MailingPostalCode';
        conCONFIG.Label__c = 'CEP de Correspondência';
        conCONFIG.From__c = 'MailingPostalCode';
        conCONFIG.To__c = 'MailingPostalCode';
        conCONFIG.Prefix__c = 'Con';
        insert conCONFIG;

        CNPJConfig__c accCONFIG = new CNPJConfig__c();
        accCONFIG.Name = 'BillingPostalCode';
        accCONFIG.Label__c = 'CEP de Cobrança';
        accCONFIG.From__c = 'BillingPostalCode';
        accCONFIG.To__c = 'BillingPostalCode';
        accCONFIG.Prefix__c = 'Acc';
        insert accCONFIG;

        CNPJConfig__c accCONFIG2 = new CNPJConfig__c();
        
        accCONFIG2.Name = 'CNPJ__c';
        accCONFIG2.Label__c = 'CNPJ';
        accCONFIG2.From__c = 'ShippingAddress';
        accCONFIG2.To__c = 'CNPJ__c';
        accCONFIG2.Prefix__c = 'Acc';
        insert accCONFIG2;

    }
    
    static testMethod void getCNPJsIf() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        System.Test.startTest();
        List<String> cnpjsList = ConsultarCNPJCtrl.getCNPJs(acc.Id);
        System.Test.stopTest();
        
        System.assert(!cnpjsList.isEmpty());
    }
    
    static testMethod void getCNPJsElse() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        System.Database.update(acc);
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        System.Test.startTest();
        List<String> cnpjsList = ConsultarCNPJCtrl.getCNPJs(acc.Id);
        System.Test.stopTest();
        
        System.assert(!cnpjsList.isEmpty());
    }
    
    static testMethod void selecionarCNPJ() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        System.Test.startTest();
        ConsultarCNPJCtrl.selecionarCNPJ('01.002.003/0004-05', acc.Id);
        System.Test.stopTest();
        
        List<Contact> sociosList = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.assert(!sociosList.isEmpty());
    }
    
}