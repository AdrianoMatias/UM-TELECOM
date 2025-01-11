@isTest
public class InvocableEnvioContaSAP_Test {
    
    @isTest
    static void invocableSuccess1() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Grupo__c = '103';
        acc.CNPJ__c = '37.231.827/0001-16';
        acc.Razao_Social__c = 'Teste LTDA';
        acc.BillingStreet = 'Test';
        //acc.BillingCity = 'Osasco';
        acc.Bairro_de_cobranca__c = 'Jardim das Flores';
        acc.BillingPostalCode = '06180-114';
        acc.BillingState = 'SP';
        acc.Complemento_de_cobranca__c = 'Apto 43';
        acc.Tipo_de_logradouro_cobranca__c = 'Rua';
        acc.Numero_de_cobranca__c = '123';
        acc.ShippingStreet = 'Test';
        //acc.ShippingCity = 'Osasco';
        acc.Bairro_de_entrega__c = 'Jardim das Flores';
        acc.ShippingPostalCode = '06180-114';
        acc.ShippingState = 'SP';
        acc.Complemento_de_entrega__c = 'Apto 43';
        acc.Tipo_de_logradouro_entrega__c = 'Rua';
        acc.Numero_de_entrega__c = '123';
        insert acc;
        
        Contact ctt = new Contact(AccountId = acc.Id, LastName = 'Test Name', Email = 'test@test.com.br');
        insert ctt;
        
        InvocableEnvioContaSAP.Requests request = new InvocableEnvioContaSAP.Requests();
        request.vAccountId = acc.Id;
        
        List<InvocableEnvioContaSAP.Requests> requestList = new List<InvocableEnvioContaSAP.Requests>();
        requestList.add(request);
        
        Test.startTest();
        List<InvocableEnvioContaSAP.Results> results = InvocableEnvioContaSAP.Executa(requestList);
        Test.stopTest();
        
    }
    
}