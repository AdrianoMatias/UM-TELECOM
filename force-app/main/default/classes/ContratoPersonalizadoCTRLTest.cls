@isTest 
private class ContratoPersonalizadoCTRLTest {

	@testSetup 
	private static void setup() {
		
		TestUtils.dadosContrato();
	}

	@isTest static void testSaveDocument() {
		Test.startTest();
		// Create a ContentVersion
        ContentVersion ContentVer = new ContentVersion();
        ContentVer.Title = 'My Doc';
        ContentVer.ContentUrl= 'test.com';
        Insert ContentVer;
        
        // Create a ContentDocumentLink
        Contract contrato = [Select Id from Contract];

        ContentDocumentLink ContentDL = new ContentDocumentLink();
        ContentDL.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: ContentVer.Id].ContentDocumentId;
        ContentDL.LinkedEntityId=contrato.id;
        ContentDL.ShareType='V';
        Insert ContentDL;

		ContratoPersonalizadoCTRL.updateContract(ContentDL.ContentDocumentId, ContentVer.Title, contrato.Id);
		ContratoPersonalizadoCTRL.getDataDocument(contrato.Id);
		ContratoPersonalizadoCTRL.updateContract(ContentDL.ContentDocumentId, ContentVer.Title, contrato.Id);
		ContratoPersonalizadoCTRL.deleteDocument(contrato.Id);
		Test.stopTest();
	}
	@isTest static void testMarcarEnvio() {
        Contract contrato = [Select Id from Contract];
        
        Test.startTest();
		Boolean excecao = false;
		try {
			ContratoPersonalizadoCTRL.marcarEnvio(contrato.id, true);
		} catch( Exception ex ) {
			System.debug(ex.getMessage());
			System.debug(ex.getStackTraceString());
			excecao = true;
		}
		Test.stopTest();
    }
}