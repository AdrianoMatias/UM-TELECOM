public class InvocableEnvioContaSAP {
    
    @InvocableMethod    
    public static List<Results> Executa(List<Requests> requestList){
        List<Results> listaRetorno = new List<Results>();
        String responseBodyToken, vNumUltCliente, vNumUltClienteSomado, vBodyCliente, responseBodyCliente, vCodigoCidadeCobrancaSAP, vCodigoCidadeEnvioSAP, responseStatusAcesso, responseStatusPostSubnivel;
        String responseBodyUltCliente, responseBodySubnivel, vBodySubNivel, responseStatusPostCliente, responseBodyEstoque, vBodyEstoque, vUserId, vToken, queryParameter, AccountId, bodyJsonAcesso, responseStatusPostEstoque;
        String responseBodyVerifyFornecedor, vCodigoFornecedorSAP, responseStatusGetUltCliente, vCodigoClienteSAP, responseBodyVerifyCliente, responseStatusGetVerifyCliente, responseStatusGetVerifyFornecedor;
        Integer responseCodeAcesso, responseCodeGetUltCliente, responseCodePostCliente, responseCodePostSubnivel, responseCodePostEstoque, responseCodeGetVerifyFornecedor, responseCodeGetVerifyCliente;
        Boolean vPossuiEndCobranca = false, vPossuiEndEntrega = false;
        List<Contact> listContactForUpdate = new List<Contact>();
        List<Account> listAccountForUpdate = new List<Account>();
        Results responseVariable = new Results();
        HttpRequest reqTest = new HttpRequest();
        HttpResponse resPOSTToken = new HttpResponse();
        HttpResponse resGETVerifyFornecedor = new HttpResponse();
        HttpResponse resGETVerifyCliente = new HttpResponse();
        HttpResponse resGETCliente = new HttpResponse();
        HttpResponse resPOSTCliente = new HttpResponse();
        HttpResponse resPOSTSubnivel = new HttpResponse();
        HttpResponse resPOSTEstoque = new HttpResponse();
        
        Account accUpdate = new Account();
        AccountId = requestList[0].vAccountId;
        accUpdate.Id = AccountId;
        
        Account acc = [SELECT Inscricao_Estadual__c, CNPJ__c, CNAE_Principal__c, Razao_Social__c, Nome_Fantasia__c, Phone, Telefone_2__c, Email__c, Descricao_das_Atividades__c, Grupo__c, Owner.Codigo_do_vendedor__c, BillingStreet, Bairro_de_cobranca__c, BillingPostalCode, BillingCity, BillingState, Complemento_de_cobranca__c, Tipo_de_logradouro_cobranca__c, Numero_de_cobranca__c, ShippingStreet, Bairro_de_entrega__c, ShippingPostalCode, ShippingCity, ShippingState, Complemento_de_entrega__c, Tipo_de_logradouro_entrega__c, Numero_de_entrega__c FROM Account WHERE Id =: AccountId];
        List<SAP_Integration__mdt> credential1 = [SELECT CompanyDB__c, UserName__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'SessionToken'];
        List<SAP_Integration__mdt> credential2 = [SELECT URL_Parameters__c FROM SAP_Integration__mdt WHERE DeveloperName = 'ParameterUltimoCliente'];
        List<SAP_Integration__mdt> credential3 = [SELECT URL_Parameters__c FROM SAP_Integration__mdt WHERE DeveloperName = 'ParameterVerifyFornecedor'];
        List<SAP_Integration__mdt> credential4 = [SELECT URL_Parameters__c FROM SAP_Integration__mdt WHERE DeveloperName = 'ParameterVerifyCliente'];
        
        bodyJsonAcesso = '{"CompanyDB": "'+credential1[0].CompanyDB__c+'","UserName": "'+credential1[0].UserName__c+'","Password": "'+credential1[0].Password__c+'"}';
        
        //1ª Requisição - Token
        if(Test.isRunningTest()){
            responseBodyToken = '{"SessionId":"TESTE123"}';
            HttpMock httpMock = new HttpMock(200, 'OK', responseBodyToken, new Map<String,String>());
            resPOSTToken = httpMock.respond(reqTest);
        }else{
            resPOSTToken = HttpUtils.getInstance().sendRequestAcesso('POST', 'callout:ApiAutenticacaoSAP', bodyJsonAcesso, null , 120000, null);
            System.debug('resPOSTToken ' + resPOSTToken); 
            System.debug('resPOSTToken.getStatusCode ' + resPOSTToken.getStatusCode());    
            System.debug('resPOSTToken.getbody() ' + resPOSTToken.getbody());    
        }
        
        responseBodyToken = resPOSTToken.getbody();
        responseCodeAcesso = resPOSTToken.getStatusCode();
        responseStatusAcesso = resPOSTToken.getStatus();
        
        if(responseCodeAcesso == 200){
            
            JSONParser parser = JSON.createParser(responseBodyToken);
            while(parser.nextToken()!= null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();
                    if(parser.getCurrentName() == 'SessionId'){
                        vToken = String.valueOf(parser.getText());
                        system.debug('vToken: ' + vToken);
                    }
                }
            }
            
            queryParameter = credential3[0].URL_Parameters__c.replace('CNPJParameter', acc.CNPJ__c);
            
            //Request para saber se esse CNPJ já existe no SAP como Fornecedor
            List<NamedCredential> listCredFornecedorCliente = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'ApiGetFornecedorCliente' LIMIT 1];
            
            if(Test.isRunningTest()){
                responseBodyVerifyFornecedor = '{"CardCode":"TESTE123"}';
                HttpMock httpMock = new HttpMock(200, 'OK', responseBodyVerifyFornecedor, new Map<String,String>());
                resGETVerifyFornecedor = httpMock.respond(reqTest);
            }else{
                resGETVerifyFornecedor = HttpUtils.getInstance().sendRequestGetClienteFornecedor('GET', listCredFornecedorCliente[0].Endpoint, 120000, vToken, queryParameter);
                System.debug('resGETVerifyFornecedor ' + resGETVerifyFornecedor);                                                  
                System.debug('resGETVerifyFornecedor.getStatusCode ' + resGETVerifyFornecedor.getStatusCode()); 
                System.debug('resGETVerifyFornecedor.getbody() ' + resGETVerifyFornecedor.getbody());   
            }
            
            responseBodyVerifyFornecedor = resGETVerifyFornecedor.getbody();
            responseCodeGetVerifyFornecedor = resGETVerifyFornecedor.getStatusCode();
            responseStatusGetVerifyFornecedor = resGETVerifyFornecedor.getStatus();
            
            if(responseCodeGetVerifyFornecedor == 200 && responseBodyVerifyFornecedor.contains('"CardCode"')){
                JSONParser parserFornecedor = JSON.createParser(responseBodyVerifyFornecedor);
                while(parserFornecedor.nextToken()!= null) {
                    if(parserFornecedor.getCurrentToken() == JSONToken.FIELD_NAME) {
                        parserFornecedor.nextValue();
                        if(parserFornecedor.getCurrentName() == 'CardCode'){
                            vCodigoFornecedorSAP = String.valueOf(parserFornecedor.getText());
                            system.debug('vCodigoFornecedorSAP: ' + vCodigoFornecedorSAP);
                        }
                    }
                }
                
                accUpdate.Codigo_SAP_parceiro__c = vCodigoFornecedorSAP;
            }
            
            queryParameter = credential4[0].URL_Parameters__c.replace('CNPJParameter', acc.CNPJ__c);
            
            //Request para saber se esse CNPJ já existe no SAP como Cliente
            if(Test.isRunningTest()){
                responseBodyVerifyCliente = '{"NotContains":"null"}';
                HttpMock httpMock = new HttpMock(200, 'OK', responseBodyVerifyCliente, new Map<String,String>());
                resGETVerifyCliente = httpMock.respond(reqTest);
            }else{
                resGETVerifyCliente = HttpUtils.getInstance().sendRequestGetClienteFornecedor('GET', listCredFornecedorCliente[0].Endpoint, 120000, vToken, queryParameter);
                System.debug('resGETVerifyCliente ' + resGETVerifyCliente);                                                  
                System.debug('resGETVerifyCliente.getStatusCode ' + resGETVerifyCliente.getStatusCode()); 
                System.debug('resGETVerifyCliente.getbody() ' + resGETVerifyCliente.getbody());
            }
            
            responseBodyVerifyCliente = resGETVerifyCliente.getbody();
            responseCodeGetVerifyCliente = resGETVerifyCliente.getStatusCode();
            responseStatusGetVerifyCliente = resGETVerifyCliente.getStatus();
            
            if(responseCodeGetVerifyCliente == 200){
                if(responseBodyVerifyCliente.contains('"CardCode"')){
                    JSONParser parserCliente = JSON.createParser(responseBodyVerifyCliente);
                    while(parserCliente.nextToken()!= null) {
                        if(parserCliente.getCurrentToken() == JSONToken.FIELD_NAME) {
                            parserCliente.nextValue();
                            if(parserCliente.getCurrentName() == 'CardCode'){
                                vCodigoClienteSAP = String.valueOf(parserCliente.getText());
                                system.debug('vCodigoClienteSAP: ' + vCodigoClienteSAP);
                            }
                        }
                    }
                    //Conta para Atualização
                    accUpdate.Codigo_SAP_cliente__c = vCodigoClienteSAP;
                    update accUpdate;
                    
                    //Criar Log de Sucesso - Cliente criado com Sucesso 
                    insert ControleDeServicoBO.getInstance().gerarLogPai('Sucesso', 'InvocableEnvioContaSAP', 'GET - Cliente', null, 'Cliente já existente no SAP, Código: '+vCodigoClienteSAP, responseStatusGetVerifyCliente, responseCodeGetVerifyCliente, System.Now(), False);
                    responseVariable.vSucesso = True;
                    responseVariable.vMensagemIntegracao = 'Cliente já existe no SAP com o Código: '+vCodigoClienteSAP+'!';
                    
                } else {
                    
                    //Se não existe esse Cliente no SAP, criar o Cliente
                    queryParameter = credential2[0].URL_Parameters__c;
                    
                    //2º Request: Obter último 'Código de cliente' cadastrado no SAP e somar mais 1
                    if(Test.isRunningTest()){
                        responseBodyUltCliente = '{"CardCode": 123}';
                        HttpMock httpMock = new HttpMock(200, 'OK', responseBodyUltCliente, new Map<String,String>());
                        resGETCliente = httpMock.respond(reqTest);
                    }else{
                        resGETCliente = HttpUtils.getInstance().sendRequestGetUltimoCliente('GET', listCredFornecedorCliente[0].Endpoint, 120000, vToken, queryParameter);
                        System.debug('resGETCliente ' + resGETCliente);                                                  
                        System.debug('resGETCliente.getStatusCode ' + resGETCliente.getStatusCode()); 
                        System.debug('resGETCliente.getbody() ' + resGETCliente.getbody());
                    }
                    
                    responseBodyUltCliente = resGETCliente.getbody();
                    responseCodeGetUltCliente = resGETCliente.getStatusCode();
                    responseStatusGetUltCliente = resGETCliente.getStatus();
                    
                    if(responseCodeGetUltCliente == 200){
                        
                        JSONParser parser2 = JSON.createParser(responseBodyUltCliente);
                        while(parser2.nextToken()!= null) {
                            if(parser2.getCurrentToken() == JSONToken.FIELD_NAME) {
                                parser2.nextValue();
                                if(parser2.getCurrentName() == 'CardCode'){
                                    vNumUltCliente = String.valueOf(parser2.getText());
                                    system.debug('vNumUltCliente: ' + vNumUltCliente);
                                }
                            }
                        }
                        
                        if(vNumUltCliente != null){
                            String numericPart = vNumUltCliente.substring(1);
                            Integer vNumber = Integer.valueOf(numericPart);
                            vNumber++;
                            String incrementedNumericPart = String.valueOf(vNumber).leftPad(7, '0');
                            vNumUltClienteSomado = 'C' + incrementedNumericPart;
                            system.debug('vNumUltClienteSomado: '+vNumUltClienteSomado);
                        }     
                        
                        //3º Request: Criar nova conta com contatos no SAP
                        
                        JSONGenerator genCliente = JSON.createGenerator(true);
                        genCliente.writeStartObject();
                        genCliente.writeStringField('CardCode', vNumUltClienteSomado);
                        //genCliente.writeNumberField('Series', 98); //Produção
                        genCliente.writeNumberField('Series', 97); //Sandbox
                        
                        
                        if(acc.Razao_Social__c != null){
                            genCliente.writeStringField('CardName', acc.Razao_Social__c.abbreviate(80));
                        } else {
                            genCliente.writeStringField('CardName', '');
                        }
                        
                        if(acc.Nome_Fantasia__c != null){
                            genCliente.writeStringField('CardForeignName', acc.Nome_Fantasia__c.abbreviate(100));
                        } else {
                            genCliente.writeStringField('CardForeignName', '');
                        }
                        
                        if(acc.CNPJ__c != null){
                            genCliente.writeStringField('Password', acc.CNPJ__c);
                        } else {
                            genCliente.writeStringField('Password', '');
                        }
                        
                        genCliente.writeStringField('CardType', 'C');
                        
                        if(acc.Phone != null){
                            genCliente.writeStringField('Phone1', acc.Phone.abbreviate(20)); 
                        } else {
                            genCliente.writeStringField('Phone1', ''); 
                        }
                        
                        if(acc.Telefone_2__c != null){
                            genCliente.writeStringField('Phone2', acc.Telefone_2__c.abbreviate(20)); 
                        } else {
                            genCliente.writeStringField('Phone2', ''); 
                        }
                        
                        if(acc.Email__c != null){
                            genCliente.writeStringField('EmailAddress', acc.Email__c.abbreviate(100)); 
                        } else {
                            genCliente.writeStringField('EmailAddress', '');
                        }
                        
                        genCliente.writeStringField('FreeText', 'C');
                        genCliente.writeStringField('U_UM_IdSalesforce', AccountId);
                        
                        if(acc.Grupo__c != null){
                            genCliente.writeStringField('GroupCode', acc.Grupo__c); 
                        } else {
                            genCliente.writeStringField('GroupCode', '');
                        }
                        
                        if(acc.Owner.Codigo_do_vendedor__c != null){
                            genCliente.writeNumberField('SalesPersonCode', Decimal.valueOf(acc.Owner.Codigo_do_vendedor__c));
                        } else {
                            genCliente.writeNumberField('SalesPersonCode', -1);
                        }
                        
                        genCliente.writeStringField('CardType', 'C');
                        
                        //Adição dos Contatos    
                        genCliente.writeFieldName('ContactEmployees');
                        genCliente.writeStartArray();                
                        
                        List<Contact> lstContact = [SELECT Id, Name, FirstName, LastName, Phone, Telefone_2__c, MobilePhone, Email, Department, Title, Birthdate FROM Contact WHERE AccountId =: AccountId];    
                        
                        if(lstContact.size() > 0){
                            for(Contact ctt : lstContact){
                                genCliente.writeStartObject();
                                genCliente.writeStringField('CardCode', vNumUltClienteSomado); 
                                
                                if(ctt.Name.length() > 50){
                                    genCliente.writeStringField('Name', ctt.Name.abbreviate(50));
                                } else {
                                    genCliente.writeStringField('Name', ctt.Name);
                                }
                                
                                if(ctt.Phone != null){
                                    genCliente.writeStringField('Phone1', ctt.Phone.abbreviate(20));
                                } else {
                                    genCliente.writeStringField('Phone1', '');
                                }
                                
                                if(ctt.Telefone_2__c != null){
                                    genCliente.writeStringField('Phone2', ctt.Telefone_2__c.abbreviate(20));
                                } else {
                                    genCliente.writeStringField('Phone2', '');
                                }
                                
                                if(ctt.MobilePhone != null){
                                    genCliente.writeStringField('MobilePhone', ctt.MobilePhone.abbreviate(20)); 
                                } else {
                                    genCliente.writeStringField('MobilePhone', ''); 
                                }
                                
                                if(ctt.Email != null){
                                    genCliente.writeStringField('E_Mail', ctt.Email.abbreviate(100)); 
                                } else {
                                    genCliente.writeStringField('E_Mail', ''); 
                                }
                                
                                genCliente.writeStringField('Active', 'Y');
                                
                                if(ctt.FirstName != null){
                                    genCliente.writeStringField('FirstName', ctt.FirstName.abbreviate(50));
                                } else {
                                    genCliente.writeStringField('FirstName', ''); 
                                }
                                
                                genCliente.writeStringField('LastName', ctt.LastName.abbreviate(50)); 
                                genCliente.writeStringField('EmailGroupCode', '2');
                                
                                if(ctt.Department != null){
                                    genCliente.writeStringField('Title', ctt.Department.abbreviate(10));
                                } else {
                                    genCliente.writeStringField('Title', ''); 
                                }
                                
                                if(ctt.title != null){
                                    genCliente.writeStringField('Position', ctt.title.abbreviate(90));
                                } else {
                                    genCliente.writeStringField('Position', ''); 
                                }
                                
                                if(ctt.Birthdate != null){
                                    genCliente.writeStringField('DateOfBirth', String.valueOf(ctt.Birthdate));
                                } else {
                                    genCliente.writeStringField('DateOfBirth', '');
                                }
                                
                                genCliente.writeEndObject();
                            }
                        }
                        genCliente.writeEndArray();
                        
                        genCliente.writeFieldName('BPAddresses');
                        genCliente.writeStartArray(); 
                        
                        if(acc.BillingStreet != null){
                            
                            vPossuiEndCobranca = True;
                            
                            if(acc.BillingCity != null){
                                vCodigoCidadeCobrancaSAP = [SELECT ChaveSAP__c FROM Municipio_IBGE__c WHERE Name =: acc.BillingCity AND Sigla_UF__c =: acc.BillingState].ChaveSAP__c;
                            } else {
                                vCodigoCidadeCobrancaSAP = '';
                            }
                            
                            genCliente.writeStartObject();
                            genCliente.writeStringField('BPCode', vNumUltClienteSomado);
                            genCliente.writeNumberField('RowNum', 0);
                            genCliente.writeStringField('AddressName', 'COBRANÇA');
                            genCliente.writeStringField('Street', acc.BillingStreet.abbreviate(50));
                            
                            if(acc.Bairro_de_cobranca__c != null){
                                genCliente.writeStringField('Block', acc.Bairro_de_cobranca__c.abbreviate(50));
                            } else {
                                genCliente.writeStringField('Block', ''); 
                            }
                            
                            if(acc.BillingPostalCode != null){
                                genCliente.writeStringField('ZipCode', acc.BillingPostalCode.abbreviate(20));
                            } else {
                                genCliente.writeStringField('ZipCode', ''); 
                            }
                            
                            if(acc.BillingCity != null){
                                genCliente.writeStringField('City', acc.BillingCity.abbreviate(50));
                            } else {
                                genCliente.writeStringField('City', ''); 
                            }
                            
                            if(acc.BillingState != null){
                                genCliente.writeStringField('State', acc.BillingState);
                            } else {
                                genCliente.writeStringField('State', ''); 
                            }
                            
                            if(vCodigoCidadeCobrancaSAP != ''){
                                genCliente.writeStringField('County', vCodigoCidadeCobrancaSAP);
                            } else {
                                genCliente.writeStringField('County', ''); 
                            }
                            
                            genCliente.writeStringField('Country', 'BR');
                            
                            if(acc.Complemento_de_cobranca__c != null){
                                genCliente.writeStringField('BuildingFloorRoom', acc.Complemento_de_cobranca__c.abbreviate(50));
                            } else {
                                genCliente.writeStringField('BuildingFloorRoom', ''); 
                            }
                            
                            genCliente.writeStringField('AddressType', 'B');
                            
                            if(acc.Tipo_de_logradouro_cobranca__c != null){
                                genCliente.writeStringField('TypeOfAddress', acc.Tipo_de_logradouro_cobranca__c);
                            } else {
                                genCliente.writeStringField('TypeOfAddress', ''); 
                            }
                            
                            if(acc.Numero_de_cobranca__c != null){
                                genCliente.writeStringField('StreetNo', acc.Numero_de_cobranca__c.abbreviate(20));
                            } else {
                                genCliente.writeStringField('StreetNo', ''); 
                            }
                            genCliente.writeEndObject();
                        }
                        
                        if(acc.ShippingStreet != null){
                            
                            vPossuiEndEntrega = True;
                            
                            if(acc.ShippingCity != null){
                                vCodigoCidadeEnvioSAP = [SELECT ChaveSAP__c FROM Municipio_IBGE__c WHERE Name =: acc.ShippingCity AND Sigla_UF__c =: acc.ShippingState].ChaveSAP__c;
                            } else {
                                vCodigoCidadeEnvioSAP = '';
                            }
                            
                            genCliente.writeStartObject();
                            genCliente.writeStringField('BPCode', vNumUltClienteSomado);
                            genCliente.writeNumberField('RowNum', 1);
                            genCliente.writeStringField('AddressName', 'ENVIO');
                            genCliente.writeStringField('Street', acc.ShippingStreet.abbreviate(50));
                            
                            if(acc.Bairro_de_entrega__c != null){
                                genCliente.writeStringField('Block', acc.Bairro_de_entrega__c.abbreviate(50));
                            } else {
                                genCliente.writeStringField('Block', ''); 
                            }
                            
                            if(acc.ShippingPostalCode != null){
                                genCliente.writeStringField('ZipCode', acc.ShippingPostalCode.abbreviate(20));
                            } else {
                                genCliente.writeStringField('ZipCode', ''); 
                            }
                            
                            if(acc.ShippingCity != null){
                                genCliente.writeStringField('City', acc.ShippingCity.abbreviate(50));
                            } else {
                                genCliente.writeStringField('City', ''); 
                            }
                            
                            if(acc.ShippingState != null){
                                genCliente.writeStringField('State', acc.ShippingState);
                            } else {
                                genCliente.writeStringField('State', ''); 
                            }
                            
                            if(vCodigoCidadeEnvioSAP != ''){
                                genCliente.writeStringField('County', vCodigoCidadeEnvioSAP);
                            } else {
                                genCliente.writeStringField('County', ''); 
                            }
                            
                            genCliente.writeStringField('Country', 'BR');
                            
                            if(acc.Complemento_de_entrega__c != null){
                                genCliente.writeStringField('BuildingFloorRoom', acc.Complemento_de_entrega__c.abbreviate(60));
                            } else {
                                genCliente.writeStringField('BuildingFloorRoom', ''); 
                            }
                            
                            genCliente.writeStringField('AddressType', 'S');
                            
                            if(acc.Tipo_de_logradouro_entrega__c != null){
                                genCliente.writeStringField('TypeOfAddress', acc.Tipo_de_logradouro_entrega__c);
                            } else {
                                genCliente.writeStringField('TypeOfAddress', ''); 
                            }
                            
                            if(acc.Numero_de_entrega__c != null){
                                genCliente.writeStringField('StreetNo', acc.Numero_de_entrega__c.abbreviate(20));
                            } else {
                                genCliente.writeStringField('StreetNo', ''); 
                            }
                            
                            genCliente.writeEndObject();
                        }
                        genCliente.writeEndArray();
                        
                        genCliente.writeFieldName('BPFiscalTaxIDCollection');
                        genCliente.writeStartArray(); 
                        
                        if(acc.BillingStreet != null){
                            genCliente.writeStartObject();
                            genCliente.writeStringField('BPCode', vNumUltClienteSomado);
                            genCliente.writeStringField('Address', 'COBRANÇA');
                            
                            if(acc.CNPJ__c != null){
                                genCliente.writeStringField('TaxId0', acc.CNPJ__c);
                            } else {
                                genCliente.writeStringField('TaxId0', '');
                            }
                            
                            genCliente.writeNumberField('CNAECode', -1);
                            genCliente.writeStringField('AddrType', 'B');
                            genCliente.writeEndObject();
                        }
                        
                        if(acc.ShippingStreet != null){
                            genCliente.writeStartObject();
                            genCliente.writeStringField('BPCode', vNumUltClienteSomado);
                            genCliente.writeStringField('Address', 'ENVIO');
                            genCliente.writeNumberField('CNAECode', -1);
                            
                            /*if(acc.CNAE_Principal__c != null){
genCliente.writeNumberField('CNAECode', Decimal.valueOf(acc.CNAE_Principal__c));
} else {
genCliente.writeNumberField('CNAECode', -1);
}*/
                            
                            if(acc.CNPJ__c != null){
                                genCliente.writeStringField('TaxId0', acc.CNPJ__c);
                            } else {
                                genCliente.writeStringField('TaxId0', '');
                            }
                            
                            if(acc.Inscricao_Estadual__c != null){
                                genCliente.writeStringField('TaxId1', acc.Inscricao_Estadual__c); 
                            } else {
                                genCliente.writeStringField('TaxId1', 'ISENTO'); 
                            }
                            
                            genCliente.writeStringField('AddrType', 'S');
                            genCliente.writeStringField('TaxId12', vNumUltClienteSomado + '/ENVIO');
                            
                            genCliente.writeEndObject();
                        }
                        genCliente.writeEndArray();
                        genCliente.writeEndObject();
                        
                        vBodyCliente = genCliente.getAsString();
                        
                        if(Test.isRunningTest()){
                            responseBodyCliente = '{"ContactEmployees":[{"Name": "Test Name", "InternalCode": 123654}]}';
                            HttpMock httpMock = new HttpMock(201, 'OK', responseBodyCliente, new Map<String,String>());
                            resPOSTCliente = httpMock.respond(reqTest);
                        }else{
                            resPOSTCliente = HttpUtils.getInstance().sendRequestPOSTCliente('POST', 'callout:ApiPOSTClienteSAP', 120000, vBodyCliente, vToken);
                            System.debug('resPOSTCliente ' + resPOSTCliente);
                            System.debug('resPOSTCliente.getStatusCode ' + resPOSTCliente.getStatusCode()); 
                            System.debug('resPOSTCliente.getbody() ' + resPOSTCliente.getbody()); 
                        }
                        
                        responseBodyCliente = resPOSTCliente.getbody();
                        responseCodePostCliente = resPOSTCliente.getStatusCode();
                        responseStatusPostCliente = resPOSTCliente.getStatus();
                        
                        if(responseCodePostCliente == 201){
                            
                            Map<String, Object> jsonNewClient = (Map<String, Object>) JSON.deserializeUntyped(responseBodyCliente);
                            List<Object> contactsData = (List<Object>) jsonNewClient.get('ContactEmployees');
                            
                            for (Object contactData : contactsData) {
                                Map<String, Object> contactMap = (Map<String, Object>) contactData;
                                String contactName = (String) contactMap.get('Name');
                                Integer sapCode = (Integer) contactMap.get('InternalCode');
                                
                                List<Contact> contactsToUpdate = [SELECT Id, Name, Codigo_SAP_contato__c FROM Contact WHERE Name = :contactName AND AccountId = :AccountId LIMIT 1];
                                
                                if (!contactsToUpdate.isEmpty()) {
                                    Contact contact = contactsToUpdate[0];
                                    contact.Codigo_SAP_contato__c = String.valueOf(sapCode);
                                    listContactForUpdate.add(contact);         
                                } else {
                                    System.debug('Contato não encontrado com o nome: ' + contactName);
                                }
                            }
                            
                            //4ª Request: Criar subnível para a conta:
                            
                            vBodySubNivel = '{"Code": "'+vNumUltClienteSomado+'", "Description": "'+acc.Razao_Social__c.abbreviate(50)+'", "WarehouseSublevel": 2 }';
                            
                            if(Test.isRunningTest()){
                                responseBodySubnivel = '{"Test":"testSubnivel"}';
                                HttpMock httpMock = new HttpMock(201, 'OK', responseBodySubnivel, new Map<String,String>());
                                resPOSTSubnivel = httpMock.respond(reqTest);
                            }else{
                                resPOSTSubnivel = HttpUtils.getInstance().sendRequestPOSTSubnivel('POST', 'callout:ApiSublevelSAP', 120000, vBodySubNivel, vToken);
                                System.debug('resPOSTSubnivel ' + resPOSTSubnivel); 
                                System.debug('resPOSTSubnivel.getStatusCode ' + resPOSTSubnivel.getStatusCode()); 
                                System.debug('resPOSTSubnivel.getbody() ' + resPOSTSubnivel.getbody()); 
                            }
                            
                            responseBodySubnivel = resPOSTSubnivel.getbody();
                            responseCodePostSubnivel = resPOSTSubnivel.getStatusCode();
                            responseStatusPostSubnivel = resPOSTSubnivel.getStatus();
                            
                            if(responseCodePostSubnivel == 201){
                                
                                //5º Request: Criar as posições de estoque para o Estoque de PE
                                vBodyEstoque = '{"BinCode": "EST.PE-'+vNumUltClienteSomado+'", "Description": "'+acc.Razao_Social__c.abbreviate(50)+'", "Inactive": "tNO", "Sublevel2": "'+vNumUltClienteSomado+'", "Warehouse": "EST.PE"}';
                                
                                if(Test.isRunningTest()){
                                    responseBodyEstoque = '{"Test":"testEstoque"}';
                                    HttpMock httpMock = new HttpMock(201, 'OK', responseBodyEstoque, new Map<String,String>());
                                    resPOSTEstoque = httpMock.respond(reqTest);
                                }else{
                                    resPOSTEstoque = HttpUtils.getInstance().sendRequestPOSTEstoque('POST', 'callout:ApiBinLocationsSAP', 120000, vBodyEstoque, vToken);
                                    System.debug('resPOSTEstoque ' + resPOSTEstoque); 
                                    System.debug('resPOSTEstoque.getStatusCode ' + resPOSTEstoque.getStatusCode()); 
                                    System.debug('resPOSTEstoque.getbody() ' + resPOSTEstoque.getbody()); 
                                }
                                
                                responseBodyEstoque = resPOSTEstoque.getbody();
                                responseCodePostEstoque = resPOSTEstoque.getStatusCode();
                                responseStatusPostEstoque = resPOSTEstoque.getStatus();
                                
                                if(responseCodePostEstoque == 201){
                                    
                                    If(listContactForUpdate.size()>0){
                                        update listContactForUpdate;
                                    }
                                    
                                    //Conta para Atualização
                                    accUpdate.Codigo_SAP_cliente__c = vNumUltClienteSomado;
                                    if(vPossuiEndCobranca == True)
                                        accUpdate.Codigo_SAP_cobranca__c = 'COBRANÇA';
                                    if(vPossuiEndEntrega == True)
                                        accUpdate.Codigo_SAP_envio__c = 'ENVIO';
                                    update accUpdate;
                                    
                                    //Criar Log de Sucesso - Cliente criado com Sucesso 
                                    insert ControleDeServicoBO.getInstance().gerarLogPai('Sucesso', 'InvocableEnvioContaSAP', 'POST - Cliente', vBodyCliente, responseBodyCliente, responseStatusPostCliente, responseCodePostCliente, System.Now(), False);
                                    responseVariable.vSucesso = True;
                                } else {
                                    //Criar Log de erro de POST - Estoque
                                    insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableEnvioContaSAP', 'POST - Posição de Estoque', vBodyEstoque, responseBodyEstoque, responseStatusPostEstoque, responseCodePostEstoque, System.Now(), False);
                                    responseVariable.vSucesso = false;
                                }
                                
                            } else {
                                //Criar Log de erro de POST - Subnivel
                                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableEnvioContaSAP', 'POST - Subnivel de Estoque', vBodySubNivel, responseBodySubNivel, responseStatusPostSubnivel, responseCodePostSubNivel, System.Now(), False);
                                responseVariable.vSucesso = false;
                            }
                            
                        } else {
                            //Criar Log de erro de POST - Cliente
                            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableEnvioContaSAP', 'POST - Cliente', vBodyCliente, responseBodyCliente, responseStatusPostCliente, responseCodePostCliente, System.Now(), False);
                            responseVariable.vSucesso = false;
                        }                
                        
                    } else {
                        //Criar Log de erro de GET - Ultimo Cliente
                        insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableEnvioContaSAP', 'GET - Ultimo Cliente SAP', null, responseBodyUltCliente, responseStatusGetUltCliente, responseCodeGetUltCliente, System.Now(), False);
                        responseVariable.vSucesso = false;
                    }
                }
                
            } else {
                //Criar Log de erro de GET - Cliente Existente
                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableEnvioContaSAP', 'GET - Cliente', null, null, responseStatusGetVerifyCliente, responseCodeGetVerifyCliente, System.Now(), False);
                responseVariable.vSucesso = false;
            }
            
        } else {
            //Criar Log de erro de POST - Token
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'InvocableEnvioContaSAP', 'POST - Token', bodyJsonAcesso, responseBodyToken, responseStatusAcesso, responseCodeAcesso, System.Now(), False);
            responseVariable.vSucesso = false;
        }
        
        listaRetorno.add(responseVariable);
        return listaRetorno;
    }
    
    public class Requests {
        @InvocableVariable(label='AccountId' required=true)
        public String vAccountId;
    }
    
    public class Results {
        @InvocableVariable(label='Integração Sucesso' required=true)
        public Boolean vSucesso;
        
        @InvocableVariable(label='Mensagem Integração')
        public String vMensagemIntegracao;
    }
}