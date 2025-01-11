@isTest
public class FaturaSAPServiceTest {
    @isTest
	static void test200() {
        String  jsonResponse= '{"value":[{"CodigoDoCliente":"C0008207","ContratoSAP":"8195","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-02-22","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        FaturaSAPService service = new FaturaSAPService();
        FaturaSAPDTO dto200 = service.executarGet();
        Test.stopTest();
        
		System.assertEquals(200, dto200.statusCode, 'StatusCode deve ser 200');
        System.assertEquals(true, String.isBlank(dto200.message), 'Message deve ser nulo');
        System.assertEquals('C0008207', dto200.value[0].CodigoDoCliente, 'CodigoDoCliente deve ser C0008207');
    }

    @isTest
	static void testOther() {
		String jsonResponse = '{}';
        HttpMock mock = new HttpMock(400, 'NOK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        FaturaSAPService service = new FaturaSAPService();
        FaturaSAPDTO dto400 = service.executarGet();
        Test.stopTest();
        
		System.assertEquals(400, dto400.statusCode, 'StatusCode deve ser 400');
        System.assertEquals(true, !String.isBlank(dto400.message), 'Message não deve ser nulo');
    }
}