@isTest
public class ContractDAOTest {
    @testSetup static void setup() {
        TestFactoryData.createContract(TestFactoryData.createAccount('COD123').Id, 'SAP123');
    }
    
	@isTest
	private static void testListOK() {
		List<Contract> listContract = new List<Contract>();
		Test.startTest();
		listContract = ContractDAO.buscarCodigoContrato(new Set<String>{'SAP123'});
		Test.stopTest();
        
        Assert.areEqual(1, listContract.size(), 'Deveria ser 1');
	}
    
	@isTest
	private static void testObjectOK() {
		Test.startTest();
		Contract ct = ContractDAO.buscarCodigoContrato('SAP123');
		Test.stopTest();
        
        Assert.areEqual('SAP123', ct.Codigo_do_contrato__c, 'Deveria ser SAP123');
	}
    
	@isTest
	private static void testListEmpty() {
		List<Contract> listContract = new List<Contract>();
		Test.startTest();
		listContract = ContractDAO.buscarCodigoContrato(new Set<String>{'teste'});
		Test.stopTest();

        Assert.isTrue(listContract.isEmpty(), 'Deveria ser vazia');
	}
    
	@isTest
	private static void testObjectNull() {
		Test.startTest();
		Contract ct = ContractDAO.buscarCodigoContrato('teste');
		Test.stopTest();
      
        Assert.isNull(ct, 'Deveria ser nulo');
	}
}