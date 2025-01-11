@isTest 
private class SolicitacaoDiversaTriggerHandlerTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContrato();

		Group fila = new Group();
		fila.Type = 'Queue';
		fila.Name = 'TI';
		insert fila;
		
		Item_do_Contrato__c item = [Select Id, Status__c FROM Item_do_Contrato__c WHERE Name =: 'Lan 1 - 10MB' Limit 1];
		item.Status__c = 'INICIADO';
		update item;
	}

	@isTest
	private static void inseriSD() {
		
		Test.startTest();
		Solicitacao_Diversa__c sol = new Solicitacao_Diversa__c();
		sol.Conta__c = [Select Id FROM Account].Id;
		sol.Tipo_de_Solicitacao__c = 'Upgrade';
		sol.Justificativa__c = 'teste solicitação diversa';
		sol.Status__c = 'Nova';
		sol.Setor__c = 'TI';
		sol.Produto__c = [Select Id FROM Product2 WHERE Name =: 'Lan 1 - 10MB' Limit 1].Id;
		sol.Item_do_Contrato__c = [Select Id FROM Item_do_Contrato__c WHERE Name =: 'Lan 1 - 10MB' Limit 1].Id;
		sol.Valor_da_solicitacao_diversa__c = 20;
		insert sol;

		sol.banda__c = 5;
		sol.Data_de_Inicio__c = Date.today();
		sol.Status__c = 'Em andamento';
        sol.Valor_da_solicitacao_diversa__c = 20;
		update sol;

		sol.Status__c = 'Concluída';
		update sol;

		Test.stopTest();
	}
}