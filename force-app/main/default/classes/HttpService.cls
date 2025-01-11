public with sharing class HttpService implements IHttpService{

    public static final String NAMED_CREDENTIALS_NOT_FOUND = 'A NamedCredential não foi informada na chamada da integração.';

    private System.Type serviceName;  

    private OAuth2DTO oApiOAuthTO; 

    public Integer maxTimeOut = 120000;

    private Map<Boolean, String> requestStatusMap = new Map<Boolean, String> { true => 'Success', false => 'Fail' };
        
	public String endpoint;

    public String method;

    public class HttpServicerException extends Exception { }     

    public HttpService(OAuth2DTO oApiOAuthTO, System.Type serviceName)
    {
        this.oApiOAuthTO = oApiOAuthTO;
        this.serviceName = serviceName;
        this.setCustomMaxTimeOut();
    }

    private void setCustomMaxTimeOut()
    {
        //Decimal timeout = ServiceSetting__mdt.getInstance(String.valueOf(this.serviceName))?.TimeOut__c;
        
        Decimal timeout = null;

        if (timeout!=null)
        {
            this.maxTimeOut = Integer.valueOf( timeout );
        }
    }

    public HttpResponse executarGet(String namedCredential, String endpointUrl)
    {
        return doRequest(namedCredential, endpointUrl, 'GET', null, null);
    }    
    
    public HttpResponse executarGet(String namedCredential, String endpointUrl, Map<String, String> additionalHeader)
    {
        return doRequest(namedCredential, endpointUrl, 'GET', null, additionalHeader);
    }    
    
    public HttpResponse executarPost(String namedCredential, String endpointUrl, String payload)
    {
        return doRequest(namedCredential, endpointUrl, 'POST', payload, null);
    }    
    
    public HttpResponse executarPost(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader)
    {
        return doRequest(namedCredential, endpointUrl, 'POST', payload, additionalHeader);
    }    
    
    public HttpResponse executarPut(String namedCredential, String endpointUrl, String payload)
    {
        return doRequest(namedCredential, endpointUrl, 'PUT', payload, null);
    }  
    
    public HttpResponse executarPut(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader)
    {
        return doRequest(namedCredential, endpointUrl, 'PUT', payload, additionalHeader);
    }    
    
    public HttpResponse executarPatch(String namedCredential, String endpointUrl, String payload)
    {
        return doRequest(namedCredential, endpointUrl, 'PATCH', payload, null);
    }    
    
    public HttpResponse executarPatch(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader)
    {
        return doRequest(namedCredential, endpointUrl, 'PATCH', payload, additionalHeader);
    }    
    
    public HttpResponse executarDelete(String namedCredential, String endpointUrl, String payload)
    {
        return doRequest(namedCredential, endpointUrl, 'DELETE', payload, null);
    }    
    
    public HttpResponse executarDelete(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader)
    {
        return doRequest(namedCredential, endpointUrl, 'DELETE', payload, additionalHeader);
    }

    private HttpResponse doRequest(String namedCredential, String endpointUrl, String method, String payload, Map<String, String> additionalHeader)
    {
        HTTPResponse oResponse;
        Boolean status = true;
        String responseBody;

        try {
            
            HttpRequest oRequest = new HttpRequest();

            if (namedCredential==null)
            {
                throw new HttpServicerException(NAMED_CREDENTIALS_NOT_FOUND);
            }

            //String endpoint = 'callout:' + namedCredential + endpointUrl;
            this.endpoint = 'callout:' + namedCredential + endpointUrl;
            this.method = method;
    
            System.Debug('*** NamedCredential: '+ namedCredential);
            System.Debug('*** Endpoint: ' + this.endpoint);
			System.Debug('*** Method: ' + this.method);
    
            oRequest.setEndpoint(this.endpoint);
            oRequest.setMethod(this.method);
         
            if (payload!=null)
            {
                oRequest.setBody(payload);
            }
         
            oRequest.setTimeout(this.maxTimeOut);
            oRequest.setHeader('Content-type', 'application/json');
    
            if (this.oApiOAuthTO.accessTokenResponse.SessionId!=null)
            {
                oRequest.setHeader('Cookie', 'B1SESSION=' + this.oApiOAuthTO.accessTokenResponse.SessionId);
            }
    
            if (additionalHeader!=null)
            {
                for (String key : additionalHeader.keySet()) {
                    oRequest.setHeader(key, additionalHeader.get(key));
                } 
            }
    
            Http http = new Http();           
            oResponse = http.send(oRequest);
            responseBody = oResponse.getBody();
        }
        catch (Exception ex) {
            status = false;
            responseBody = ex.getMessage() + '\n\n' + ex.getStackTraceString();
            oResponse = new HttpResponse();
            oResponse.setBody(responseBody);
            oResponse.setStatusCode(500);
            oResponse.setStatus('Internal Server Error');
        }
        finally {}

        return oResponse;
    }
}