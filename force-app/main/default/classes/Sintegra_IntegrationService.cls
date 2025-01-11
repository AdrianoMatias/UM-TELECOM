public with sharing class Sintegra_IntegrationService {
    private static Sintegra_IntegrationService classInstance;

    static {
        classInstance = new Sintegra_IntegrationService();
    }

    private Sintegra_IntegrationService() {
        
    }

    public static Sintegra_IntegrationService getInstance() {
        return classInstance;
    }

    public Map<String, String> getInformacoes(String accCNPJ) {
        system.debug('accCNPJ ' + accCNPJ);
        accCNPJ = accCNPJ.replace('.', '');
        accCNPJ = accCNPJ.replace('/', '');
        accCNPJ = accCNPJ.replace('-', '');
        system.debug('accCNPJ ' + accCNPJ);
        Endpoint__mdt endpoint = [SELECT Url__c, Metodo__c FROM Endpoint__mdt WHERE MasterLabel = 'Sintegra'];
        if(String.isBlank(endpoint.Url__c) || String.isBlank(endpoint.Metodo__c)) {
            throw new AuraHandledException('Verifique se o Url e o Método da integração estão cadastrado no Custom Metadata.');
        }

        CNPJTokens__c token = CNPJTokens__c.getValues('Dreamm');
        if(String.isBlank(token.Sintegra__c)) {
            throw new AuraHandledException('Não há token cadastrado para o Sintegra, entre em contato com o administrador do sistema');
        }

		Map<String,String> cabecalhos = new Map<String,String>();
        cabecalhos.put('Content-Type' ,'application/json');
        String url = endpoint.Url__c + 'token=' + token.Sintegra__c + '&cnpj=' + accCNPJ + '&plugin=ST';

        Map<String, String> result = new Map<String, String>();
		try {
    		HttpResponse response = Sintegra_IntegrationUtils.doRequest( endpoint.Metodo__c, url, '', cabecalhos, null, '', 120000);
            String jsonString = response.getBody();
            System.debug(jsonString);
            System.debug(response);
            if(jsonString.contains('ERRO')) {
                throw new AuraHandledException('Este CNPJ não está OK com o Sintegra.');
            }
            
            if(String.isNotBlank(jsonString)) {
                Sintegra_IntegrationModels.SintegraResponse sintegraResponse = (Sintegra_IntegrationModels.SintegraResponse) JSON.deserialize(jsonString, Sintegra_IntegrationModels.SintegraResponse.class);
                result = Sintegra_IntegrationMapping.getInformacoes( sintegraResponse );
            }			
		} catch( Exception ex ) {
			System.debug(ex.getMessage());
			System.debug(ex.getStackTraceString());
			throw new AuraHandledException('Este CNPJ não está OK com o Sintegra, verifique se o CNPJ está correto.');
		}
    	return result;
    }
}