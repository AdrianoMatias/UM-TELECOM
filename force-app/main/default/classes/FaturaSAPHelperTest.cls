@isTest
public class FaturaSAPHelperTest {

    @isTest
    private static void testValidate() {
        String errorMessage1 = 'CodigoDoCliente não pode ser vazio';
        String errorMessage2 = 'ContratoSAP não pode ser vazio';
        String errorMessage3 = 'CodigoDoCliente não encontrado';
        String errorMessage4 = 'ContratoSAP não encontrado';

		Exception ex1;
		Exception ex2;
        Exception ex3;
        Exception ex4;
        
        Account acc = new Account(Name = 'Test Account', 
                                  Codigo_SAP_cliente__c = 'CLI123');
        Contract ct = new Contract(Status = 'Esboço',
                                   Codigo_do_contrato__c = 'CT789');
       
        Map<String, Account> mapAccount = new Map<String, Account>();
        Map<String, Contract> mapContract = new Map<String, Contract>();
        mapAccount.put('CLI123', acc);
        mapContract.put('CT789', ct);
        
        Test.startTest();
        
        try{
            FaturaSAPDTO.Response obj = new FaturaSAPDTO.Response();
			obj.CodigoDoCliente = '';
        	obj.ContratoSAP = 'CT789';
            FaturaSAPHelper.validate(obj, mapAccount, mapContract);
        }catch(Exception e){
            ex1 = e;
        }

        try{
            FaturaSAPDTO.Response obj = new FaturaSAPDTO.Response();
			obj.CodigoDoCliente = 'CLI123';
        	obj.ContratoSAP = '';
            FaturaSAPHelper.validate(obj, mapAccount, mapContract);
        }catch(Exception e){
            ex2 = e;
        }

        try{
            FaturaSAPDTO.Response obj = new FaturaSAPDTO.Response();
			obj.CodigoDoCliente = 'xxx';
        	obj.ContratoSAP = 'CT789';
            FaturaSAPHelper.validate(obj, mapAccount, mapContract);
        }catch(Exception e){
            ex3 = e;
        }

        try{
            FaturaSAPDTO.Response obj = new FaturaSAPDTO.Response();
			obj.CodigoDoCliente = 'CLI123';
        	obj.ContratoSAP = 'xxx';
            FaturaSAPHelper.validate(obj, mapAccount, mapContract);
        }catch(Exception e){
            ex4 = e;
        }
        
        Test.stopTest();
        
		System.assertEquals(errorMessage1, ex1.getMessage(), 'Ex1 deve ser: ' + errorMessage1);
        System.assertEquals(errorMessage2, ex2.getMessage(), 'Ex2 deve ser: ' + errorMessage2);
        Assert.isTrue(ex3.getMessage().contains(errorMessage3), 'Ex3 deve conter: ' + errorMessage3);
        Assert.isTrue(ex4.getMessage().contains(errorMessage4), 'Ex4 deve conter: ' + errorMessage4);        
    }
    
    @isTest
    private static void testSucess() {
		String jsonResponse1 = '{"CodigoDoCliente":"C0008207","ContratoSAP":"8195","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-01-21","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"2024-01-21","PeriodoReferencialFinal":"2024-02-20","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}';
		String jsonResponse2 = '{"CodigoDoCliente":"C0008207","ContratoSAP":"8195","DataDeRecebimento":null,"NumeroDaNota":114797,"DataDeLancamentoNF":"2024-01-21","DataDeVencimentoNF":"2024-03-12","PeriodoReferencialInicial":"","PeriodoReferencialFinal":"","StatusDaNF":"Atrasada","MeioDePagamento":"BOLETO","TipoDeNota":"Recorrente","ValorDaNF":1500,"ValorRecebidoNF":0,"SaldoEmAbertoNF":1500,"id__":1}';

        Account acc = TestFactoryData.createAccount('C0008207');
        Contract ct = TestFactoryData.createContract(acc.Id, '8195');
        
        String periodo = '21/01/2024 a 20/02/2024';
        
        FaturaSAPDTO.Response obj1 = (FaturaSAPDTO.Response) JSON.deserialize(jsonResponse1, FaturaSAPDTO.Response.class);
        FaturaSAPDTO.Response obj2 = (FaturaSAPDTO.Response) JSON.deserialize(jsonResponse2, FaturaSAPDTO.Response.class);

        Map<String, Account> mapAccount = new Map<String, Account>();
        Map<String, Contract> mapContract = new Map<String, Contract>();
        mapAccount.put('C0008207', acc);
        mapContract.put('8195', ct);
        
        Test.startTest();
        Fatura__c fat1 = FaturaSAPHelper.createObject(obj1, mapAccount, mapContract);
        Fatura__c fat2 = FaturaSAPHelper.createObject(obj2, mapAccount, mapContract);
        Test.stopTest();

		Assert.isNotNull(fat1, 'Fat1 não deve ser nulo');
        System.assertEquals(acc.Id, fat1.Conta__c, 'Conta__c deve ser: ' + acc.Id);
        System.assertEquals(ct.Id, fat1.Contrato__c, 'Contrato__c deve ser: ' + ct.Id);
		System.assertEquals(periodo, fat1.PeriodoDeUtilizacao__c, 'Contrato__c deve ser: ' + periodo);
		Assert.isTrue(String.isEmpty(fat2.PeriodoDeUtilizacao__c), 'PeriodoDeUtilizacao__c deve ser vazio');

    }
}