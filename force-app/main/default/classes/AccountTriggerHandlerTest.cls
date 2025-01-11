@isTest 
private class AccountTriggerHandlerTest {

	@isTest
	private static void testCatalogo() {
		Test.startTest();
		TestUtils.dadosProdutoCatalogo();
		TestUtils.dadosConta();
		Test.stopTest();
	}
}