@isTest
public class ItemSAPSchedulableTest {

    @isTest
	static void testInvokeProces() {
		String jsonResponse = '{"value":[{"ItemCode":"P006638","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tNo","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        Product2 prodP = TestFactoryData.createProduct2('P006638', true);
        
        Test.startTest();
        ItemSAPSchedulable.invokeProces();
        Test.stopTest();
        
        List<Product2> prodList = [Select Id, ProductCode, isActive From Product2 Where ProductCode = 'P006638'];
        
        Assert.areEqual(1, prodList.size(), 'prodList deveria ser 1');
        Assert.areEqual('P006638', prodList[0].ProductCode, 'ProductCode deveria ser P006638');
        Assert.areEqual(false, prodList[0].isActive, 'isActive deveria ser false');
    }

    @isTest
	static void testExecute() {
		String jsonResponse = '{"value":[{"ItemCode":"P006638","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tNo","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);        
        String CRON_EXP = '0 0 23 * * ?';
		Test.startTest();
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new ItemSAPSchedulable());
		Test.stopTest();
		System.abortJob(jobId);

    }
}