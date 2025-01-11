@isTest
public class AccountDAOTest {
    @testSetup static void setup() {
        TestFactoryData.createAccount('COD123');
    }
    
	@isTest
	private static void testListOK() {
		List<Account> listAccount = new List<Account>();
		Test.startTest();
		listAccount = AccountDAO.buscarCodigoCliente(new Set<String>{'COD123'});
		Test.stopTest();
        
        Assert.areEqual(1, listAccount.size(), 'Deveria ser 1');
	}
    
	@isTest
	private static void testObjectOK() {
		Test.startTest();
		Account acc = AccountDAO.buscarCodigoCliente('COD123');
		Test.stopTest();
        
        Assert.areEqual('COD123', acc.Codigo_SAP_cliente__c, 'Deveria ser COD123');
	}
    
	@isTest
	private static void testListEmpty() {
		List<Account> listAccount = new List<Account>();
		Test.startTest();
		listAccount = AccountDAO.buscarCodigoCliente(new Set<String>{'teste'});
		Test.stopTest();

        Assert.isTrue(listAccount.isEmpty(), 'Deveria ser vazia');
	}
    
	@isTest
	private static void testObjectNull() {
		Test.startTest();
		Account acc = AccountDAO.buscarCodigoCliente('teste');
		Test.stopTest();
      
        Assert.isNull(acc, 'Deveria ser nulo');
	}
}