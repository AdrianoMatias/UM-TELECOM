@isTest
private class StockItemSAPBatchProcessTest {
    
    @TestSetup
	static void setup() {
        List<Product2> productList = new List<Product2>();
        for(Integer i = 0; i < 5; i++) {
            productList.add(new Product2(
                Name = 'Produto ' + i,
                ProductCode = 'P000' + String.valueOf(i),
                EstoqueDisponivelNoSAP__c = 100.00,
                UltimoPrecoDeCompra__c = 200.00,
                UltimaAtualizacaoDoSaldoNoSap__c = Datetime.now()
            ));
        }
        insert productList;
    }
    
    static testMethod void testBatchProcess() {

        String jsonResponse = generateMockResponse();
        
        // Configurar o mock de chamada HTTP com a resposta gerada
        HttpMock mock = new HttpMock(200, 'OK', jsonResponse, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        Database.executeBatch(new StockItemSAPBatchProcess(), 200);
        Test.stopTest();

        List<Product2> produtos = [SELECT Id FROM Product2 Where EstoqueDisponivelNoSAP__c > 0.00];
        System.assertEquals(produtos.size(), 0);
    }

    static String generateMockResponse() {
        StockItemSAPBatchProcess.StockResponse mockResponse = new StockItemSAPBatchProcess.StockResponse();
        mockResponse.oDataContext = 'https://example.com';
        mockResponse.value = new List<StockItemSAPBatchProcess.StockItem>();
        
        for(Integer i = 0; i < 5; i++) {
            mockResponse.value.add(new StockItemSAPBatchProcess.StockItem(
                'P000' + String.valueOf(i),
                0.00,
                1.00
            ));
        }        
        return JSON.serialize(mockResponse);
    }
        
}