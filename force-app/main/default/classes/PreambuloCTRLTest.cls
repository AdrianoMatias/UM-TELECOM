@isTest 
private class PreambuloCTRLTest {
	
	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContrato();
	}
	@isTest
	private static void testName() {
		Test.startTest();
		ApexPages.StandardController std = new ApexPages.StandardController([Select Id FROM Contract]);
		PreambuloCTRL preambulo = new PreambuloCTRL(std);
		Test.stopTest();

	}
}