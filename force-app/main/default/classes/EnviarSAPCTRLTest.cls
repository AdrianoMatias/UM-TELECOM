@isTest 
private class EnviarSAPCTRLTest {

	@TestSetup 
	private static void setupDados(){
		Municipios__c municipio = new Municipios__c();
		municipio.Name = 'Recife';
		municipio.Estado__c = 'PE';
		municipio.Codigo_IBGE__c = '2611606';
		insert municipio;

		List<Integracoes__c> integracoes = new List<Integracoes__c>();
		Integracoes__c integracao1 = new Integracoes__c();
		integracao1.Name = 'Cliente';
		integracao1.Token__c = 'teste';
		integracao1.url__c = 'teste%codigo';
		integracao1.Metodo__c = 'POST';
		integracoes.add(integracao1);

		Integracoes__c integracao2 = new Integracoes__c();
		integracao2.Name = 'Endereço';
		integracao2.Token__c = 'teste';
		integracao2.url__c = 'teste%codigo';
		integracao2.Metodo__c = 'POST';
		integracoes.add(integracao2);

		Integracoes__c integracao3 = new Integracoes__c();
		integracao3.Name = 'Contato';
		integracao3.Token__c = 'teste';
		integracao3.url__c = 'teste%codigo';
		integracao3.Metodo__c = 'POST';
		integracoes.add(integracao3);

		Integracoes__c integracao4 = new Integracoes__c();
		integracao4.Name = 'Contrato';
		integracao4.Token__c = 'teste';
		integracao4.url__c = 'teste%codigo';
		integracao4.Metodo__c = 'POST';
		integracoes.add(integracao4);

		insert integracoes;

		TestUtils.dadosContrato();
	}

	@isTest
	private static void testGetCliente() {

		String jsonStringCliente  = '{"codigo":"C0007044"}';
        Account acc = [SELECT Id, CNPJ__c  FROM Account];
        system.debug('acc' + acc);
        
        HttpMock mock = new HttpMock(200,'OK',jsonStringCliente, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
			EnviarSAPCTRL.getEnvioSAPCliente(acc.Id,'C');
		Test.stopTest();

	}

	@isTest
	private static void testGetContrato() {

		String jsonStringCliente  = '{"contrato":"5172","itens":[{"sales_item":"a040v000002Bdr0AAC","circuito":"0051720001"}]}';
		Opportunity opp = [SELECT Id FROM Opportunity];
		 Map<Id,OpportunityLineItem> mapOpp = new Map<Id,OpportunityLineItem>([SELECT Id FROM OpportunityLineItem where OpportunityId =:opp.Id]);
        system.debug('opp' + opp);
        
        HttpMock mock = new HttpMock(200,'OK',jsonStringCliente, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
			EnviarSAPCTRL.getEnvioSAPContrato(opp.Id, JSON.serialize(mapOpp.keyset()));
		Test.stopTest();

	}
}