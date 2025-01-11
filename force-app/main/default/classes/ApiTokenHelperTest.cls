@isTest
public with sharing class ApiTokenHelperTest {

    public static final String COMPANYDB = 'SBO_1TELECOM_TESTE';
    public static final String USERNAME = 'TESTUSER';
    public static final String PASSWORD = 'TESTPASS';
    public static final String EXPIRES_IN = '3200';
    public static final String SESSION_ID = 'ab98e90c-ebe2-11xx-9000-fa163e85acb4';
    public static final String VERSION = '1000999';
    public static final Integer SESSION_TIMEOUT = 3200;

    class MyServiceApiCache extends ApiTokenHelper
    {
        
        public MyServiceApiCache()
        {
            super('MyService');
        }

        public override HTTPResponse getHTTPResponseToken()
        {
            Http oHttp               = new Http();
            HttpRequest requestToken = new HttpRequest();
            String urlToken          = 'https://services.umcloud.com.br:48124/b1s/v1/Login';
            requestToken.setEndpoint(urlToken);
            requestToken.setMethod('POST');
            requestToken.setBody('{"CompanyDB": "'+COMPANYDB+'","UserName": "'+USERNAME+'","Password": "'+PASSWORD+'"}'); 		
            httpResponse responseToken = oHttp.send(requestToken); 
            return responseToken;
        }        
    }

    static String generateResponseAcessTokenOk()
    {
        Map<String,Object> tokenMap = new Map<String,Object>();
        tokenMap.put('SessionId', SESSION_ID);
        tokenMap.put('SessionTimeout', SESSION_TIMEOUT);
        tokenMap.put('Version', VERSION);
        String responseAcessTokenOk = System.JSON.serialize(tokenMap);
        return responseAcessTokenOk;
    }   

    @isTest        
    static void testApiCache()
    {
        Map<String,Object> responseMap = new Map<String,Object>();
        responseMap.put('SessionId', SESSION_ID);
        responseMap.put('Version', VERSION);
        responseMap.put('SessionTimeout', SESSION_TIMEOUT);

        String responseStr = System.JSON.serialize(responseMap);

        String responseAcessTokenOk = generateResponseAcessTokenOk();
        Map<String,String> mapHeader = new Map<String,String>{ 'Content-Type'=> 'application/json'};
        Test.setMock(HttpCalloutMock.class, new GenericResponse(responseStr, 200, mapHeader));
        Test.startTest();

            MyServiceApiCache oMyServiceApiCache = new MyServiceApiCache();
            OAuth2DTO oApiOAuthDTO = oMyServiceApiCache.getApiOAuth();

        Test.stopTest();      

        System.assertEquals(SESSION_ID, oApiOAuthDTO.accessTokenResponse.SessionId, 'Precisa ser igual a: ' + SESSION_ID);
        System.assertEquals(VERSION, oApiOAuthDTO.accessTokenResponse.Version, 'Precisa ser igual a: ' + VERSION);
        System.assertEquals(SESSION_TIMEOUT, oApiOAuthDTO.accessTokenResponse.SessionTimeout, 'Precisa ser igual a: ' + SESSION_TIMEOUT);
    } 

    @isTest
    static void testError()
    {
        Map<String,String> mapHeader = new Map<String,String>{ 'Content-Type'=> 'application/json'};
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new GenericResponse('invalidBody', 500, mapHeader));

            Exception myEx;
            try {
                OAuth2DTO oApiOAuthDTO = new MyServiceApiCache().getApiOAuth();
            }
            catch (Exception ex) {
                myEx = ex;
            }

        Test.stopTest();

        System.assertEquals(
            true, 
            myEx.getMessage().contains(ApiTokenHelper.ERROR_WHILE_GET_TOKEN), 
            'A mensagem de erro precisa ter:' + ApiTokenHelper.ERROR_WHILE_GET_TOKEN
        );     
  
    }

    @isTest    
    static void testSetResponseData()
    {
        MyServiceApiCache oMyServiceApiCache = new MyServiceApiCache();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        GenericApiDTO oGenericApiDTO = new GenericApiDTO();
        oMyServiceApiCache.setResponseData(oGenericApiDTO, res);

        Map<String,Object> mapOfData = new Map<String,Object>();
        oMyServiceApiCache.setResponseData(mapOfData, res);

        System.assertEquals(200, oGenericApiDTO.statusCode, 'Precisa ser igual a: 200');
        System.assertEquals('OK', oGenericApiDTO.status, 'Precisa ser igual a: OK');

        System.assertEquals(200, mapOfData.get('statusCode'), 'Precisa ser igual a: 200');
        System.assertEquals('OK', mapOfData.get('status'), 'Precisa ser igual a: OK');
    }
    
}