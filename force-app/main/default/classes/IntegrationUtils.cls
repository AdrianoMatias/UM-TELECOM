public with sharing class IntegrationUtils {

    public static HttpResponse doRequest(String method, String url, String service, Map<String,String> cabecalhos, Map<String,String> parametros, String body, Integer timeout ) {
        HttpResponse result;
        HttpRequest request = new HttpRequest();

        if( cabecalhos != null ) {
            for( String key : cabecalhos.keySet() ) {
                request.setHeader(key, cabecalhos.get(key));
            }
        }

        if( method == 'GET' ) {
            request = doGet( request, url, service, parametros, timeout );
        } else if( method == 'PUT' ) {
            request = doPut( request, url, service, parametros, body, timeout );
        } else if( method == 'POST' ) {
            request = doPost( request, url, service, parametros, body, timeout );
        } else {
            throw new IntegrationUtilsException('Método não implementado');
        }

        Http h = new Http();
System.debug(request);      
        result = h.send( request );
System.debug(request.getBody());                
        return result;
    }



    private static HttpRequest doGet( HttpRequest request, String url, String service, Map<String,String> parametros, Integer timeout ) {

        String queryParametros = '';
        if( parametros != null ) {
            queryParametros += '?';
            for( String key : parametros.keySet() ) {
                queryParametros += key + '=' + EncodingUtil.urlEncode(parametros.get(key),'UTF-8') + '&';
            }
        }

        queryParametros = queryParametros.length() == 0 ? '' : queryParametros.removeEnd('&');
        request.setEndpoint( url + service + queryParametros);
        request.setMethod('GET');
        request.setTimeout(timeout);

        return request;

    }

    private static HttpRequest doPut( HttpRequest request, String url, String service, Map<String,String> parametros, String body, Integer timeout ) {
        String queryParametros = '';
        if( parametros != null ) {
            queryParametros += '?';
            for( String key : parametros.keySet() ) {
                queryParametros += key + '=' + parametros.get(key) + '&';
            }
        }

        queryParametros = queryParametros.length() == 0 ? '' : queryParametros.removeEnd('&');
        request.setEndpoint( url + service + queryParametros);
        request.setMethod('PUT');
        request.setTimeout(timeout);        
        if( body == null ) {
            request.setBody( '' );
        } else {
            request.setBody( body );
        }

        return request;
    }

    private static HttpRequest doPost( HttpRequest request, String url, String service, Map<String,String> parametros, String body, Integer timeout ) {
        String queryParametros = '';
        if( parametros != null ) {
            queryParametros += '?';
            for( String key : parametros.keySet() ) {
                queryParametros += key + '=' + parametros.get(key) + '&';
            }
        }

        queryParametros = queryParametros.length() == 0 ? '' : queryParametros.removeEnd('&');
        request.setEndpoint( url + service + queryParametros);
        request.setMethod('POST');
        request.setTimeout(120000);     
        if( body == null ) {
            request.setBody( '' );
        } else {
            request.setBody( body );
        }

        return request;
    }

    public class IntegrationUtilsException extends Exception {}

    //auth
    /*public static final String user = '';
    public static final String password = '';*/

    /*public static DOM.Document getEndpointResponse(String endpoint, DOM.Document params) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        //req.setMethod('GET');
        req.setMethod('POST');

        //Blob headerValue = Blob.valueOf(user + ':' + password);
        //String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        //req.setHeader('Authorization', authorizationHeader);

        if(params!=null){
            req.setHeader('Content-Type', 'text/xml');
            req.setBodyDocument(params);
        }

        HttpResponse res = null;
        DOM.Document result = null;

        try{
            res = h.send(req);
            result = res.getBodyDocument();

        }catch(System.Exception e){
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'dev@safetec.com.br'};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('dev@safetec.com.br');
            mail.setSenderDisplayName('Integration Problem');
            mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(e.getMessage());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            return null;
        }

        return result;

    }*/

    public static String removerCaracteresCGC(String cgc){
        cgc = cgc.replaceAll('/', '');
        cgc = cgc.replaceAll(',', '');
        cgc = cgc.replaceAll('-', '');
        cgc = cgc.replaceAll('\\.', '');
        return cgc;
    }

}