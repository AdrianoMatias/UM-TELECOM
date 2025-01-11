@isTest
public class ItemSAPBatchUpdateProductTest {

    @isTest
    static void testMethod1(){

		Product2 product = TestFactoryData.createProduct2('P006638', true);

        Test.startTest();
		product.IsActive = false;
        List<Product2> listObj = new List<Product2>{product};
		Database.executeBatch(new ItemSAPBatchUpdateProduct(listObj), 1);
		Test.stopTest();

		Product2 result = [Select Id, IsActive From Product2 Where ProductCode = 'P006638' LIMIT 1];
    
        Assert.areEqual(false, result.IsActive, 'Deveria ser false');        
    }
}