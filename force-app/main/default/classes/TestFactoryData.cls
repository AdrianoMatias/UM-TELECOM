@isTest
public class TestFactoryData {

    public static Fatura__c createFatura(String accountId, String contratoSAP, Decimal numeroFaturaSAP) {
        Fatura__c fat = new Fatura__c(Conta__c = accountId, 
                                  	  Contrato__c = contratoSAP,
                                      NumeroFaturaSAP__c = numeroFaturaSAP,
                                  	  StatusDaFatura__c = 'Aberta');
        insert fat;
		return fat;        
    }

    public static Account createAccount(String codigoCliente) {
        Account acc = new Account(Name = 'Test Account', 
                                  Codigo_SAP_cliente__c = codigoCliente);
        insert acc;
		return acc;        
    }

    public static Contract createContract(String AccountId, String contratoSAP) {
        Contract cont = new Contract(AccountId = AccountId, 
                                     Status = 'Esboço',
                                     Codigo_do_contrato__c = contratoSAP);
        insert cont;
        return cont;
    }
    
    public static Product2 createProduct2(String productCode, Boolean isActive) {
		return createListProduct2(new Set<String>{productCode}, isActive)[0];
    }

    public static List<Product2> createListProduct2(Set<String> setProductCode, Boolean isActive) {
        List<Product2> listObj = new List<Product2>();
        for(String productCode : setProductCode){
            Product2 prod = new Product2();
            
            prod.ProductCode = productCode;
            prod.Name = 'Test Product';
            prod.Description = 'Test Product';
            prod.QuantityUnitOfMeasure = 'UN';
            prod.IsActive = isActive;

            prod.UltimaAtualizacaoDoProdutoNoSap__c = Date.today();
            prod.Family = productCode.startsWith('C') ? 'Mobilidade' : null;
            prod.TipoDeUtilizacao__c = productCode.startsWith('C') ? 'Produto de Venda' : 'Equipamento';
        
            listObj.add(prod);
        }
        insert listObj;
        return listObj;
    }

    public static Pricebook2 createPricebook2(String name) {
		return createListPricebook2(new Set<String>{name})[0];
    }

    public static List<Pricebook2> createListPricebook2(Set<String> setName) {
        List<Pricebook2> listObj = new List<Pricebook2>();
        for(String name : setName){
            listObj.add(new Pricebook2(Name=name, isActive=true, UF__c = 'SP', Regiao__c='Sudeste'));
        }
        insert listObj;
        return listObj;
    }

}