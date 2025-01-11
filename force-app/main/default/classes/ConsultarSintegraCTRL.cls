public with sharing class ConsultarSintegraCTRL {
    @AuraEnabled
    public static void buscarSintegra(String accId) {
        List<Account> conta = [SELECT Name, CNPJ__c FROM Account WHERE Id = :accId];
        if(String.isBlank(conta[0].CNPJ__c)) {
            throw new AuraHandledException('Verifique se a conta tem CNPJ cadastrado');
        } else {
            Map<String, String> resultado = Sintegra_IntegrationService.getInstance().getInformacoes(conta[0].CNPJ__c);
            List<Sintegra_Config__c> sintegraList = [SELECT Name ,From__c, Label__c, To__c, Tipo__c FROM Sintegra_Config__c WHERE Prefix__c = 'Acc'];
            
            for(Sintegra_Config__c sintegra : sintegraList) {
                if(sintegra.Tipo__c.contains('Texto') && String.isNotBlank(sintegra.To__c)) {
                    String valor = resultado.get(sintegra.From__c) != null ? resultado.get(sintegra.From__c) : ''; 
                    conta[0].put(sintegra.To__c, valor);
                    
                } else if(sintegra.Tipo__c.contains('Data') && String.isNotBlank(sintegra.To__c)) {
                    String valor = resultado.get(sintegra.From__c);
                    if(valor != null && valor != '') {
                        valor = valor.replaceAll('-', '/');
                        conta[0].put(sintegra.To__c, Date.parse(valor));
                    } else {
                        conta[0].put(sintegra.To__c, null);
                    }
                    
                } else if(sintegra.Tipo__c.contains('Número') && String.isNotBlank(sintegra.To__c)) {
                    String valor = resultado.get(sintegra.From__c);
                    if(valor != null && valor != '') {
                        conta[0].put(sintegra.To__c, Decimal.valueOf(valor));
                    } else {
                        conta[0].put(sintegra.To__c, null);
                    }
                }
                update conta;
            }
        }
    }
}