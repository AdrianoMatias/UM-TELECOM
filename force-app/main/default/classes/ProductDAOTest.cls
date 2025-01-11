@isTest
public class ProductDAOTest {
    @testSetup static void setup() {
        TestFactoryData.createListProduct2(new Set<String>{'P006638','C000101','SP00061'}, true);
    }
    
	@isTest
	private static void testListOK() {
		List<Product2> listProduct2 = new List<Product2>();
		Test.startTest();
		listProduct2 = ProductDAO.buscarProductCode(new Set<String>{'P006638','C000101'});
		Test.stopTest();
        
        Assert.areEqual(2, listProduct2.size(), 'Deveria ser 2');
	}
    
	@isTest
	private static void testObjectOK() {
		Product2 product = new Product2();
		Test.startTest();
		product = ProductDAO.buscarProductCode('SP00061');
		Test.stopTest();
        
        Assert.isNotNull(product, 'Não deveria ser nulo');
	}
    
	@isTest
	private static void testListEmpty() {
		List<Product2> listProduct2 = new List<Product2>();
		Test.startTest();
		listProduct2 = ProductDAO.buscarProductCode(new Set<String>{'teste'});
		Test.stopTest();
        
        Assert.isTrue(listProduct2.isEmpty(), 'Deveria ser vazia');
	}
    
	@isTest
	private static void testObjectNull() {
		Product2 product = new Product2();

        Test.startTest();
		product = ProductDAO.buscarProductCode('teste');
		Test.stopTest();
        
        Assert.isNull(product, 'Deveria ser nulo');
	}
}