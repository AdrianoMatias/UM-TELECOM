@isTest 
private class VisualizarEnvioPropostaTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContaOportunidade();
		Opportunity opp = [SELECT Id, StageName, By_pass__c FROM Opportunity WHERE Name = 'Oportunidade teste Utils'];
		opp.StageName = 'Proposta';
		opp.By_pass__c= true;
		update opp;
	}

	@isTest
	private static void VisualizarPreambuloTest() {
		Opportunity opp = [Select Id FROM Opportunity WHERE Name = 'Oportunidade teste Utils'];
		Test.startTest();
			VisualizarEnvioProposta.visualizarPropostaCTRL(opp.Id);
		Test.stopTest();

	}

	@isTest
	private static void enviarPreambuloTest() {
		Opportunity opp = [Select Id FROM Opportunity WHERE Name = 'Oportunidade teste Utils'];
		Test.startTest();
			VisualizarEnvioProposta.enviarProposta(opp.Id);
		Test.stopTest();

	}
}