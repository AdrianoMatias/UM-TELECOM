public with sharing class Sintegra_IntegrationUtils {
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
        } else {
            throw new AuraHandledException('Método não implementado');
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
}