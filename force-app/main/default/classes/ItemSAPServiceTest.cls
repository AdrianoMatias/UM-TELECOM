@isTest
public class ItemSAPServiceTest {

    @isTest
	static void test200() {
		String jsonResponse = '{"value":[{"ItemCode":"P006638","ItemName":"Test Product","InventoryUOM":"UN","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemSAPService service = new ItemSAPService();
        ItemSAPDTO dto200 = service.executarGet();
        Test.stopTest();
        
		System.assertEquals(200, dto200.statusCode, 'StatusCode deve ser 200');
        System.assertEquals(true, String.isBlank(dto200.message), 'Message deve ser nulo');
        System.assertEquals('P006638', dto200.value[0].ItemCode, 'ItemCode deve ser P006638');
    }

    @isTest
	static void testOther() {
		String jsonResponse = '{}';
        HttpMock mock = new HttpMock(400, 'NOK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemSAPService service = new ItemSAPService();
        ItemSAPDTO dto400 = service.executarGet();
        Test.stopTest();
        
		System.assertEquals(400, dto400.statusCode, 'StatusCode deve ser 400');
        System.assertEquals(true, !String.isBlank(dto400.message), 'Message não deve ser nulo');
    }
}