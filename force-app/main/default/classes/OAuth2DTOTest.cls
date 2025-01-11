@isTest
public class OAuth2DTOTest {
	@isTest
    static void testMethod1(){
        OAuth2DTO dto = new OAuth2DTO();
        dto.accessTokenResponse.SessionId = 'SessionId';
        dto.accessTokenResponse.SessionTimeout = 120000;
        dto.accessTokenResponse.Version = '1';
        
        System.assertEquals(dto.accessTokenResponse.SessionId, 'SessionId');
        System.assertEquals(dto.accessTokenResponse.SessionTimeout, 120000);
        System.assertEquals(dto.accessTokenResponse.Version, '1');
    }
}