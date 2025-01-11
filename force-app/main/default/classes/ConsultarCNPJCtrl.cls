public class ConsultarCNPJCtrl {
    
    public static String token;
    public static String tokenMaps;
    
    public static final String endpoint = 'https://www.receitaws.com.br/v1/cnpj/';
    public static final String days = '/days/32';
    
    public static String cnpj;
    public static String jsonResult;
    public static String statusConsulta;
    
    public static Account accObj;
    
    public static Map<String, ConsultarCNPJCtrl.ResultadoConsulta> mapaOpcoes;
    public static List<String> cnpjsList;
    public static Map<String,String[]> mapaRetornosConta = new Map<String,String[]>();
    public static Map<String,String[]> mapaRetornosContatos = new Map<String,String[]>();
    
    public static Map<String, CNPJConfig__c> accountConfigsMap;
    public static Map<String, CNPJConfig__c> contactConfigsMap;
    
    public static Map<String,Map<String,Schema.SObjectField>> fieldsMap;
    
    static {
        for( Campos_CNPJ__mdt campo : [Select Id, MasterLabel, Label__c, Tipo__c, Tipo_Retorno__c, DeveloperName from Campos_CNPJ__mdt where Objeto__r.MasterLabel='Account'] ) { 
            mapaRetornosConta.put( campo.MasterLabel, new String[]{campo.DeveloperName, campo.Tipo_Retorno__c});
        }
        
        for( Campos_CNPJ__mdt campo : [Select Id, MasterLabel, Label__c, Tipo__c, Tipo_Retorno__c, DeveloperName from Campos_CNPJ__mdt where Objeto__r.MasterLabel='Contact'] ) {
            mapaRetornosContatos.put( campo.MasterLabel, new String[]{campo.DeveloperName, campo.Tipo_Retorno__c});
        }
        
        CNPJTokens__c tokens = CNPJTokens__c.getValues('Dreamm');
        if( tokens != null ) {
            token = tokens.Receita__c;
            tokenMaps = tokens.Maps__c;
        }
        
        List<CNPJConfig__c> accountConfigs = [SELECT Id, From__c, To__c, Label__c, Prefix__c FROM CNPJConfig__c where Prefix__c = 'Acc'];
        accountConfigsMap = new Map<String, CNPJConfig__c>();
        for ( CNPJConfig__c accountConfig : accountConfigs ) {
            System.debug( accountConfig.To__c );
            accountConfigsMap.put( accountConfig.To__c, accountConfig );
        }
        
        List<CNPJConfig__c> contactConfigs = [SELECT Id, From__c, To__c, Label__c, Prefix__c FROM CNPJConfig__c where Prefix__c = 'Con'];
        contactConfigsMap = new Map<String, CNPJConfig__c>();
        for ( CNPJConfig__c contactConfig : contactConfigs ) {
            contactConfigsMap.put( contactConfig.To__c, contactConfig );
        }
        
        fieldsMap = new Map<String,Map<String,Schema.SObjectField>>();
        fieldsMap.put('Account', Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap());
        fieldsMap.put('Contact', Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap());
    }
    
    
    @AuraEnabled
    public static List<String> getCNPJs(Id accId) {
        String cnpjField = accountConfigsMap.get('CNPJ__c').From__c;
        
        if( cnpjField != null && hasFieldAccess( 'Account', cnpjField, false ) ) {
            String accountQuery = 'Select Id, Name, ' + cnpjField + ' from Account where Id = :accId LIMIT 1';
            accObj = Database.query(accountQuery);
            cnpj = (String) accObj.get(cnpjField);
            
            if(String.isEmpty(cnpj)) {
                List<String> result = buscarCnpjGoogle('CNPJ' + '&exactTerms=' + accObj.Name.replace(' ', '+')+'&cr=countryBR');//página 1
                result.addAll(buscarCnpjGoogle('CNPJ' + '&exactTerms=' + accObj.Name.replace(' ', '+')+'&cr=countryBR&start=11'));//página 2
                result.addAll(buscarCnpjGoogle('CNPJ' + '&exactTerms=' + accObj.Name.replace(' ', '+')+'&cr=countryBR&start=21'));//página 3
                
                if(!result.isEmpty()) {
                    mapaOpcoes = new Map<String, ConsultarCNPJCtrl.ResultadoConsulta>();
                    cnpjsList = new List<String>();
                    for(String rst : result) {
                        ConsultarCNPJCtrl.ResultadoConsulta objCNPJ = consultarCNPJ(rst);
                        
                        if( objCNPJ.situacao != 'INAPTA' && objCNPJ.situacao != 'BAIXADA') {
                            mapaOpcoes.put(objCNPJ.cnpj, objCNPJ);
                            cnpjsList.add(objCNPJ.cnpj + ' | ' + objCNPJ.nome + ' (' + objCNPJ.tipo + ')(' + objCNPJ.municipio + '-' + objCNPJ.uf + ')');   
                        }
                    }
                }
            } else {
                mapaOpcoes = new Map<String, ConsultarCNPJCtrl.ResultadoConsulta>();
                cnpjsList = new List<String>();
                ConsultarCNPJCtrl.ResultadoConsulta objCNPJ = consultarCNPJ(cnpj);
                mapaOpcoes.put(objCNPJ.cnpj, objCNPJ);
                cnpjsList.add(objCNPJ.cnpj + ' | ' + objCNPJ.nome + ' (' + objCNPJ.tipo + ')(' + objCNPJ.municipio + '-' + objCNPJ.uf + ')');
            }   
            
            return cnpjsList;
        } else {
            throw new AuraHandledException('Erro: Você não possui acesso ao campo referente ao CNPJ. Favor contactar o seu administrador');
        }
    }
    
    private static List<String> buscarCnpjGoogle(String pesquisa) {
        pesquisa = pesquisa.replaceAll(' ', '+');
        String endpoint = 'https://www.googleapis.com/customsearch/v1?key='+tokenMaps+'&cx=003888085220396908859:i0w1ybjxqk0&q=';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint + pesquisa);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        req.setTimeout(120000);
        HttpResponse res = h.send(req);
        String jsonResult = res.getBody();
        System.debug('AQUI: ' + JSON.serialize(jsonResult));
        
        // DIMINUINDO O TAMANHO DA STRING PRA FACILITAR
        jsonResult = jsonResult.replaceAll(' ', '');
        jsonResult = jsonResult.replaceAll('\"', '');
        jsonResult = jsonResult.replaceAll('https://www.foneempresas.com/', '');
        jsonResult = jsonResult.replaceAll('https://www.consultasocio.com/', '');
        jsonResult = jsonResult.replaceAll('www.consultasocio.com/', '');
        jsonResult = jsonResult.replaceAll('https://www.empresascnpj.com/', '');
        jsonResult = jsonResult.replaceAll('\\[', '');
        jsonResult = jsonResult.replaceAll('\\]', '');
        jsonResult = jsonResult.replaceAll('\\{', '');
        jsonResult = jsonResult.replaceAll('\\}', '');
        jsonResult = jsonResult.replaceAll('\\n', '');
        jsonResult = jsonResult.replaceAll(':', ' ');
        jsonResult = jsonResult.replaceAll('."', ' ');
        jsonResult = jsonResult.replaceAll('\\s{6}', '');
        jsonResult = jsonResult.replaceAll('\\"Descubra o CNPJ, endereço e telefone das empresas do sócio', '');
        jsonResult = jsonResult.replaceAll('\"formattedUrl\": \"https://www.empresascnpj.com/', '');
        
        Pattern myPattern = Pattern.compile('(\\d{2}.\\d{3}.\\d{3}\\/\\d{4}-\\d{2})');
        
        List<String> encontrados = new List<String>();
        Matcher myMatcher = myPattern.matcher(jsonResult);
        myMatcher.matches();
        while(myMatcher.find()) {
            try {
                System.debug('GROUP COUNT: ' + myMatcher.groupCount());
                if(myMatcher.groupCount() > 0) {
                    String encontrado = myMatcher.group(0);
                    jsonResult = jsonResult.replaceAll(encontrado, '');
                    encontrados.add(encontrado);
                    myMatcher = myPattern.matcher(jsonResult);
                    myMatcher.matches();
                }
            } catch(Exception ex) {
                System.debug('Exception message thrown: ' + ex.getMessage() + ' || Stack Trace: ' + ex.getStackTraceString());
                break;
            }
        }
        
        return encontrados;
    }
    
    public static ConsultarCNPJCtrl.ResultadoConsulta consultarCNPJ(String cnpj) {
        String specialChars = '&|^|@|,|/|-|.';
        
        for(Integer i = 0; i < specialChars.split('|').size(); i++) {
            cnpj = cnpj.replace(specialChars.split('|')[i], '');  
        } 
        cnpj = cnpj.trim();
        
        String finalEndpoint = endpoint + cnpj + days;
        
        Map<String,String> headers = new Map<String,String> {
            'Content-Type'  => 'application/json',
                'Authorization' => ('Bearer ' + token)
                };
                    
                    HttpResponse res = IntegrationUtils.doRequest( 'GET', finalEndpoint, '', headers, null, null, 120000 );
        
        jsonResult = res.getBody();
        
        ConsultarCNPJCtrl.ResultadoConsulta objRetorno = null;
        try {
            jsonResult = res.getBody(); 
            objRetorno = (ConsultarCNPJCtrl.ResultadoConsulta) JSON.deserialize(jsonResult, ConsultarCNPJCtrl.ResultadoConsulta.class);
            System.debug('>>> '+objRetorno);
        } catch(System.Exception ex) {
            
            statusConsulta = 'falha';
        }
        
        if(objRetorno != null) {
            return objRetorno;
        } else {
            return null;            
        }
    }    
    
    @AuraEnabled
    public static void selecionarCNPJ(String cnpjParam, String accIdParam) {
        String cnpjField = accountConfigsMap.get('CNPJ__c').From__c;
        
        if( hasFieldAccess( 'Account', cnpjField, false ) ) {
            String accountQuery = 'Select Id, ' + cnpjField + ' from Account where Id = :accIdParam LIMIT 1';
            
            accObj = Database.query(accountQuery);
            
            ConsultarCNPJCtrl.ResultadoConsulta objRetornoParam = consultarCNPJ(cnpjParam);
            atualizarConta(objRetornoParam);   
        } else {
            throw new AuraHandledException('Erro: Você não possui acesso ao campo referente ao CNPJ. Favor contactar o seu administrador');
        }
    }
    
    private static void atualizarConta(ConsultarCNPJCtrl.ResultadoConsulta objRetorno){
        if(objRetorno!=null){
            
            if( accountConfigsMap.values().size() == 0 ) {
                throw new AuraHandledException('Não foi encontrada nenhuma configuração de Conta');                
            }
            
            if( contactConfigsMap.values().size() == 0 ) {
                throw new AuraHandledException('Não foi encontrada nenhuma configuração de Contato');                
            }
            
            String descricaoAtividades = '';
            descricaoAtividades = '';
            descricaoAtividades += 'Atividade Principal: \n    -    ' + objRetorno.atividade_principal[0].text + ' (CNAE:'+objRetorno.atividade_principal[0].code+') \nAtividades Secundárias:\n';
            for(ConsultarCNPJCtrl.AtividadesSecundaria sec : objRetorno.atividades_secundarias){
                descricaoAtividades += '    -    ' + sec.text + ' (CNAE:'+sec.code+') \n';
            }
            
            objRetorno.descricao_atividades = descricaoAtividades;
            
            if(objRetorno.telefone.contains('/')){
                List<String> numeros = objRetorno.telefone.split('/'); 
                if( accountConfigsMap.containsKey('Phone') ) {
                    objRetorno.telefoneStr = numeros[0];
                    objRetorno.faxStr = numeros[1];
                }
            }else{
                objRetorno.telefoneStr = objRetorno.telefone;
            }
            
            objRetorno.endereco = objRetorno.logradouro + ', Nº '+ objRetorno.numero+ ', ' + objRetorno.bairro;   
            objRetorno.pais = 'BRASIL';   
            
            try {
                objRetorno = getLatLng( objRetorno );
            } catch( CNPJException ex ) {
                statusConsulta = 'falha';
                
            }
            
            for( String campoDreamm : mapaRetornosConta.keySet() ) {
                String campoRetorno = mapaRetornosConta.get(campoDreamm)[0];
                String tipoRetorno = mapaRetornosConta.get(campoDreamm)[1];
                
                if( accountConfigsMap.containsKey( campoDreamm ) && objRetorno.get(campoRetorno) != null && hasFieldAccess( 'Account', accountConfigsMap.get( campoDreamm ).From__c , true ) ) {
                    if( tipoRetorno == 'string' ) {
                        accObj.put( accountConfigsMap.get( campoDreamm ).From__c, String.valueOf(objRetorno.get(campoRetorno) ));
                    } else if( tipoRetorno == 'date' ) {
                        accObj.put( accountConfigsMap.get( campoDreamm ).From__c, Date.parse((String) objRetorno.get(campoRetorno) ));
                    } else if( tipoRetorno == 'number' ) {
                        accObj.put( accountConfigsMap.get( campoDreamm ).From__c, Decimal.valueOf(String.valueOf(objRetorno.get(campoRetorno))));
                    }                    
                }
            }
            
            try{
                update accObj;
                
            } catch (Exception ex) {
                if(ex.getMessage().contains('DUPLICATES_DETECTED')){
                    throw new CNPJException('Essa conta já está cadastrada. Verifique o nome ou CNPJ.');
                }else{
                    throw new CNPJException(ex.getMessage());
                }
            }
            
            
            //cadastrando sócios
            List<Contact> socios = [SELECT Id FROM Contact WHERE AccountId=:accObj.Id AND Title='Sócio'];
            if(socios.size()!=null&&socios.size()>0) delete socios;
            List<Contact> sociosCadastrar = new List<Contact>();
            for(ConsultarCNPJCtrl.Qsa soc : objRetorno.qsa){
                
                Contact cont = new Contact();
                cont.Title = 'Sócio';
                cont.AccountId = accObj.Id;
                
                for( String campoDreamm : mapaRetornosContatos.keySet() ) {
                    String campoRetorno = mapaRetornosContatos.get(campoDreamm)[0];
                    String tipoRetorno = mapaRetornosContatos.get(campoDreamm)[1];
                    
                    ObjectProxy reference;
                    if( campoRetorno.contains('thesplit_') ) {
                        reference = objRetorno;
                        campoRetorno = campoRetorno.split('split_')[1];                        
                    } else {
                        reference = soc;
                    }
                    
                    if( contactConfigsMap.containsKey( campoDreamm ) && reference.get(campoRetorno) != null && hasFieldAccess( 'Contact', contactConfigsMap.get( campoDreamm ).From__c, true ) ) {
                        if( tipoRetorno == 'string' ) {
                            cont.put( contactConfigsMap.get( campoDreamm ).From__c, String.valueOf(reference.get(campoRetorno) ));
                        } else if( tipoRetorno == 'date' ) {
                            cont.put( contactConfigsMap.get( campoDreamm ).From__c, Date.parse((String) reference.get(campoRetorno) ));
                        } else if( tipoRetorno == 'number' ) {
                            cont.put( contactConfigsMap.get( campoDreamm ).From__c, Decimal.valueOf(String.valueOf(reference.get(campoRetorno))));
                        }                    
                    }
                }
                
                List<String> listNome = soc.nome.split(' ');
                cont.FirstName = listNome.get(0);
                cont.LastName = soc.nome.replace(cont.FirstName+' ', '');
                sociosCadastrar.add(cont);
            }
            
            insert sociosCadastrar;
            statusConsulta = 'sucesso';
        }
        
    }
    
    private static ConsultarCNPJCtrl.ResultadoConsulta getLatLng( ConsultarCNPJCtrl.ResultadoConsulta objRetorno ) {
        String enderecoConsulta = objRetorno.logradouro + ', Nº '+ objRetorno.numero+ ', ' + objRetorno.bairro + ', ' + objRetorno.municipio + ', ' + objRetorno.uf +' ' + objRetorno.cep +  ', ' + objRetorno.pais;
        Http h2 = new Http();
        HttpRequest req2 = new HttpRequest();
        String ep = 'https://maps.googleapis.com/maps/api/geocode/json?address='+enderecoConsulta+'&sensor=false&key=' + tokenMaps;
        ep = ep.replaceAll(' ', '+');
        
        try{
            HttpResponse res2 = IntegrationUtils.doRequest( 'GET', ep, '', new Map<String,String> {'Content-Type' => 'application/json'}, null, null, 60000 );
            JSONParser parser = JSON.createParser(res2.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                        parser.nextToken(); // object start
                        while (parser.nextToken() != JSONToken.END_OBJECT){
                            String txt = parser.getText();
                            parser.nextToken();
                            if (txt == 'lat')
                                lat = parser.getDoubleValue();
                            else if (txt == 'lng')
                                lon = parser.getDoubleValue();
                        }
                    }
            }
            
            if (lat != null){
                objRetorno.lat = lat;
                objRetorno.lng = lon;
            }   
        } catch (Exception ex) {
            
            throw new CNPJException( ex.getMessage() );
        }
        
        return objRetorno;
    }
    
    
    private static Boolean hasFieldAccess( String sObjectName, String fieldName, Boolean readAndUpdate ) {
        Schema.SObjectField field = fieldsMap.get(sObjectName).get(fieldName);
        return field != null &&  field.getDescribe().isAccessible() && ( readAndUpdate && field.getDescribe().isUpdateable() || !readAndUpdate );
    }
    
    public abstract class ObjectProxy {
        public Object get( String attribute ) {
            String jsonSTR = JSON.serialize(this);
            Map<String,Object> mapaCampos = (Map<String,Object>) JSON.deserializeUntyped( jsonSTR );
            return mapaCampos.get( attribute );
        }
    }
    
    public class AtividadePrincipal {
        public string text;
        public string code;
    }
    
    public class AtividadesSecundaria {
        public string text;
        public string code;
    }
    
    public class Qsa extends ObjectProxy {
        public string qual;
        public string nome;
        public string cargo;
        public string primeiroNome;
        public string sobrenome;
    }
    
    public class ResultadoConsulta extends ObjectProxy {
        public List<AtividadePrincipal> atividade_principal;
        public string data_situacao;
        public string nome;
        public string uf;
        public string telefone;
        public string telefoneStr;
        public string faxStr;
        public List<AtividadesSecundaria> atividades_secundarias;
        public List<Qsa> qsa;
        public string situacao;
        public string bairro;
        public string logradouro;
        public string numero;
        public string endereco;
        public string cep;
        public string municipio;
        public string pais = 'BRASIL';
        public string abertura;
        public string natureza_juridica;
        public string fantasia;
        public string cnpj;
        public DateTime ultima_atualizacao;
        public string status;
        public string tipo;
        public string complemento;
        public string email;
        public string efr;
        public string motivo_situacao;
        public string situacao_especial;
        public string data_situacao_especial;
        public string capital_social;
        public string descricao_atividades;    
        public decimal lat;        
        public decimal lng;        
    }
    
    public class CNPJException extends Exception {}
    
}