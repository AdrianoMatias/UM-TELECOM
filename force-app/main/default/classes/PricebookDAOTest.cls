@isTest
public class PricebookDAOTest {
    @testSetup static void setup() {
        TestFactoryData.createListPricebook2(new Set<String>{'Vendas','Equipamentos e Insumos'});
    }
    
	@isTest
	private static void testListOK() {
		List<Pricebook2> listPricebook2 = new List<Pricebook2>();
		Test.startTest();
		listPricebook2 = PricebookDAO.buscarPricebookName(new Set<String>{'Vendas','Equipamentos e Insumos'});
		Test.stopTest();
        
        Assert.areEqual(2, listPricebook2.size(), 'Deveria ser 2');
	}
    
	@isTest
	private static void testObjectOK() {
		Pricebook2 pricebook = new Pricebook2();
		Test.startTest();
		pricebook = PricebookDAO.buscarPricebookName('Vendas');
		Test.stopTest();
        
        Assert.isNotNull(pricebook, 'Não deveria ser nulo');
	}
    
	@isTest
	private static void testListEmpty() {
		List<Pricebook2> listPricebook2 = new List<Pricebook2>();
		Test.startTest();
		listPricebook2 = PricebookDAO.buscarPricebookName(new Set<String>{'teste'});
		Test.stopTest();
        
        Assert.isTrue(listPricebook2.isEmpty(), 'Deveria ser vazia');
	}
    
	@isTest
	private static void testObjectNull() {
		Pricebook2 pricebook = new Pricebook2();

        Test.startTest();
		pricebook = PricebookDAO.buscarPricebookName('teste');
		Test.stopTest();
        
        Assert.isNull(pricebook, 'Deveria ser nulo');
	}
    
	@isTest
	private static void testListInactive() {
		List<Pricebook2> listPricebook2 = new List<Pricebook2>();
        Pricebook2 pricebook = PricebookDAO.buscarPricebookName('Vendas');
        pricebook.isActive = false;
        update pricebook;

		Test.startTest();
		listPricebook2 = listPricebook2 = PricebookDAO.buscarPricebookName(new Set<String>{'Vendas','Equipamentos e Insumos'});
		Test.stopTest();
        
        Assert.areEqual(1, listPricebook2.size(), 'Deveria ser 1');
	}
}