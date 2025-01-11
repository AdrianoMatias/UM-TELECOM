@isTest
public class ItemSAPHelperTest {
	@isTest
    private static void createProductTest() {
		String obj1json = '{"ItemCode":"P000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';
		String obj2json = '{"ItemCode":"C000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":"4","U_UtilizacaoSalesforce":"PV"}';
		String obj3json = '{"ItemCode":"S000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tNo","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';

		ItemSAPDTO.Response obj1dto = (ItemSAPDTO.Response)JSON.deserialize(obj1json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj2dto = (ItemSAPDTO.Response)JSON.deserialize(obj2json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj3dto = (ItemSAPDTO.Response)JSON.deserialize(obj3json, ItemSAPDTO.Response.class);
        
        Test.startTest();
        Product2 obj1 = ItemSAPHelper.createObject(obj1dto);
        Product2 obj2 = ItemSAPHelper.createObject(obj2dto);
        Product2 obj3 = ItemSAPHelper.createObject(obj3dto);
        Test.stopTest();
        
        System.assertEquals('P000001', obj1.ProductCode, 'Deveria ser P000001');
        System.assertEquals(true, obj1.isActive, 'Deveria ser true');
        System.assertEquals(true, String.isBlank(obj1.Family), 'Deveria ser nulo');
        System.assertEquals('Mobilidade', obj2.Family, 'Deveria ser Mobilidade');
        System.assertEquals(false, obj3.isActive, 'Deveria ser false');
        System.assertEquals('Insumo', obj3.TipoDeUtilizacao__c, 'Deveria ser Insumo');
    }

	@isTest
    private static void createProductException() {
		String obj1json = '{"ItemCode":"","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';
		String obj2json = '{"ItemCode":"C000001","ItemName":"","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":"4","U_UtilizacaoSalesforce":"PV"}';

		Exception ex1;
		Exception ex2;
        String errorMessage1 = 'ItemCode não pode ser vazio';
        String errorMessage2 = 'ItemName não pode ser vazio';
        
        ItemSAPDTO.Response obj1dto = (ItemSAPDTO.Response)JSON.deserialize(obj1json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj2dto = (ItemSAPDTO.Response)JSON.deserialize(obj2json, ItemSAPDTO.Response.class);
        
        Test.startTest();
        try{
            ItemSAPHelper.validate(obj1dto);
        }catch(Exception e){
            ex1 = e;
        }

        try{
            ItemSAPHelper.validate(obj2dto);
        }catch(Exception e){
            ex2 = e;
        }        
        
        Test.stopTest();
    }
    
	@isTest
    private static void createPBEntryTest() {
        
        List<Product2> prodList = new List<Product2>();
        List<PricebookEntry> listPBEntry = new List<PricebookEntry>();
        String pbookVendasId = TestFactoryData.createPricebook2('Vendas').Id;
        String pbookEquipamentosId = TestFactoryData.createPricebook2('Equipamentos e Insumos').Id;        
        Product2 prodP = TestFactoryData.createProduct2('P006600', true);
        Product2 prodC = TestFactoryData.createProduct2('C001100', true);
        Product2 prodS = TestFactoryData.createProduct2('S001100', true);
        
        prodList.add(prodP);
        prodList.add(prodC);
        prodList.add(prodS);
        
		Test.startTest();
        listPBEntry.addAll(ItemSAPHelper.createPBEntry(prodList));
        Test.stopTest();
        
        Integer countStd = 0;
        Integer countVendas = 0;
        Integer countEquipamentos = 0;
        
        for(PricebookEntry pbEntry : listPBEntry){
            if(pbEntry.isActive && (pbEntry.Product2Id == prodP.Id || pbEntry.Product2Id == prodC.Id || pbEntry.Product2Id == prodS.Id)){
                if(pbEntry.Pricebook2Id == Test.getStandardPricebookId()){
                    countStd++;
                }
                if(pbEntry.Pricebook2Id == pbookVendasId){
                    countVendas++;
                }
                if(pbEntry.Pricebook2Id == pbookEquipamentosId){
                    countEquipamentos++;
                }
            }
        }

        Assert.areEqual(5, listPBEntry.size(), 'Total deveria ser 5');
        Assert.areEqual(3, countStd, 'Standard deveria ser 3');
        Assert.areEqual(1, countVendas, 'Vendas deveria ser 1');
		Assert.areEqual(1, countEquipamentos, 'Equipamentos deveria ser 1');
    }

	@isTest
    private static void createProdutcsToUpdateTest() {
		String product1json = '{"ItemCode":"P000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';
		String product2json = '{"ItemCode":"C000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":"4","U_UtilizacaoSalesforce":"PV"}';
		String product3json = '{"ItemCode":"S000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tNo","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';

        List<Product2> prodList = new List<Product2>();
        List<Product2> prodListResult = new List<Product2>();
        Map<String, Product2> prodMap = new Map<String, Product2>();

		ItemSAPDTO.Response obj1 = (ItemSAPDTO.Response)JSON.deserialize(product1json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj2 = (ItemSAPDTO.Response)JSON.deserialize(product2json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj3 = (ItemSAPDTO.Response)JSON.deserialize(product3json, ItemSAPDTO.Response.class);

        prodList.add(ItemSAPHelper.createObject(obj1));
        prodList.add(ItemSAPHelper.createObject(obj2));
        prodList.add(ItemSAPHelper.createObject(obj3));
        
		Product2 prod1 = TestFactoryData.createProduct2(obj1.ItemCode, true);
        Product2 prod2 = TestFactoryData.createProduct2(obj2.ItemCode, true);
        Product2 prod2_1 = TestFactoryData.createProduct2(obj2.ItemCode, true);
        
		Test.startTest();
        for(Product2 product : ItemSAPHelper.createProdutcsToUpdate(prodList)){
            prodMap.put(product.ProductCode, product);
            prodListResult.add(product);
        }
        
        Test.stopTest();
        
        Integer countProd1 = 0;
        Integer countProd2 = 0;
        Integer countProd3 = 0;
        
        for(Product2 prod : prodListResult){
            if(prodMap.containsKey(prod.ProductCode) && prod.ProductCode == obj1.ItemCode){
                countProd1++;
            }
            if(prodMap.containsKey(prod.ProductCode)  && prod.ProductCode == obj2.ItemCode){
                countProd2++;
            }
            if(prodMap.containsKey(prod.ProductCode) && prod.ProductCode == obj3.ItemCode){
                countProd3++;
            }
        }

        Assert.areEqual(3, prodListResult.size(), 'Total deveria ser 2');
        Assert.areEqual(1, countProd1, 'countProd1 deveria ser 1');
        Assert.areEqual(2, countProd2, 'countProd2 deveria ser 2');
		Assert.areEqual(0, countProd3, 'countProd3 deveria ser 0');
    }
    
	@isTest
    private static void createProdutcsToInsertTest() {
		String product1json = '{"ItemCode":"P000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';
		String product2json = '{"ItemCode":"C000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tYES","UpdateDate":"2024-03-18","U_Vertical":"4","U_UtilizacaoSalesforce":"PV"}';
		String product3json = '{"ItemCode":"S000001","ItemName":"Test Product","InventoryItem":"tNO","Valid":"tNo","UpdateDate":"2024-03-18","U_Vertical":null,"U_UtilizacaoSalesforce":"IN"}';

        List<Product2> prodList = new List<Product2>();
        List<Product2> prodListResult = new List<Product2>();
        Map<String, Product2> prodMap = new Map<String, Product2>();

		ItemSAPDTO.Response obj1 = (ItemSAPDTO.Response)JSON.deserialize(product1json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj2 = (ItemSAPDTO.Response)JSON.deserialize(product2json, ItemSAPDTO.Response.class);
        ItemSAPDTO.Response obj3 = (ItemSAPDTO.Response)JSON.deserialize(product3json, ItemSAPDTO.Response.class);
        
        Product2 prod1 = ItemSAPHelper.createObject(obj1);
        Product2 prod2 = ItemSAPHelper.createObject(obj2);
        Product2 prod3 = ItemSAPHelper.createObject(obj3);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        
		prodMap.put(prod1.ProductCode, prod1);
        prodMap.put(prod2.ProductCode, prod2);
        
		Test.startTest();
        prodListResult = ItemSAPHelper.createProdutcsToInsert(prodList, prodMap.values());
        Test.stopTest();
        
        Integer countProd1 = 0;
        Integer countProd2 = 0;
        Integer countProd3 = 0;
        
        for(Product2 prod : prodMap.values()){
            if(prodMap.containsKey(prod.ProductCode) && prod.ProductCode == obj1.ItemCode){
                countProd1++;
            }
            if(prodMap.containsKey(prod.ProductCode)  && prod.ProductCode == obj2.ItemCode){
                countProd2++;
            }
            if(prodMap.containsKey(prod.ProductCode) && prod.ProductCode == obj3.ItemCode){
                countProd3++;
            }
        }

        Assert.areEqual(1, prodListResult.size(), 'Total deveria ser 1');
        Assert.areEqual(prod3.ProductCode, prodListResult[0].ProductCode, 'ProductCode deveria ser ' + prod3.ProductCode);
    }

}