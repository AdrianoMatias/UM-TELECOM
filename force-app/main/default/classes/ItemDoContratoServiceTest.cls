@isTest 
private class ItemDoContratoServiceTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContrato();
		List<Item_do_Contrato__c> listItem = [select Id, Numero_do_circuito__c FROM Item_do_Contrato__c];
		listItem.get(0).Numero_do_circuito__c = 'C00002';
		update listItem.get(0);

		List<Contract> listcontrat = [select Id, Codigo_do_contrato__c FROM Contract];
		listcontrat.get(0).Codigo_do_contrato__c = '10';
		update listcontrat.get(0);

		Service__c serv = new Service__c();
		serv.Is_Active__c =true;
		serv.Name = 'ItemDoContratoService';
		insert serv;

		Service_Version__c service_vrs = new Service_Version__c();
		service_vrs.Released__c = true;
		service_vrs.Name = 'VEXP';
		service_vrs.Handler__c = 'ItemDoContratoService_VEXP';
		service_vrs.Service__c = serv.Id;
		insert service_vrs;

		Product2 prodPost = new Product2();
		prodPost.Ate__c = 15;
		prodPost.De__c = 1;
		prodPost.Name = 'LAN TO LAN POST';
		prodPost.ProductCode = 'C000001';
		insert prodPost;
	}

	@isTest
	private static void testPatch() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/itemcontrato/C00002';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof('{"valor":1500,"status": "SUSPENSO","sales_item":"Bdr0AAC","numero_item":"C000002","enderecos":[{"tipo_logradouro":"Avenida","pais":"BR","numero":"10","municipio":"2611606","logradouro":"General Polidoro","estado":"PE","complemento":"Casa","cidade":"Recife","cep":"10510-220","bairro":"Varzea"},{"tipo_logradouro":"Avenida","pais":"BR","numero":"10","municipio":"2611606","logradouro":"General Polidoro","estado":"PE","complemento":"Casa","cidade":"Recife","cep":"10510-220","bairro":"Varzea"}],"circuito":"0000120",	"banda":"10240"}');
		
        RestContext.request = request;
		Test.startTest();
		ItemDoContratoService.doPatch();
		Test.stopTest();
	}

	@isTest
	private static void testPost() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/itemcontrato/10';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof('{"valor":1500,"status": "SUSPENSO","sales_item":"Bdr0AAC","numero_item":"C000001","enderecos":[{"tipo_logradouro":"Avenida","pais":"BR","numero":"10","municipio":"2611606","logradouro":"General Polidoro","estado":"PE","complemento":"Casa","cidade":"Recife","cep":"10510-220","bairro":"Varzea"},{"tipo_logradouro":"Avenida","pais":"BR","numero":"10","municipio":"2611606","logradouro":"General Polidoro","estado":"PE","complemento":"Casa","cidade":"Recife","cep":"10510-220","bairro":"Varzea"}],"circuito":"0000120",	"banda":"10240"}');
		
        RestContext.request = request;
		Test.startTest();
		ItemDoContratoService.doPost();
		Test.stopTest();
	}
}