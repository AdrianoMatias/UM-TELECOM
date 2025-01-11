@isTest
global class GenericResponse implements HttpCalloutMock {

    String response;
    Integer statusCode;
    String status;
    Map<String,String> header;

    public GenericResponse(String response, String status, Integer statusCode, Map<String,String> mapHeader){
        this.response = response;
        this.statusCode = statusCode;
        this.status = status;
        this.header = mapHeader;
    }

    public GenericResponse(String response, Integer statusCode, Map<String,String> mapHeader){
        this.response = response;
        this.statusCode = statusCode;
        this.header = mapHeader;
    }    

    public GenericResponse(String response, Integer statusCode){
        this.response = response;
        this.statusCode = statusCode;
    }      

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

        if (this.header!=null)
        {
            for (String key : this.header.keySet()) {
                res.setHeader(key, this.header.get(key));
            }   
        }
     
        if (this.response!=null)
        {
            res.setBody(this.response);
        }
        res.setStatusCode(this.statusCode);
        if (this.status!=null)
        {
            res.setStatus(this.status);
        }        
        
        return res;
    }
}