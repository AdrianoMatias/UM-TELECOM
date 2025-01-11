@isTest
private class TituloFinanceiroServiceTest {

	@TestSetup
	private static void setupDados(){
        //Comentado iSmartblue 06/05/2024
		//TestUtils.dadosContrato();

		Service__c serv = new Service__c();
		serv.Is_Active__c =true;
		serv.Name = 'TituloFinanceiroService';
		insert serv;

		Service_Version__c service_vrs = new Service_Version__c();
		service_vrs.Released__c = true;
		service_vrs.Name = 'VEXP';
		service_vrs.Handler__c = 'TituloFinanceiroService_VEXP';
		service_vrs.Service__c = serv.Id;
		insert service_vrs;

		/*Account conta = [Select Id, Codigo_SAP_cliente__c FROM Account];
		conta.Codigo_SAP_cliente__c = 'C0007043';
		update conta;
        
        Contract contrato = [Select Id, Codigo_do_contrato__c FROM Contract];
		contrato.Codigo_do_contrato__c = '1111';
		update contrato;*/
        
        Account acc = new Account();
        acc.Name = 'Teste Account';
        acc.Grupo__c = '103';
        acc.Codigo_SAP_cliente__c = 'C0007043';
        insert acc;
        
        Contract cont = new Contract();
        cont.AccountId = acc.Id;
        cont.Status = 'Esboço';
        cont.Codigo_do_contrato__c = '1111';
        insert cont;
        
		Titulo_Financeiro__c tituloFinanceiro = new Titulo_Financeiro__c();
		tituloFinanceiro.Conta__c = [Select Id FROM Account].Id;
		tituloFinanceiro.Name = '11112' ;
		tituloFinanceiro.Codigo_Cliente__c = 'C0007043';
        tituloFinanceiro.Codigo_Contrato__c = '1111';
        tituloFinanceiro.Competencia__c = '02/2020';
        tituloFinanceiro.Fatura__c = 2;
        tituloFinanceiro.BoletoID__c = 1;
        tituloFinanceiro.Emissao__c = Date.today();
        tituloFinanceiro.Vencimento__c = Date.today().addDays(30);
        tituloFinanceiro.Valor_Fatura__c = 1.80;
        tituloFinanceiro.Valor_Pago__c = 1.80;
        tituloFinanceiro.Status__c = 'Pago';
		insert tituloFinanceiro;
	}
		
	@isTest
	private static void testDoPost() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/titulo-financeiro/';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof('{"contrato": 1111,"codigoCliente": "C0007043","competencia": "02/2020", "fatura": 4, "boletoID": 1,"emissao" : "2020-02-10","vencimento" : "2020-02-28","valorFatura" : 1.80, "valorPago" : 1.80, "status" : "Aberto"}');
		
        RestContext.request = request;
		Test.startTest();
		TituloFinanceiroService.doPost();
		Test.stopTest();
	}

	@isTest
	private static void testDoPatch() {
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://umtelecomdreamm.com/services/apexrest/umtelecom/VEXP/titulo-financeiro/C0007043';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof('{"contrato": 1111,"codigoCliente": "C0007043","competencia": "02/2020", "fatura": 2, "boletoID": 1,"emissao" : "2020-02-10","vencimento" : "2020-02-28","valorFatura" : 1.80, "valorPago" : 1.80, "status" : "Aberto"}');
		
        RestContext.request = request;
		Test.startTest();
		TituloFinanceiroService.doPatch();
		Test.stopTest();
	}
}