public virtual with sharing class ServiceBase extends ApiTokenHelper  {

    public final HttpService api;

    public API_Authorization__mdt auth;
    
    public ServiceBase() {}

    public ServiceBase(System.Type serviceName) {
		super(String.valueOf(serviceName));        

        this.auth = API_Authorization__mdt.getInstance('ApiAutenticacaoSAP');

        OAuth2DTO oApiOAuthTO = getApiOAuth();
        this.api = new HttpService( oApiOAuthTO, serviceName );
    } 

    public override HTTPResponse getHTTPResponseToken() {
		HttpRequest oRequest = new HttpRequest();
		String payload = '{"CompanyDB": "'+auth.CompanyDB__c+'","UserName": "'+auth.Username__c+'","Password": "'+auth.Password__c+'"}';
        oRequest.setEndpoint('callout:ApiAutenticacaoSAP');
        oRequest.setMethod(this.tokenHttpVerb);
        oRequest.setHeader('Content-Type', this.tokenContentType);
		oRequest.setBody(payload);
        Http http = new Http();
        HTTPResponse oResponse = http.send(oRequest);
        return oResponse;
    }

}