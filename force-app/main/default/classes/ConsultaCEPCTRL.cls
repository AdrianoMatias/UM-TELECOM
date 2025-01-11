public with sharing class ConsultaCEPCTRL {

    @AuraEnabled
    public static void consultaCEP( String idAnaliseViabilidade ) {
        Boolean cepPreenchido = false;
        Analise_de_viabilidade__c analiseViabilidade = [Select Id, CEP_de_origem__c, CEP_de_destino__c from Analise_de_viabilidade__c where Id = :idAnaliseViabilidade];
        System.debug( String.isNotBlank( analiseViabilidade.CEP_de_origem__c ) );
        if( String.isNotBlank( analiseViabilidade.CEP_de_origem__c ) ) {
           System.debug('analiseViabilidade.CEP_de_origem__c: ' + analiseViabilidade.CEP_de_origem__c);
            Correios.CEPResponse cepOrigem = Correios.getZIPCode( analiseViabilidade.CEP_de_origem__c.replace('.', '').replace('-', '') );
			System.debug('cepOrigem: ' + cepOrigem);
            if( cepOrigem != null ) {
                analiseViabilidade.Bairro_de_origem__c = cepOrigem.bairro;
                analiseViabilidade.Complemento_da_origem__c = cepOrigem.complemento;
                analiseViabilidade.Cidade_de_origem__c = cepOrigem.localidade;
                analiseViabilidade.Rua_de_origem__c = cepOrigem.logradouro;
                analiseViabilidade.Estado_de_origem__c = cepOrigem.uf;
                cepPreenchido = true;
            } else {
                AuraHandledException e = new AuraHandledException( 'Valor do CEP de origem inválido' );
                e.setMessage( 'Valor do CEP de origem inválido' );
                throw e;    
            }
        }
        
        if( String.isNotBlank( analiseViabilidade.CEP_de_destino__c ) ) {
            Correios.CEPResponse cepDestino = Correios.getZIPCode( analiseViabilidade.CEP_de_destino__c.replace('.', '').replace('-', '') );
            if( cepDestino != null ) {
                analiseViabilidade.Bairro_de_destino__c = cepDestino.bairro;
                analiseViabilidade.Complemento_do_destino__c = cepDestino.complemento;
                analiseViabilidade.Cidade_de_destino__c = cepDestino.localidade;
                analiseViabilidade.Rua_de_destino__c = cepDestino.logradouro;
                analiseViabilidade.Estado_de_destino__c = cepDestino.uf;
                cepPreenchido = true;
            } else {
                AuraHandledException e = new AuraHandledException( 'Valor do CEP de destino inválido' );
                e.setMessage( 'Valor do CEP de destino inválido' );
                throw e;    
            }
        }

        if( !cepPreenchido ) {
            AuraHandledException e = new AuraHandledException( 'É necessário informar ao menos um dos CEPs' );
            e.setMessage( 'É necessário informar ao menos um dos CEPs' );
            throw e;
        } else {            
            try {
                update analiseViabilidade;
            } catch( DmlException ex ) {
                AuraHandledException e = new AuraHandledException( ex.getMessage() );
                e.setMessage( ex.getMessage() );
                throw e;
            }
        }
    }
}