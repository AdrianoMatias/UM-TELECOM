@isTest
public class FaturaSAPBatchProcessTest {

    @isTest
	static void testInsert() {
        String codigoCliente = 'C0008207';
        String contratoSAP = '8195';
		String jsonResponse = '{"value":[{"CodigoDoCliente":"'+codigoCliente+'","ContratoSAP":"'+contratoSAP+'","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-02-22","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
		String accountId = TestFactoryData.createAccount(codigoCliente).Id;
        String contractId = TestFactoryData.createContract(accountId, contratoSAP).Id;

        Test.startTest();
        System.enqueueJob(new FaturaSAPBatchProcess());
        Test.stopTest();
        
        List<Fatura__c> faturaList = [Select Id, StatusDaFatura__c From Fatura__c Where Conta__c = :accountId And Contrato__c = :contractId];
        
        Assert.areEqual(1, faturaList.size(), 'faturaList deveria ser 1');
    }

    @isTest
	static void testUpsert() {
        String codigoCliente = 'C0008207';
        String contratoSAP = '8195';
		String jsonResponse = '{"value":[{"CodigoDoCliente":"'+codigoCliente+'","ContratoSAP":"'+contratoSAP+'","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-02-22","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
		String accountId = TestFactoryData.createAccount(codigoCliente).Id;
        String contractId = TestFactoryData.createContract(accountId, contratoSAP).Id;
        String faturaId = TestFactoryData.createFatura(accountId, contractId, 114797).Id;

        Test.startTest();
        System.enqueueJob(new FaturaSAPBatchProcess());
        Test.stopTest();
        
        List<Fatura__c> faturaList = [Select Id, StatusDaFatura__c From Fatura__c Where Id = :faturaId];
        
        Assert.areEqual('Atrasada', faturaList[0].StatusDaFatura__c, 'StatusDaFatura__c deveria ser Atrasada');
    }

	@isTest
    static void testEx1() {
		Exception ex1;
        String errorMessage1 = 'CodigoDoCliente não pode ser vazio';

        String codigoCliente = '';
        String contratoSAP = '8195';
		String jsonResponse = '{"value":[{"CodigoDoCliente":"'+codigoCliente+'","ContratoSAP":"'+contratoSAP+'","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-02-22","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
		String accountId = TestFactoryData.createAccount('C0008207').Id;
        String contractId = TestFactoryData.createContract(accountId, contratoSAP).Id;

        Test.startTest();
		System.enqueueJob(new FaturaSAPBatchProcess());
        Test.stopTest();
        
        List<Fatura__c> faturaList = [Select Id, StatusDaFatura__c From Fatura__c Where Conta__c = :accountId And Contrato__c = :contractId];
        
        Assert.areEqual(0, faturaList.size(), 'faturaList deveria ser 0');
    }
    
	@isTest
	static void testEx2() {
        String codigoCliente = 'C0008207';
        String contratoSAP = '8195';
		String jsonResponse = '{"value":[{"CodigoDoCliente":"'+codigoCliente+'","ContratoSAP":"'+contratoSAP+'","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"xxx","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
		String accountId = TestFactoryData.createAccount(codigoCliente).Id;
        String contractId = TestFactoryData.createContract(accountId, contratoSAP).Id;

        Test.startTest();
        System.enqueueJob(new FaturaSAPBatchProcess());
        Test.stopTest();
        
        List<Fatura__c> faturaList = [Select Id, StatusDaFatura__c From Fatura__c Where Conta__c = :accountId And Contrato__c = :contractId];
        
        Assert.areEqual(0, faturaList.size(), 'faturaList deveria ser 0');
    }

}