@isTest 
private class VisualizarEnvioPreambuloCTRLTest {
	
	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContrato();
	}

	@isTest
	private static void VisualizarPreambuloTest() {
		Contract contrato = [Select Id FROM Contract];
		Test.startTest();
			VisualizarEnvioPreambuloCTRL.visualizarPreambulo(contrato.Id);
		Test.stopTest();

	}

	@isTest
	private static void enviarPreambuloTest() {
		Contract contrato = [Select Id FROM Contract];
		List<Contact> listContato = [Select Id FROM Contact];
		List<String> listId = new List<String>();
		for(Contact c : listContato){
			listId.add(c.Id);
		}
		Test.startTest();
			VisualizarEnvioPreambuloCTRL.enviarPreambulo(contrato.Id,JSON.serialize(listId));
		Test.stopTest();

	}
}