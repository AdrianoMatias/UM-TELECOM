public class OAuth2DTO {

	public AccessTokenResponse accessTokenResponse = new AccessTokenResponse();

	public class AccessTokenResponse {

		public String SessionId {get;set;}
		
		public String Version {get;set;}

        public Integer SessionTimeout {get;set;}
	}
}