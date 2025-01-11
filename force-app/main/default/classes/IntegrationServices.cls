public with sharing class IntegrationServices {
    
    private static IntegrationServices instance;
    
    public IntegrationServices() { }
    
    public static IntegrationServices getInstance(){
        if(instance == null){
            instance = new IntegrationServices();
        }
        return instance;
    }
    
    public static IntegrationModels.ProdutoViabilidade getSAPServiceProdutoViabilidade(String codigo) {
        IntegrationModels.ProdutoViabilidade result = new IntegrationModels.ProdutoViabilidade();
        
        Integracoes__c endPoint = Integracoes__c.getValues('Item de Viabilidade');
        Map<String,String> cabecalhos = new Map<String,String>();
        cabecalhos.put('Content-Type','application/json');
        cabecalhos.put('Authorization', endPoint.token__c);
        HttpResponse response = IntegrationUtils.doRequest(endPoint.Metodo__c, endPoint.url__c + codigo, '', cabecalhos, null, '', 12000);
        String jsonString = response.getBody();
        System.debug('JsonString: ' + JSON.serializePretty(jsonString));
        result = (IntegrationModels.ProdutoViabilidade) JSON.deserialize( jsonString , IntegrationModels.ProdutoViabilidade.class);
        
        return result;
    }

    public static IntegrationModels.ClienteResponse EnviarSAPServiceCliente(Account conta, String tipo) {
		IntegrationModels.ClienteResponse result = new IntegrationModels.ClienteResponse();

        IntegrationModels.Cliente request = IntegrationMappings.getClientes(conta, tipo);
        Integracoes__c endpoint = Integracoes__c.getValues('Cliente');
		Map<String,String> cabecalhos = new Map<String,String>();
		cabecalhos.put('Content-Type','application/json');
		cabecalhos.put('Authorization', endpoint.token__c); 
        String requestBody = JSON.serialize(request);
		System.debug('request body >>>>>'+requestBody);
        HttpResponse response= IntegrationUtils.doRequest(endpoint.metodo__c, endpoint.url__c, '', cabecalhos, null, requestBody,12000);
        String jsonString = response.getBody();
		System.debug('response body >>>>> '+response.getBody());
		System.debug('Status >>>>> '+response.getStatusCode());
        result = (IntegrationModels.ClienteResponse) JSON.deserialize( jsonString , IntegrationModels.ClienteResponse.class);
		System.debug('error  >>>>> '+result.error_description);
		if(response.getStatusCode()!=200 && response.getStatusCode()!=201){
			result.status_code = response.getStatusCode();
		}
        
       return result;
    }

	public static IntegrationModels.ClienteResponse EnviarSAPServiceContato(Contact contato, string codigoSAP) {
		IntegrationModels.ClienteResponse result = new IntegrationModels.ClienteResponse();

        IntegrationModels.Contato request = IntegrationMappings.getContato(contato);
        Integracoes__c endpoint = Integracoes__c.getValues('Contato');
        String requestBody = JSON.serialize(request);
		System.debug('request body >>>>>'+requestBody);
		Map<String,String> cabecalhos = new Map<String,String>();
		cabecalhos.put('Content-Type','application/json');
		cabecalhos.put('Authorization', endpoint.token__c); 
		endpoint.url__c = endpoint.url__c.replace('%codigo', codigoSAP);
        HttpResponse response= IntegrationUtils.doRequest(endpoint.metodo__c, endpoint.url__c, '',cabecalhos, null, requestBody,12000);
        String jsonString = response.getBody();
		System.debug('response body >>>>> '+response.getBody());
		System.debug('Status >>>>> '+response.getStatusCode());
        result = (IntegrationModels.ClienteResponse) JSON.deserialize( jsonString , IntegrationModels.ClienteResponse.class);
		System.debug('error  >>>>> '+result.error_description);   
		if(response.getStatusCode()!=200 && response.getStatusCode()!=201){
			result.status_code = response.getStatusCode();
		}

       return result;
    }

	public static IntegrationModels.ClienteResponse EnviarSAPServiceEndereco(Account conta, String tipo, String codigo) {
		IntegrationModels.ClienteResponse result = new IntegrationModels.ClienteResponse();

        IntegrationModels.Endereco request = IntegrationMappings.getEndereco(conta, tipo);
        Integracoes__c endpoint = Integracoes__c.getValues('Endereço');
        String requestBody = JSON.serialize(request);
		System.debug('request body >>>>> '+requestBody);
        Map<String,String> cabecalhos = new Map<String,String>();
		cabecalhos.put('Content-Type','application/json');
		cabecalhos.put('Authorization', endpoint.token__c); 
		endpoint.url__c = endpoint.url__c.replace('%codigo', codigo);
        HttpResponse response= IntegrationUtils.doRequest(endpoint.metodo__c, endpoint.url__c, '',cabecalhos, null, requestBody,12000);
        String jsonString = response.getBody();
		System.debug('response body >>>>> '+response.getBody());
		System.debug('Status >>>>> '+response.getStatusCode());
        result = (IntegrationModels.ClienteResponse) JSON.deserialize( jsonString , IntegrationModels.ClienteResponse.class);
		System.debug('error  >>>>> '+result.error_description);
		if(response.getStatusCode()!=200 && response.getStatusCode()!=201){
			throw new AuraHandledException(result.error_description);
		}
        
       return result;
    }

	public static IntegrationModels.ClienteResponse EnviarSAPServiceOportunidade(Opportunity opp, List<OpportunityLineItem> oli, Map<Id,Analise_de_viabilidade__c> analises) {
		IntegrationModels.ClienteResponse result = new IntegrationModels.ClienteResponse();

        IntegrationModels.Contrato request = IntegrationMappings.getContrato(opp,oli,analises);
        Integracoes__c endpoint = Integracoes__c.getValues('Contrato');
        String requestBody = JSON.serialize(request);
		System.debug('request body >>>>> '+requestBody);
        Map<String,String> cabecalhos = new Map<String,String>();
		cabecalhos.put('Content-Type','application/json');
		cabecalhos.put('Authorization', endpoint.token__c); 
        HttpResponse response= IntegrationUtils.doRequest(endpoint.metodo__c, endpoint.url__c, '',cabecalhos, null, requestBody,12000);
        String jsonString = response.getBody();
		System.debug('response body >>>>> '+response.getBody());
		System.debug('Status >>>>> '+response.getStatusCode());
        result = (IntegrationModels.ClienteResponse) JSON.deserialize( jsonString , IntegrationModels.ClienteResponse.class);
		System.debug('error  >>>>> '+result.error_description);
		if(response.getStatusCode()!=200 && response.getStatusCode()!=201){
			throw new AuraHandledException(result.error_description);
		}
        
       return result;
	}
	
	public void EnviarSAPDesconto( String numeroCircuito, Date data, Decimal duracao ) {
		IntegrationModels.Desconto descontoRequest = new IntegrationModels.Desconto();
		descontoRequest.circuito = numeroCircuito;
		descontoRequest.data = Datetime.newInstance(data, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
		descontoRequest.minutos = duracao;

		Integracoes__c endpoint = Integracoes__c.getValues( 'Desconto' );

        Map<String,String> cabecalhos = new Map<String,String>();
		cabecalhos.put('Content-Type','application/json');
		cabecalhos.put('Authorization', endpoint.token__c); 

		 try {
			 if(!Test.isRunningTest()){
				HttpResponse hResponse = IntegrationUtils.doRequest(endpoint.Metodo__c, endpoint.url__c, '', cabecalhos, null, JSON.serialize( descontoRequest ), 120000);
				if( hResponse.getStatusCode() != 200 && hResponse.getStatusCode() != 201 ) {				
					IntegrationModels.ClienteResponse response = (IntegrationModels.ClienteResponse) JSON.deserialize(hResponse.getBody(), IntegrationModels.ClienteResponse.class);
					System.debug( response );
					throw new IntegrationServicesException( 'Houve um erro ao enviar a requisição. Detalhes:' + response.error_description );
				}
			 }
		 } catch( CalloutException e ) {
		 	System.debug( e.getMessage() );
		 	throw new IntegrationServicesException( e );
		 }

	}

    
    public class IntegrationServicesException extends Exception {
        
    }
}