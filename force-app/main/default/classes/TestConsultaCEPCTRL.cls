@IsTest
private class TestConsultaCEPCTRL {

    @TestSetup
    static void loadData(){
        Account conta = new Account();

        conta.Name = 'Teste Viabilidade Dreamm';
        conta.CNPJ__c = '00.000.000/0000-21';
        conta.Type = 'Prospect';

        insert conta;

        Opportunity oportunidade = new Opportunity();
        oportunidade.AccountId = conta.Id;
        oportunidade.Name = 'Oportunidade de Teste Viabilidade Dreamm';
        oportunidade.Meses__c = 12;
        oportunidade.Dia_do_vencimento__c = '1';
        oportunidade.StageName = 'Mapeamento';
        oportunidade.CloseDate = Date.Today();
        insert oportunidade;

        oportunidade.StageName = 'Viabilidade';
        update oportunidade;

        Analise_de_viabilidade__c analiseViabilidade = new Analise_de_viabilidade__c();
        analiseViabilidade.RecordTypeId = Schema.SObjectType.Analise_de_viabilidade__c.getRecordTypeInfosByName().get('Lan to Lan (L2L)').getRecordTypeId();
        analiseViabilidade.Oportunidade__c = oportunidade.Id;
        analiseViabilidade.Pendencia__c = 'Sem Pendência';
        analiseViabilidade.CEP_de_origem__c = '50000123';
        analiseViabilidade.CEP_de_destino__c = '50000123';
        insert analiseViabilidade;
    }

    @IsTest
    static void testSuccess(){
        Analise_de_viabilidade__c analiseViabilidade = [Select Id from Analise_de_viabilidade__c];

        Map<String,Object> response = new Map<String,Object>();
        Correios.consultaCEPResponse response_x = new Correios.consultaCEPResponse();
        response_x.return_x = new Correios.enderecoERP();
        response_x.return_x.bairro = 'Bairro Test';
        response_x.return_x.cep = '55123222';
        response_x.return_x.cidade = 'Cidade Test';
        response_x.return_x.complemento2 = 'Complemento Test';
        response_x.return_x.end_x = 'Rua Test';
        response_x.return_x.uf = 'SP';
        response.put('response_x',response_x);

        SOAPMock mock = new SOAPMock(response);
        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();
        Boolean hasErrors = false;
        try {
            ConsultaCEPCTRL.consultaCEP( analiseViabilidade.Id );
        } catch (Exception e) {
            hasErrors = true;
        }
        Test.stopTest();

        System.assert(!hasErrors);
        analiseViabilidade = [Select Id, Bairro_de_origem__c, Bairro_de_destino__c, Cidade_de_origem__c, Cidade_de_destino__c from Analise_de_viabilidade__c];
        System.assertEquals('Bairro Test', analiseViabilidade.Bairro_de_origem__c);
        System.assertEquals('Bairro Test', analiseViabilidade.Bairro_de_destino__c);
        System.assertEquals('Cidade Test', analiseViabilidade.Cidade_de_origem__c);
        System.assertEquals('Cidade Test', analiseViabilidade.Cidade_de_destino__c);
    }
    
    @IsTest
    static void testErrorCepPreenchido(){
        Analise_de_viabilidade__c analiseViabilidade = [Select Id from Analise_de_viabilidade__c];
        analiseViabilidade.CEP_de_origem__c = null;
        analiseViabilidade.CEP_de_destino__c = null;
        update analiseViabilidade;
        
        Map<String,Object> response = new Map<String,Object>();
        Correios.consultaCEPResponse response_x = new Correios.consultaCEPResponse();
        response_x.return_x = new Correios.enderecoERP();
        response_x.return_x.bairro = 'Bairro Test';
        response_x.return_x.cep = '55123222';
        response_x.return_x.cidade = 'Cidade Test';
        response_x.return_x.complemento2 = 'Complemento Test';
        response_x.return_x.end_x = 'Rua Test';
        response_x.return_x.uf = 'SP';
        response.put('response_x',response_x);

        SOAPMock mock = new SOAPMock(response);
        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();
        Boolean hasErrors = false;
        try {
            ConsultaCEPCTRL.consultaCEP( analiseViabilidade.Id );
        } catch (Exception e) {
            hasErrors = true;
        }
        Test.stopTest();

        System.assert(hasErrors);
    }
    
    @IsTest
    static void testErrorOrigem(){
        Analise_de_viabilidade__c analiseViabilidade = [Select Id from Analise_de_viabilidade__c];
        analiseViabilidade.CEP_de_destino__c = null;
        update analiseViabilidade;
        
        Map<String,Object> response = new Map<String,Object>();
        response.put('response_x',null);

        SOAPMock mock = new SOAPMock(response);
        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();
        Boolean hasErrors = false;
        try {
            ConsultaCEPCTRL.consultaCEP( analiseViabilidade.Id );
        } catch (Exception e) {
            hasErrors = true;
        }
        Test.stopTest();

        System.assert(hasErrors);
    }
    
    @IsTest
    static void testErrorDestino(){
        Analise_de_viabilidade__c analiseViabilidade = [Select Id from Analise_de_viabilidade__c];
        analiseViabilidade.CEP_de_origem__c = null;
        update analiseViabilidade;
        
        Map<String,Object> response = new Map<String,Object>();
        response.put('response_x',null);

        SOAPMock mock = new SOAPMock(response);
        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();
        Boolean hasErrors = false;
        try {
            ConsultaCEPCTRL.consultaCEP( analiseViabilidade.Id );
        } catch (Exception e) {
            hasErrors = true;
        }
        Test.stopTest();

        System.assert(hasErrors);
    }
}