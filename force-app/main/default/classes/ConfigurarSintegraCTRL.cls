public with sharing class ConfigurarSintegraCTRL {

    private static Map<String,FieldWrapper> accountFieldsMap = new Map<String,FieldWrapper>();

    static {        
        for(Sintegra__mdt campo : [Select Id, MasterLabel, DeveloperName, Tipo__c from Sintegra__mdt]) {
            accountFieldsMap.put(campo.MasterLabel, new FieldWrapper(campo.DeveloperName, campo.Tipo__c ) );
            System.debug(campo);
        }
    }

    @AuraEnabled
    public static List<ConfigWrapper> getConfigs( String name ) {
        List<ConfigWrapper> result = new List<ConfigWrapper>();
        String likeName = name + '%';
System.debug(name);     
        List<Sintegra_Config__c> configs =  [Select Id, Name, Label__c, From__c, To__c, Prefix__c from Sintegra_Config__c where Prefix__c = :name Order By Label__c];
System.debug(configs);      
        if( configs.size() == 0 ) {
            configs = createConfigs( name );
            insert configs;
        }
        
        configs =  [Select Id, Name, Label__c, From__c, To__c, Prefix__c from Sintegra_Config__c where Prefix__c = :name Order By Label__c];
System.debug(configs);      
        result.addAll( getConfigsWrappers( configs, name ) );       
        return result;
    }

    @AuraEnabled
    public static List<CustomSelectOption> getFields( String sObjectName ) {
        List<CustomSelectOption> result = new List<CustomSelectOption>();
        Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();       
        for( Schema.SObjectField field : fieldMap.values() ) {
            Schema.DescribeFieldResult describe = field.getDescribe();
            if( describe.isAccessible() ) {

                if( describe.isUpdateable() && describe.getType() != DisplayType.Reference) {
                    result.add( new CustomSelectOption( describe.getName(), describe.getLabel() + '(' + describe.getName() + ')' ) );
                }
            }
        }

        result = quickSort( result );
        result.add(0,new CustomSelectOption('vazio', 'Selecione um campo'));
        return result;
    }

    @AuraEnabled
    public static void saveConfigs( String configsWrappersStr ){
        List<ConfigWrapper> configsWrappers = (List<ConfigWrapper>) JSON.deserialize( configsWrappersStr, List<ConfigWrapper>.class );
        System.debug('configsWrappers >>> ' + configsWrappers[0]);
        List<Sintegra_Config__c> configs = new List<Sintegra_Config__c>();

        for( ConfigWrapper configWrapper : configsWrappers ) {
            if(configWrapper.config.To__c == 'vazio'){
                configWrapper.config.To__c = null;
            }
            configs.add( configWrapper.config );
        }

        try {
            update configs;
        } catch( Exception e ) {
            System.debug(e.getStackTraceString());
            throw new AuraHandledException( e.getMessage() );
        }
    }

	@AuraEnabled
    public static String getToken() {
		String tokens = null;
        try{
			CNPJTokens__c tokensCS = CNPJTokens__c.getValues('Dreamm');
			tokens = tokensCS.Sintegra__c;

			return tokens;
		}catch(Exception ex){
			throw new AuraHandledException(ex.getMessage());
		}
    }

	@AuraEnabled
    public static void saveToken(String sintegra){
		
        try {
			CNPJTokens__c tokens = CNPJTokens__c.getValues('Dreamm');
			tokens.Sintegra__c = Sintegra;
            update tokens;
        } catch( Exception e ) {
            System.debug(e.getStackTraceString());
            throw new AuraHandledException( e.getMessage() );
        }
    }

    public class CustomSelectOption {
        @AuraEnabled public String value;
        @AuraEnabled public String label;

        public CustomSelectOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }

    public class ConfigWrapper {
        @AuraEnabled public FieldWrapper fieldWrapper;
        @AuraEnabled public Sintegra_Config__c config;
    }

    public class FieldWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String tipo;

        public FieldWrapper( String label, String tipo ) {
            this.label = label;
            this.tipo = tipo;
        }
    }

    private static List<Sintegra_Config__c> createConfigs( String name ) {
        Map<String,FieldWrapper> fieldsMap;
        fieldsMap = accountFieldsMap;

        List<Sintegra_Config__c> configs = new List<Sintegra_Config__c>();
        for( String key : fieldsMap.keySet() ) {
            Sintegra_Config__c config = new Sintegra_Config__c();
            config.Name = key;
            config.Label__c = fieldsMap.get( key ).label;
            config.From__c = fieldsMap.get( key ).label;
            config.Tipo__c = fieldsMap.get( key ).tipo;
            config.Prefix__c = name;
            configs.add( config );
        }
        return configs;
    }

    private static List<ConfigWrapper> getConfigsWrappers( List<Sintegra_Config__c> configs, String name ) {
        List<ConfigWrapper> result = new List<ConfigWrapper>();
System.debug(configs);      
        for( Sintegra_Config__c config : configs ) {
            ConfigWrapper wrapper = new ConfigWrapper();
            wrapper.fieldWrapper = accountFieldsMap.get( config.Name );
            wrapper.config = config;
            result.add( wrapper );
        }

        return result;
    }

    private static List<CustomSelectOption> quickSort(List<CustomSelectOption> vetor) {       
       return quickSort( vetor, 0, vetor.size() - 1 );
    }

    private static List<CustomSelectOption> quickSort(List<CustomSelectOption> vetor, Integer inicio, Integer fim) {
       if (inicio < fim) {
           Integer posicaoPivo = separar(vetor, inicio, fim);
           quickSort(vetor, inicio, posicaoPivo - 1);
           quickSort(vetor, posicaoPivo + 1, fim);
       }
       
       return vetor;
   }
   
   private static Integer separar(List<CustomSelectOption> vetor, Integer inicio, Integer fim) {
       CustomSelectOption pivo = vetor[inicio];
       Integer i = inicio + 1;
       Integer f = fim;
       
       while (i <= f) {
           if (vetor[i].label <= pivo.label)
               i++;
           else if (pivo.label < vetor[f].label)
               f--;
           else {
               CustomSelectOption troca = vetor[i];
               vetor[i] = vetor[f];
               vetor[f] = troca;
               i++;
               f--;
           }
       }
       
       vetor[inicio] = vetor[f];
       vetor[f] = pivo;
       return f;
   }                    
}