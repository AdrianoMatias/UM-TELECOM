public class HttpUtils {
    private static final HttpUtils instance = new HttpUtils();
    public static HttpUtils getInstance() {
        return instance;
    }
    
    public HttpResponse sendRequestAcesso(String metodo, String endPoint, String bodyJson, Map<String, String> headers, Integer timeout, String queryParams){
        
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        if(bodyJson != null) req.setBody(bodyJson);
        req.setHeader('Content-Type','application/json');
        
        System.debug('endPoint: ' +  endPoint);
        System.debug('bodyJson: ' +  bodyJson); 
        System.debug('req: ' +  req); 
        
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestGetUltimoContrato(String metodo, String endPoint, Integer timeout, String vToken, String queryParameter){
       
        String FinalEndpoint = endPoint + EncodingUtil.urlEncode(queryParameter, 'UTF-8');
      
        System.debug(FinalEndpoint);
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(FinalEndpoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken);   
                
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPOSTCartaoEquipamento(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
       
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPOSTContrato(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
       
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPatchItemContrato(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
       
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestGetUltimoCliente(String metodo, String endPoint, Integer timeout, String vToken, String queryParameter){
       
        String FinalEndpoint = endPoint + EncodingUtil.urlEncode(queryParameter, 'UTF-8');
      
        System.debug(FinalEndpoint);
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(FinalEndpoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken);   
                
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPOSTCliente(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
               
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPOSTSubnivel(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
       
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPOSTEstoque(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
       
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestUpdateItemIniciado(String metodo, String endPoint, Integer timeout, String vBody, String vToken, String queryParameters){
       
        String EndpointFinal = endPoint + '('+queryParameters+')';
                
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(EndpointFinal);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestGetClienteFornecedor(String metodo, String endPoint, Integer timeout, String vToken, String queryParameter){
       
        
        String FinalEndpoint = endPoint + EncodingUtil.urlEncode(queryParameter, 'UTF-8');
      
        System.debug('endPoint: '+endPoint);
        System.debug('FinalEndpoint: '+FinalEndpoint);
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(FinalEndpoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken);   
                
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestGetArvoreProd(String metodo, String endPoint, Integer timeout, String vToken){
       
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken);   
                
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    
    public HttpResponse sendRequestContractPlus(String metodo, String endPoint, String bodyJson, Integer timeout){
        
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        if(bodyJson != null) req.setBody(bodyJson);
        req.setHeader('Content-Type','application/json');
        
        System.debug('endPoint: ' +  endPoint);
        System.debug('bodyJson: ' +  bodyJson); 
        System.debug('req: ' +  req); 
        
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestUtilizacao(String metodo, String endPoint, Integer timeout, String vToken){
        
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken);   
        
        System.debug('endPoint: ' +  endPoint);
        System.debug('req: ' +  req); 
        
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPostTokenUltimoContractPlus(String metodo, String endPoint, Integer timeout, String vBody){
                      
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestGetUltimoContractPlus(String metodo, String endPoint, Integer timeout, String vToken){
                      
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization','Bearer '+vToken);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
    
    public HttpResponse sendRequestPostTaxaInstalacao(String metodo, String endPoint, Integer timeout, String vBody, String vToken){
                      
        HttpRequest req = new HttpRequest();
        req.setMethod(metodo);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cookie','B1SESSION='+vToken); 
        req.setBody(vBody);
        if(vBody != null) req.setBody(vBody);
        if(timeout != null) req.setTimeout(timeout);
        
        Http http = new Http();
        return http.send(req);
    }
}