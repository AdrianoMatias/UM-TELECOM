public interface IHttpService {
    
    HttpResponse executarGet(String namedCredential, String endpointUrl);
    
    HttpResponse executarGet(String namedCredential, String endpointUrl, Map<String, String> additionalHeader);
    
    HttpResponse executarPost(String namedCredential, String endpointUrl, String payload);
    
    HttpResponse executarPost(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader);
    
    HttpResponse executarPut(String namedCredential, String endpointUrl, String payload);
    
    HttpResponse executarPut(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader);
    
    HttpResponse executarPatch(String namedCredential, String endpointUrl, String payload);
    
    HttpResponse executarPatch(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader);

    HttpResponse executarDelete(String namedCredential, String endpointUrl, String payload);
    
    HttpResponse executarDelete(String namedCredential, String endpointUrl, String payload, Map<String, String> additionalHeader);
    
}