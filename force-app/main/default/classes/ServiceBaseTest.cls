@isTest
public with sharing class ServiceBaseTest 
{
    public static final String SESSION_ID = 'ab98e90c-ebe2-11xx-9000-fa163e85acb4';
    public static final String VERSION = '1000999';
    public static final Integer SESSION_TIMEOUT = 30;

    @isTest    
    static void testServiceBase()
    {
        OAuth2DTO.AccessTokenResponse oAccessTokenResponse = new OAuth2DTO.AccessTokenResponse();
        oAccessTokenResponse.SessionId = SESSION_ID;
        oAccessTokenResponse.Version = VERSION;
        oAccessTokenResponse.SessionTimeout = SESSION_TIMEOUT;
        HttpMock mock = new HttpMock(200,'OK',JSON.Serialize(oAccessTokenResponse), new Map<String,String>());
        
        Test.startTest();

            Test.setMock(HttpCalloutMock.class, mock);

            ServiceBase service = new ServiceBase(ServiceBase.class);
            HttpResponse oHTTPResponse = service.getHTTPResponseToken();

        Test.stopTest();

        OAuth2DTO.AccessTokenResponse response = (OAuth2DTO.AccessTokenResponse) System.JSON.deserialize(oHTTPResponse.getBody(), OAuth2DTO.AccessTokenResponse.class);

        System.assertEquals(SESSION_ID, response.SessionId);
        System.assertEquals(VERSION, response.Version);
        System.assertEquals(SESSION_TIMEOUT, response.SessionTimeout);
    }
}