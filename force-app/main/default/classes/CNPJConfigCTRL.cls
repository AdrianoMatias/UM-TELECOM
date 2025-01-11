public with sharing class CNPJConfigCTRL {

    private static Map<String,FieldWrapper> accountFieldsMap = new Map<String,FieldWrapper>();
    private static Map<String,FieldWrapper> contactFieldsMap = new Map<String,FieldWrapper>();

    static {        
        for( Campos_CNPJ__mdt campo : [Select Id, MasterLabel, Label__c, Tipo__c from Campos_CNPJ__mdt where Objeto__r.MasterLabel='Account'] ) {
            accountFieldsMap.put( campo.MasterLabel, new FieldWrapper( campo.Label__c, campo.Tipo__c  ) );
        }

        for( Campos_CNPJ__mdt campo : [Select Id, MasterLabel, Label__c, Tipo__c from Campos_CNPJ__mdt where Objeto__r.MasterLabel='Contact'] ) {
            contactFieldsMap.put( campo.MasterLabel, new FieldWrapper( campo.Label__c, campo.Tipo__c  ) );
        }
    }

    @AuraEnabled
    public static List<ConfigWrapper> getConfigs( String name ) {
        List<ConfigWrapper> result = new List<ConfigWrapper>();
        String likeName = name + '%';
System.debug(name);     
        List<CNPJConfig__c> configs =  [Select Id, Name, Label__c, From__c, To__c, Prefix__c from CNPJConfig__c where Prefix__c = :name Order By Label__c];
System.debug(configs);      
        if( configs.size() == 0 ) {
            configs = createConfigs( name );
            insert configs;
        }
        
        configs =  [Select Id, Name, Label__c, From__c, To__c, Prefix__c from CNPJConfig__c where Prefix__c = :name Order By Label__c];
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
        return result;
    }

    @AuraEnabled
    public static void saveConfigs( String configsWrappersStr ){
        List<ConfigWrapper> configsWrappers = (List<ConfigWrapper>) JSON.deserialize( configsWrappersStr, List<ConfigWrapper>.class );
        List<CNPJConfig__c> configs = new List<CNPJConfig__c>();

        for( ConfigWrapper configWrapper : configsWrappers ) {
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
    public static String getToken( String param ) {
		String tokens = null;
        try{
			CNPJTokens__c tokensCS = CNPJTokens__c.getValues('Dreamm');
			if( param == 'Receita') {
				tokens = tokensCS.Receita__c;
			}else if( param == 'Maps') {
				tokens = tokensCS.Maps__c;
			}
			return tokens;
		}catch(Exception ex){
			throw new AuraHandledException(ex.getMessage());
		}
    }

	@AuraEnabled
    public static void saveToken( String Receita, String GoogleMaps ){
		
        try {
			CNPJTokens__c tokens = CNPJTokens__c.getValues('Dreamm');
			tokens.Receita__c = Receita;
			tokens.Maps__c = GoogleMaps;
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
        @AuraEnabled public CNPJConfig__c config;
    }

    public class FieldWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String tipo;

        public FieldWrapper( String label, String tipo ) {
            this.label = label;
            this.tipo = tipo;
        }
    }

    private static List<CNPJConfig__c> createConfigs( String name ) {
        Map<String,FieldWrapper> fieldsMap;
        if( name == 'Acc' ) {
            fieldsMap = accountFieldsMap;
        } else if( name == 'Con' ) {
            fieldsMap = contactFieldsMap;           
        }
        List<CNPJConfig__c> configs = new List<CNPJConfig__c>();
        for( String key : fieldsMap.keySet() ) {
            CNPJConfig__c config = new CNPJConfig__c();
            config.Name = key;
            config.Label__c = fieldsMap.get( key ).label;
            config.To__c = key;
            config.Prefix__c = name;
            configs.add( config );
        }
        return configs;
    }

    private static List<ConfigWrapper> getConfigsWrappers( List<CNPJConfig__c> configs, String name ) {
        List<ConfigWrapper> result = new List<ConfigWrapper>();
System.debug(configs);      
        for( CNPJConfig__c config : configs ) {
            ConfigWrapper wrapper = new ConfigWrapper();
            if( name == 'Acc' ) {
                wrapper.fieldWrapper = accountFieldsMap.get( config.To__c );
            } else if( name == 'Con' ) {
                wrapper.fieldWrapper = contactFieldsMap.get( config.To__c );
            }
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