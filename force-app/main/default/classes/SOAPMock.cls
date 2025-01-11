@isTest
global with sharing class SOAPMock implements WebServiceMock {

    private Map<String,Object> response;
    
    global SOAPMock(Map<String, Object> response) {
        this.response = response;
    }

    global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        response.put('response_x', this.response.get( 'response_x' ));
    }

}