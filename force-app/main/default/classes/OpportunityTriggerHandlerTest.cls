@isTest
private class OpportunityTriggerHandlerTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosAnaliseDeViabilidade();
	}
	
	@isTest
	private static void validarAnalise() {
		Test.startTest();
		Opportunity opp = [Select Id, StageName, By_pass__c FROM Opportunity WHERE Name =: 'Oportunidade teste Utils'];
		List<Analise_de_viabilidade__c> listAnalise = new List<Analise_de_viabilidade__c>();
		for(Analise_de_viabilidade__c analise : [SELECT Id FROM Analise_de_viabilidade__c WHERE Oportunidade__c =:opp.Id]){
			analise.Bairro_de_destino__c = 'Recife';
			analise.Cidade_de_destino__c = 'Recife';
			analise.Tipo_de_logradouro_destino__c = 'AVENIDA';
			analise.Rua_de_destino__c = 'Avenida Marques de Olinda';
			analise.numero_de_destino__c = '126';
			analise.CEP_de_destino__c = '50.030-000';
			analise.Estado_de_destino__c = 'PE';
			analise.Bairro_de_origem__c = 'Recife';
			analise.Cidade_de_origem__c = 'Recife';
			analise.Tipo_de_logradouro_origem__c = 'AVENIDA';
			analise.Rua_de_origem__c = 'Avenida Marques de Olinda';
			analise.numero_de_origem__c = '126';
			analise.CEP_de_origem__c = '50.030-000';
			analise.Estado_de_origem__c = 'PE';
			analise.Status__c = 'Concluída';
			analise.Prazo_de_Instalacao__c = 15;
			listAnalise.add(analise);
		}

		update listAnalise;
		
		opp.By_pass__c = false;
		opp.StageName = 'Negociação de valores';
		update opp;
		
        OpportunityLineItem item = [SELECT ID, OpportunityId, ProductCode, Product2.Ate__c FROM OpportunityLineItem WHERE OpportunityID =: opp.Id AND ProductCode = 'C000001' LIMIT 1];
        
        item.Quantity = 5;
        update item;
        
		Test.stopTest();
	}

	@isTest
	private static void cancelarAnalise() {
		Test.startTest();
		Opportunity opp = [Select Id, StageName, By_pass__c FROM Opportunity WHERE Name =: 'Oportunidade teste Utils'];
		
		opp.By_pass__c = false;
		update opp;

		opp.By_pass__c = true;
		update opp;
		Test.stopTest();
	}

	@isTest
	private static void criarContratoTest() {
		Test.startTest();
		Opportunity opp = [Select Id, StageName, By_pass__c, Validado_juridico__c,Validado_financeiro__c FROM Opportunity WHERE Name =: 'Oportunidade teste Utils'];
		opp.By_pass__c = true;
		opp.Validado_juridico__c = true;
		opp.Validado_financeiro__c = true;
		opp.Description = 'Teste Umtelecom';
		opp.StageName = 'Contrato';
		update opp;
		
		Test.stopTest();
	}
}