@isTest
public class ItemSAPBatchProcessTest {

    @isTest
	static void testInsert() {
		String jsonResponse = '{"value":[{"ItemCode":"P006638","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
		String pbookEquipamentosId = TestFactoryData.createPricebook2('Equipamentos e Insumos').Id;

        Test.startTest();
        System.enqueueJob(new ItemSAPBatchProcess());
        Test.stopTest();
        
        List<Product2> prodList = [Select Id, ProductCode, isActive From Product2 Where ProductCode = 'P006638'];
        List<PricebookEntry> pbEntryList = [Select Id From PricebookEntry Where Pricebook2Id = :pbookEquipamentosId And Product2.ProductCode = 'P006638'];
        
        Assert.areEqual(1, prodList.size(), 'prodList deveria ser 1');
        Assert.areEqual('P006638', prodList[0].ProductCode, 'ProductCode deveria ser P006638');
        Assert.areEqual(1, pbEntryList.size(), 'pbEntryList deveria ser 1');    
    }

    @isTest
	static void testUpdate() {
		String jsonResponse = '{"value":[{"ItemCode":"P006638","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tNo","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        Product2 prodP = TestFactoryData.createProduct2('P006638', true);
        
        Test.startTest();
        System.enqueueJob(new ItemSAPBatchProcess());
        Test.stopTest();
        
        List<Product2> prodList = [Select Id, ProductCode, isActive From Product2 Where ProductCode = 'P006638'];
        
        Assert.areEqual(1, prodList.size(), 'prodList deveria ser 1');
        Assert.areEqual('P006638', prodList[0].ProductCode, 'ProductCode deveria ser P006638');
        Assert.areEqual(false, prodList[0].isActive, 'isActive deveria ser false');
    }
    
    @isTest
	static void testEx1() {
		String jsonResponse = '{"value":[{"ItemCode":"","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        System.enqueueJob(new ItemSAPBatchProcess());
        Test.stopTest();
    }
    
    @isTest
	static void testEx2() {
		String jsonResponse = '{"value":[{"ItemCode":"P00023","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"xxx","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}]}';
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        System.enqueueJob(new ItemSAPBatchProcess());
        Test.stopTest();
    }
}