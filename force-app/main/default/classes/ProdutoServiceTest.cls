@isTest 
private class ProdutoServiceTest {

	@TestSetup
	private static void setupDados(){

		Service__c serv = new Service__c();
		serv.Is_Active__c =true;
		serv.Name = 'ProdutoService';
		insert serv;

		Service_Version__c service_vrs = new Service_Version__c();
		service_vrs.Released__c = true;
		service_vrs.Name = 'VEXP';
		service_vrs.Handler__c = 'ProdutoService_VEXP';
		service_vrs.Service__c = serv.Id;
		insert service_vrs;

		Product2 produtoPatch = new Product2();
		produtoPatch.Name = 'Dreamm produto';
		produtoPatch.ProductCode = 'C00001';
		produtoPatch.Chave_Externa__c = 'C00001';
		produtoPatch.Family = 'Cabos';
		insert produtoPatch;
	}

	@isTest
	private static void testDoPost() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/produto/C00004';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof('{ "codigo": "C00004","nome": "Internet Fibra", "descricao": "Descrição 33", "familia": "Cabos"}');
		
        RestContext.request = request;
		Test.startTest();
		ProdutoService.doPost();
		Test.stopTest();
	}
    
   	@isTest
	private static void testDoPatch() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/produto/C00001';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof('{ "codigo": "C00001","nome": "Internet Fibra", "descricao": "Teste 33", "familia": "Cabos"}');
		
        RestContext.request = request;
		Test.startTest();
		ProdutoService.doPatch();
		Test.stopTest();
	}
}