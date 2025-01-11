public abstract class ApiTokenHelper {

    private String apiService;
    public OAuth2DTO oApiOAuthTO = new OAuth2DTO();     
    public static final String ERROR_WHILE_GET_TOKEN = 'Erro ao obter token de API. Detalhes: ';

    public String tokenHttpVerb = 'POST'; 
    public String tokenContentType = 'application/json';
    public Integer timeout = 120000; 

    public class ApiTokenHelperException extends Exception {}
    
	public ApiTokenHelper() {}

    public ApiTokenHelper(String apiService) {
        this.apiService = apiService;
    }

	public abstract HTTPResponse getHTTPResponseToken();

	public virtual OAuth2DTO.AccessTokenResponse getApiOAuthResponse(){
		HttpResponse oResponseToken = this.getHTTPResponseToken();
		OAuth2DTO.AccessTokenResponse oAccessTokenResponse = (OAuth2DTO.AccessTokenResponse) System.JSON.deserialize(oResponseToken.getBody(), OAuth2DTO.AccessTokenResponse.class);
        return oAccessTokenResponse;
	}    

    public virtual OAuth2DTO getApiOAuth() {
        try {
            this.oApiOAuthTO.accessTokenResponse = this.getApiOAuthResponse();  
        }
        catch (Exception ex) {
            System.debug('ApiTokenHelper: ApiTokenHelper:getApiOAuth => ' + ex.getMessage());
            throw new ApiTokenHelperException(ERROR_WHILE_GET_TOKEN + ' | StackTraceString : '+ ex.getStackTraceString() + ' | Mensagem : ' + ex.getMessage());
        }            
        
        return this.oApiOAuthTO;   
    }

    public virtual void setResponseData(GenericApiDTO oGenericApiDTO, HttpResponse oHttpResponse) {
        oGenericApiDTO.status = oHttpResponse.getStatus();
        oGenericApiDTO.statusCode = oHttpResponse.getStatusCode();
    }

    public virtual void setResponseData(Map<String,Object> mapOfData, HttpResponse oHttpResponse) {
        mapOfData.put('status', oHttpResponse.getStatus());
        mapOfData.put('statusCode', oHttpResponse.getStatusCode());
    }      
}