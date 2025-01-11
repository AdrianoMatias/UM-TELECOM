@isTest 
private class ContratoServiceTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContrato();

		Account contaTeste = [select Id FROM Account LIMIT 1];
		contaTeste.Codigo_SAP_cliente__c = 'C0003243';
		update contaTeste;

		List<Item_do_Contrato__c> listItem = [select Id, Status__c FROM Item_do_Contrato__c];
		for(Item_do_Contrato__c i : listItem)
			i.Status__c = 'INICIADO';
		update listItem;

		List<Contract> listcontrat = [select Id, Codigo_do_contrato__c FROM Contract];
		listcontrat.get(0).Codigo_do_contrato__c = '5050';
		listcontrat.get(0).Status = 'Autorizado';
		update listcontrat.get(0);

		Service__c serv = new Service__c();
		serv.Is_Active__c =true;
		serv.Name = 'ContratoService';
		insert serv;

		Service_Version__c service_vrs = new Service_Version__c();
		service_vrs.Released__c = true;
		service_vrs.Name = 'VEXP';
		service_vrs.Handler__c = 'ContratoService_VEXP';
		service_vrs.Service__c = serv.Id;
		insert service_vrs;

		Group fila = new Group();
		fila.Type = 'Queue';
		fila.Name = 'TI';
		insert fila;

		Solicitacao_Diversa__c sol = new Solicitacao_Diversa__c();
		sol.Conta__c = [Select Id FROM Account].Id;
		sol.Tipo_de_Solicitacao__c = 'Troca de titularidade';
		sol.Justificativa__c = 'teste solicitação diversa';
		sol.Status__c = 'Em andamento';
		sol.Contrato__c = [Select Id, ContractNumber FROM Contract LIMIT 1].Id;
		sol.Setor__c = 'TI';
		sol.Produto__c = [Select Id FROM Product2 WHERE Name =: 'Lan 1 - 10MB' Limit 1].Id;
		sol.Item_do_Contrato__c = [Select Id FROM Item_do_Contrato__c WHERE Name =: 'Lan 1 - 10MB' Limit 1].Id;
        sol.Valor_da_solicitacao_diversa__c = 20;
		insert sol;

	}

	@isTest
	private static void testPatch() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/contrato/5050';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof('{"dia_vencimento":5,"descricao":"Teste 2020 UmTelecom","data_inicio":"2020-05-07","cortesia":"N","valido_ate":"2021-04-30","permuta":"N"}');
		
        RestContext.request = request;
		Test.startTest();
			ContratoService.doPatch();
		Test.stopTest();
	}

	@isTest
	private static void testPost() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/contrato/C0003243';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof('{"dia_vencimento":5,"descricao":"Teste 2020 UmTelecom","data_inicio":"2020-05-07","cortesia":"N","valido_ate":"2021-04-30","permuta":"N","codigo_contrato":"5051","itens":[{"valor":1500,"numero_item":"C000001","circuito":"000005050188","status":"INICIADO","banda":"10240","enderecos":[{"tipo_logradouro":"Avenida","pais":"BR","numero":"10","municipio":"2611606","logradouro":"General Polidoro","estado":"PE","complemento":"Casa","cidade":"Recife","cep":"10510-220","bairro":"Varzea"},{"tipo_logradouro":"Avenida","pais":"BR","numero":"10","municipio":"2611606","logradouro":"General Polidoro","estado":"PE","complemento":"Casa","cidade":"Recife","cep":"10510-220","bairro":"Varzea"}]},{"valor":4500,"numero_item":"C000001","status":"INICIADO","enderecos":[{"tipo_logradouro":"Avenida","pais":"BR","numero":"110","municipio":"2607802","logradouro":"Antonio Carlos de Almeida","estado":"PE","complemento":"Casa","cidade":"Itaquitinga","cep":"55950000","bairro":"Centro"},{"tipo_logradouro":"Avenida","numero":"110","municipio":"2607802","logradouro":"Antonio Carlos de Almeida","estado":"PE","complemento":"Casa","cidade":"Itaquitinga","cep":"55950000","bairro":"Centro"}],"circuito":"000005050189","banda":"10240"}]}');
		
        RestContext.request = request;
		Test.startTest();
			ContratoService.doPost();
		Test.stopTest();
	}
}