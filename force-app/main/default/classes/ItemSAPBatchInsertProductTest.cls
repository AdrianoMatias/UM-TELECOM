@isTest
public class ItemSAPBatchInsertProductTest {

    @isTest
    static void testMethod1(){
        List<Product2> listObj = new List<Product2>();

        Product2 prod = new Product2();
        
        prod.ProductCode = 'S006638';
        prod.Name = 'Test Product';
        prod.Description = 'Test Product';
        prod.QuantityUnitOfMeasure = 'UN';
        prod.IsActive = true;
        prod.UltimaAtualizacaoDoProdutoNoSap__c = Date.today();
        
        listObj.add(prod);
        
        Test.startTest();
		Database.executeBatch(new ItemSAPBatchInsertProduct(listObj), 1);
		Test.stopTest();

		List<Product2> result = [Select Id From Product2 Where ProductCode = 'S006638'];
    
        Assert.areEqual(1, result.size(), 'Deveria ser 1');
    }

	@isTest
    static void testMethod2(){
        
        TestFactoryData.createPricebook2('Vendas');
        
        List<Product2> listObj = new List<Product2>();

        Product2 prod = new Product2();
        
        prod.ProductCode = 'C006638';
        prod.Name = 'Test Product';
        prod.Description = 'Test Product';
        prod.QuantityUnitOfMeasure = 'UN';
        prod.IsActive = true;
        prod.UltimaAtualizacaoDoProdutoNoSap__c = Date.today();
        
        listObj.add(prod);
        
        Test.startTest();
		Database.executeBatch(new ItemSAPBatchInsertProduct(listObj), 1);
		Test.stopTest();

		List<Product2> result = [Select Id From Product2 Where ProductCode = 'C006638'];
    
        Assert.areEqual(1, result.size(), 'Deveria ser 1');
    }

    @isTest
    static void testMethod3(){
        
        TestFactoryData.createPricebook2('Equipamentos e Insumos');
        
        List<Product2> listObj = new List<Product2>();

        Product2 prod = new Product2();
        
        prod.ProductCode = 'P006638';
        prod.Name = 'Test Product';
        prod.Description = 'Test Product';
        prod.QuantityUnitOfMeasure = 'UN';
        prod.IsActive = true;
        prod.UltimaAtualizacaoDoProdutoNoSap__c = Date.today();
        
        listObj.add(prod);
        
        Test.startTest();
		Database.executeBatch(new ItemSAPBatchInsertProduct(listObj), 1);
		Test.stopTest();

		List<Product2> result = [Select Id From Product2 Where ProductCode = 'P006638'];
    
        Assert.areEqual(1, result.size(), 'Deveria ser 1');
    }
}