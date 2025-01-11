@RestResource(urlMapping='/umtelecom/*/titulo-financeiro/*')
global with sharing class TituloFinanceiroService {
    @HttpPost
    global static void doPost() {
        String version = RestContext.request.requestURI.substringBetween( '/umtelecom/', '/titulo-financeiro' );

        if( String.isBlank( version ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'A versão da API deve ser informada.' );
        } else {
            List<Service_Version__c> versions = [SELECT Id, Handler__c FROM Service_Version__c WHERE Service__r.Name = 'TituloFinanceiroService' and Service__r.Is_Active__c = true and Name = :version and Released__c = true LIMIT 1];
            if( versions.isEmpty() ) {
                ServiceError.throwServiceError( 404, 'Not Found', 'A versão da API não está disponível.' );
            } else {
                ServiceInterface instance =  (ServiceInterface) Type.forName(versions[0].Handler__c).newInstance();
                String schemaValidation = instance.checkJSONSchema( RestContext.request.requestBody.toString() );
                if( schemaValidation != null ) {
                    ServiceError.throwServiceError( 404, 'Not Found', schemaValidation );
                } else {
                    instance.doPost();
                }
            }
        }
    }

    @HttpPatch
    global static void doPatch() {
        String version = RestContext.request.requestURI.substringBetween( '/umtelecom/', '/titulo-financeiro' );

        if( String.isBlank( version ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'A versão da API deve ser informada.' );
        } else {
            List<Service_Version__c> versions = [SELECT Id, Handler__c FROM Service_Version__c WHERE Service__r.Name = 'TituloFinanceiroService' and Service__r.Is_Active__c = true and Name = :version and Released__c = true LIMIT 1];
            if( versions.isEmpty() ) {
                ServiceError.throwServiceError( 404, 'Not Found', 'A versão da API não está disponível.' );
            } else {                
                ServiceInterface instance =  (ServiceInterface) Type.forName(versions[0].Handler__c).newInstance();
                String schemaValidation = (String) instance.checkJSONSchema( RestContext.request.requestBody.toString() );
                if( schemaValidation != null ) {
                    ServiceError.throwServiceError( 400, 'Bad Request', schemaValidation );
                } else {
                    instance.doPatch();
                }
            }
        }
    }
}