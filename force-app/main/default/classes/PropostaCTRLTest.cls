@isTest 
private class PropostaCTRLTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosAnaliseDeViabilidade();
		Opportunity opp = [SELECT Id, StageName, By_pass__c FROM Opportunity WHERE Name = 'Oportunidade teste Utils'];
		opp.StageName = 'Proposta';
		opp.By_pass__c= true;
		update opp;
	}

	@isTest
	private static void testName() {
		Test.startTest();
		ApexPages.StandardController std = new ApexPages.StandardController([Select Id FROM Opportunity]);
		PropostaCTRL preambulo = new PropostaCTRL(std);
		Test.stopTest();
	}
}