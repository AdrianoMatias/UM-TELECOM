@isTest
private class HttpUtils_Test {
    
    @isTest 
    static void testSendRequestAcesso() {
        
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/resource';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json'});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestAcesso(
            'POST', 
            mockEndPoint, 
            mockBodyJson, 
            new Map<String, String>{'Authorization' => 'Bearer token'}, 
            12000, 
            null
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestGetUltimoContrato() {
        
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/contrato?';
        String mockToken = 'mockTokenValue';
        String mockQueryParameter = 'param=value';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json', 'Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestGetUltimoContrato(
            'GET', 
            mockEndPoint, 
            12000, 
            mockToken, 
            mockQueryParameter
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPOSTCartaoEquipamento() {
        
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/cartaoEquipamento';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPOSTCartaoEquipamento(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPOSTContrato() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/contrato';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPOSTContrato(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPatchItemContrato() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/itemContrato';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPatchItemContrato(
            'PATCH', 
            mockEndPoint,
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestGetUltimoCliente() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/cliente?';
        String mockToken = 'mockTokenValue';
        String mockQueryParameter = 'param=value';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json', 'Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestGetUltimoCliente(
            'GET', 
            mockEndPoint, 
            12000, 
            mockToken, 
            mockQueryParameter
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest
    static void testSendRequestPOSTCliente() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/cliente';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPOSTCliente(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPOSTSubnivel() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/subnivel';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json', 'Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPOSTSubnivel(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPOSTEstoque() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/estoque';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPOSTEstoque(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestUpdateItemIniciado() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/updateItem';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestUpdateItemIniciado(
            'PUT', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken,
            '123'
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestGetClienteFornecedor() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/clienteFornecedor?';
        String mockToken = 'mockTokenValue';
        String mockQueryParameter = 'param=value';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestGetClienteFornecedor(
            'GET', 
            mockEndPoint, 
            12000, 
            mockToken, 
            mockQueryParameter
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestGetArvoreProd() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com.br/b1s/v1/ProductTrees';
        String mockToken = 'mockTokenValue';
        String mockQueryParameter = 'param=value';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = HttpUtils.sendRequestGetArvoreProd(
            'GET', 
            mockEndPoint, 
            12000, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestUtilizacao() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com.br/b1s/v1/Utilizacao';
        String mockToken = 'mockTokenValue';
        String mockQueryParameter = 'param=value';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = HttpUtils.sendRequestUtilizacao(
            'GET', 
            mockEndPoint, 
            12000, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestContractPlus() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/ContractPlus';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(201, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = HttpUtils.sendRequestContractPlus(
            'POST', 
            mockEndPoint,
            mockBodyJson,
            12000
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPostTokenUltimoContractPlus() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/tokenLastContractPlus';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(201, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = HttpUtils.sendRequestPostTokenUltimoContractPlus(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestGetUltimoContractPlus() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com.br/b1s/v1/LastContractPlus';
        String mockToken = 'mockTokenValue';
        String mockQueryParameter = 'param=value';
        
        HttpMock mock = new HttpMock(200, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = HttpUtils.sendRequestGetUltimoContractPlus(
            'GET', 
            mockEndPoint, 
            12000, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSendRequestPOSTTaxaInstalacao() {
        Test.startTest();
        
        String mockEndPoint = 'https://example.com/api/taxa';
        String mockToken = 'mockTokenValue';
        String mockBodyJson = '{"key": "value"}';
        
        HttpMock mock = new HttpMock(201, 'OK', 'ExpectedResponseBody', new Map<String, String>{'Content-Type' => 'application/json','Set-Cookie' => 'B1SESSION=' + mockToken});
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpUtils httpUtils = HttpUtils.getInstance();
        
        HttpResponse response = httpUtils.sendRequestPostTaxaInstalacao(
            'POST', 
            mockEndPoint, 
            12000, 
            mockBodyJson, 
            mockToken
        );
        
        System.assertNotEquals(null, response);
        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('ExpectedResponseBody', response.getBody());
        
        Test.stopTest();
    }
}