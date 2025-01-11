@isTest
public class FaturaSAPSchedulableTest {
    @isTest
	static void testInvokeProces() {
		String jsonResponse = '{"value":[{"CodigoDoCliente":"C0008207","ContratoSAP":"8195","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-02-22","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
		String accountId = TestFactoryData.createAccount('C0008207').Id;
        String contractId = TestFactoryData.createContract(accountId, '8195').Id;

        Test.startTest();
        FaturaSAPSchedulable.invokeProces();
        Test.stopTest();
        
        List<Fatura__c> faturaList = [Select Id, StatusDaFatura__c From Fatura__c Where Conta__c = :accountId And Contrato__c = :contractId];
        
        Assert.areEqual(1, faturaList.size(), 'faturaList deveria ser 1');
    }
    
    @isTest
	static void testExecute() {
        String jsonResponse = '{}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);        
        String CRON_EXP = '0 0 23 * * ?';
		Test.startTest();
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new FaturaSAPSchedulable());
		Test.stopTest();
		System.abortJob(jobId);

    }
}