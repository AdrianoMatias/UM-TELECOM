global class BatchEnviaContratoAoSAP implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{
    
    public List<String> listQuery;
    
    public BatchEnviaContratoAoSAP(List<String> queryString1) {
        this.listQuery = queryString1;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String vIdContract = listQuery[0];
        
        String queryString = 'Select Id, Quantidade__c, Concentrador__c, TaxaInstalacao__c, FormaPagamentoInstalacao__c, Numero_do_circuito__c, Banda__c, Analise_de_Viabilidade__r.Name, IDCartaoDoEquipamentoSAP__c, NumeroItemContrato__c, Contrato__r.Cortesia__c, Contrato__r.ContractTerm, Contrato__r.Permuta__c, Contrato__r.ContractNumber, Contrato__r.DiaVencimento__c, Contrato__r.StartDate, Contrato__r.EndDate, Contrato__r.EnviadoSAP__c, Contrato__r.Codigo_do_contrato__c, Contrato__c, Produto__r.ProductCode, Conta__r.Codigo_SAP_cliente__c, Valor__c, Tipo_de_logradouro_de_origem__c, Rua_de_origem__c, Numero_de_origem__c, Complemento_de_origem__c, Cep_de_origem__c, Cidade_de_origem__c, Bairro_de_origem__c, Estado_de_origem__c, Tipo_de_logradouro_de_destino__c, Rua_de_destino__c, Numero_de_destino__c, Complemento_de_destino__c, Cep_de_destino__c, Cidade_de_destino__c, Bairro_de_destino__c, Estado_de_destino__c, Ponto_de_referencia_do_destino__c FROM Item_do_Contrato__c WHERE Numero_do_circuito__c = null AND Contrato__c =\''+vIdContract+'\' ORDER BY NumeroItemContrato__c ASC';
        
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext BC, List<Item_do_Contrato__c> scope) {
        HttpRequest reqTest = new HttpRequest();
        HttpResponse resAcesso = new HttpResponse();
        HttpResponse resCartaoEquip1 = new HttpResponse();
        HttpResponse resCartaoEquip2 = new HttpResponse();
        HttpResponse resCreateContract = new HttpResponse();
        HttpResponse resUpdateItem1 = new HttpResponse();
        HttpResponse resCreateItem = new HttpResponse();
        HttpResponse resTaxa = new HttpResponse();
        String responseBodyAcesso, responseStatusAcesso, vToken, queryParameter, vNumContrato = null, vFormaPagamentoTaxa;
        Integer responseCodeAcesso;
        
        try{
            
            for(Item_do_Contrato__c idc : scope) {
                
                String vRuaOrigem = null, vCodigoCidadeOrigemSAP = null, vNumeroOrigem = null, vComplementoOrigem = null, vCEPOrigem = null, vCidadeOrigem = null, vBairroOrigem = null, vEstadoOrigem = null;
                String vTipoLogrDestino = null, vCodigoCidadeDestinoSAP = null, vRuaDestino = null, vNumeroDestino = null, vComplementoDestino = null, vCEPDestino = null, vCidadeDestino = null, vBairroDestino = null, vEstadoDestino = null, vPontoRefDestino = null;
                Integer vPrazoVigencia, vQuantidadeProduto;
                String vPermuta, vCortesia, vBanda, vStatusTaxa;
                String vToday = String.valueOf(Date.today());
                
                //Endereço Origem - Cartão de Equipamento
                if(idc.Rua_de_origem__c != null && idc.Tipo_de_logradouro_de_origem__c != null){
                    vRuaOrigem = idc.Tipo_de_logradouro_de_origem__c+' '+idc.Rua_de_origem__c;
                } else if(idc.Rua_de_origem__c != null && idc.Tipo_de_logradouro_de_origem__c == null){
                    vRuaOrigem = idc.Rua_de_origem__c;
                } else {
                    vRuaOrigem = '';
                }
                
                if(idc.Numero_de_origem__c !=null){
                    vNumeroOrigem = idc.Numero_de_origem__c;
                } else {
                    vNumeroOrigem = '';
                }
                
                if(idc.Complemento_de_origem__c !=null){
                    vComplementoOrigem = idc.Complemento_de_origem__c;
                } else {
                    vComplementoOrigem = '';
                }
                
                if(idc.Cep_de_origem__c !=null){
                    vCEPOrigem = idc.Cep_de_origem__c;
                } else {
                    vCEPOrigem = '';
                }
                
                if(idc.Cidade_de_origem__c !=null){
                    vCidadeOrigem = idc.Cidade_de_origem__c;
                } else {
                    vCidadeOrigem = '';
                }
                
                if(idc.Bairro_de_origem__c !=null){
                    vBairroOrigem = idc.Bairro_de_origem__c;
                } else {
                    vBairroOrigem = '';
                }
                
                if(idc.Estado_de_origem__c !=null){
                    vEstadoOrigem = idc.Estado_de_origem__c;
                } else {
                    vEstadoOrigem = '';
                }
                
                //Endereço Destino - Cartão de Equipamento
                if(idc.Tipo_de_logradouro_de_destino__c !=null){
                    vTipoLogrDestino = idc.Tipo_de_logradouro_de_destino__c;
                } else {
                    vTipoLogrDestino = '';
                }
                
                if(idc.Rua_de_destino__c !=null){
                    vRuaDestino = idc.Rua_de_destino__c;
                } else {
                    vRuaDestino = '';
                }
                
                if(idc.Numero_de_destino__c !=null){
                    vNumeroDestino = idc.Numero_de_destino__c;
                } else {
                    vNumeroDestino = '';
                }
                
                if(idc.Complemento_de_destino__c != null){
                    vComplementoDestino = idc.Complemento_de_destino__c;
                } else {
                    vComplementoDestino = '';
                }
                
                if(idc.Cep_de_destino__c != null){
                    vCEPDestino = idc.Cep_de_destino__c;
                } else {
                    vCEPDestino = '';
                }
                
                if(idc.Cidade_de_destino__c != null){
                    vCidadeDestino = idc.Cidade_de_destino__c;
                } else {
                    vCidadeDestino = '';
                }
                
                if(idc.Bairro_de_destino__c != null){
                    vBairroDestino = idc.Bairro_de_destino__c;
                } else {
                    vBairroDestino = '';
                }
                
                if(idc.Estado_de_destino__c != null){
                    vEstadoDestino = idc.Estado_de_destino__c;
                } else {
                    vEstadoDestino = '';
                }
                
                if(idc.Ponto_de_referencia_do_destino__c != null){
                    vPontoRefDestino = idc.Ponto_de_referencia_do_destino__c;
                } else {
                    vPontoRefDestino = '';
                }
                
                Datetime agora = Datetime.now();
                String ano = String.valueOf(agora.year());
                String mes = String.valueOf(agora.month()).leftPad(2, '0');
                String dia = String.valueOf(agora.day()).leftPad(2, '0');
                String horas = String.valueOf(agora.hour()).leftPad(2, '0');
                String minutos = String.valueOf(agora.minute()).leftPad(2, '0');
                String segundos = String.valueOf(agora.second()).leftPad(2, '0');
                
                String SerialNumConcatenado = ano + mes + dia + horas + minutos + segundos;
                System.debug('ManufacturerSerialNum: '+SerialNumConcatenado);
                
                List<SAP_Integration__mdt> credential1 = [SELECT CompanyDB__c, UserName__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'SessionToken'];
                
                String bodyJsonAcesso = '{"CompanyDB": "'+credential1[0].CompanyDB__c+'","UserName": "'+credential1[0].UserName__c+'","Password": "'+credential1[0].Password__c+'"}';
                
                //1ª Requisição: Solicitar Acesso
                
                if(Test.isRunningTest()){
                    responseBodyAcesso = '{"SessionId":"TESTE123"}';
                    HttpMock httpMock = new HttpMock(200, 'OK', responseBodyAcesso, new Map<String,String>());
                    resAcesso = httpMock.respond(reqTest);
                }else{
                    resAcesso = HttpUtils.getInstance().sendRequestAcesso('POST', 'callout:ApiAutenticacaoSAP', bodyJsonAcesso, null , 120000, null);
                    System.debug('resAcesso.getStatusCode ' + resAcesso.getStatusCode());    
                    System.debug('resAcesso.getbody() ' + resAcesso.getbody());    
                }
                responseBodyAcesso = resAcesso.getbody();
                responseCodeAcesso = resAcesso.getStatusCode();
                responseStatusAcesso = resAcesso.getStatus();
                
                if(responseCodeAcesso == 200){
                    
                    JSONParser parser = JSON.createParser(responseBodyAcesso);
                    while(parser.nextToken()!= null) {
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                            parser.nextValue();
                            if(parser.getCurrentName() == 'SessionId'){
                                vToken = String.valueOf(parser.getText());
                                system.debug('vToken: ' + vToken);
                            }
                        }
                    }
                    
                    if(idc.NumeroItemContrato__c == 1 && idc.Contrato__r.EnviadoSAP__c == False){
                        
                        String responseBodyCartaoEquip1, responseStatusCartaoEquip1, vBodyJSONCartaoEquip1, vConcentrador, vNumeroItemContrato;
                        Integer responseCodeCartaoEquip1;
                        
                        if(idc.Cidade_de_origem__c != null){
                            vCodigoCidadeOrigemSAP = [SELECT ChaveSAP__c FROM Municipio_IBGE__c WHERE Name =: idc.Cidade_de_origem__c AND Sigla_UF__c =: idc.Estado_de_origem__c].ChaveSAP__c;
                        } else {
                            vCodigoCidadeOrigemSAP = '';
                        }
                        
                        if(idc.Cidade_de_destino__c != null){
                            vCodigoCidadeDestinoSAP = [SELECT ChaveSAP__c FROM Municipio_IBGE__c WHERE Name =: idc.Cidade_de_destino__c AND Sigla_UF__c =: idc.Estado_de_destino__c].ChaveSAP__c;
                        } else {
                            vCodigoCidadeDestinoSAP = '';
                        }
                        
                        if(idc.Concentrador__c == False){
                            vConcentrador = 'Não';
                        } else {
                            vConcentrador = 'Sim';
                        }
                        
                        JSONGenerator genEquip = JSON.createGenerator(true);
                        genEquip.writeStartObject();
                        genEquip.writeStringField('CustomerCode',idc.Conta__r.Codigo_SAP_cliente__c); 
                        genEquip.writeStringField('ItemCode', idc.Produto__r.ProductCode);
                        genEquip.writeStringField('ManufacturerSerialNum',SerialNumConcatenado);
                        genEquip.writeStringField('U_TI_CONCENT', vConcentrador);
                        
                        genEquip.writeStringField('Street', vRuaOrigem.abbreviate(50));
                        genEquip.writeStringField('StreetNo', vNumeroOrigem.abbreviate(20));
                        genEquip.writeStringField('BuildingFloorRoom', vComplementoOrigem.abbreviate(60));
                        genEquip.writeStringField('ZipCode', vCEPOrigem.abbreviate(20));
                        genEquip.writeStringField('City', vCidadeOrigem.abbreviate(50));
                        genEquip.writeStringField('Block', vBairroOrigem.abbreviate(50));
                        genEquip.writeStringField('StateCode', vEstadoOrigem);
                        genEquip.writeStringField('County', vCodigoCidadeOrigemSAP);
                        genEquip.writeStringField('CountryCode', 'BR');
                        
                        genEquip.writeStringField('U_AddrType', vTipoLogrDestino);
                        genEquip.writeStringField('U_Street', vRuaDestino.abbreviate(50));
                        genEquip.writeStringField('U_StreetNo', vNumeroDestino.abbreviate(20));
                        genEquip.writeStringField('U_Building', vComplementoDestino.abbreviate(60));
                        genEquip.writeStringField('U_ZipCode', vCEPDestino.abbreviate(20));
                        genEquip.writeStringField('U_City', vCidadeDestino.abbreviate(50));
                        genEquip.writeStringField('U_Block', vBairroDestino.abbreviate(50));
                        genEquip.writeStringField('U_State', vEstadoDestino);
                        genEquip.writeStringField('U_County', vCodigoCidadeDestinoSAP);
                        genEquip.writeStringField('U_PontoReferencia', vPontoRefDestino.abbreviate(20));
                        genEquip.writeEndObject();
                        
                        vBodyJSONCartaoEquip1 = genEquip.getAsString();                    
                        
                        //Requisição Criar Cartão de Equipamento do Item 1
                        if(Test.isRunningTest()){
                            responseBodyCartaoEquip1 = '{"Equipamentcard":"TESTE123"}';
                            HttpMock httpMock = new HttpMock(201, 'OK', responseBodyCartaoEquip1, new Map<String,String>());
                            resCartaoEquip1 = httpMock.respond(reqTest);
                        }else{
                            resCartaoEquip1 = HttpUtils.getInstance().sendRequestPOSTCartaoEquipamento('POST', 'callout:ApiCartaoEquipamentoSAP', 120000, vBodyJSONCartaoEquip1, vToken);
                            System.debug('resCartaoEquip1 ' + resCartaoEquip1); 
                            System.debug('resCartaoEquip1.getStatusCode ' + resCartaoEquip1.getStatusCode());    
                            System.debug('resCartaoEquip1.getbody() ' + resCartaoEquip1.getbody());  
                        }
                        
                        responseBodyCartaoEquip1 = resCartaoEquip1.getbody();
                        responseCodeCartaoEquip1 = resCartaoEquip1.getStatusCode();
                        responseStatusCartaoEquip1 = resCartaoEquip1.getStatus();
                        
                        if(responseCodeCartaoEquip1 == 201){
                            
                            //Pausa de 3 segundos
                            Datetime startTime = Datetime.now(), endTime;
                            
                            do {
                                endTime = Datetime.now();
                            } while (endTime.getTime() - startTime.getTime() < 3000);
                           
                            String responseBodyContract, responseStatusContract, vBodyContract;
                            Integer responseCodePostContract, numInt, vDiaVenc;
                            
                            vDiaVenc = Integer.valueOf(idc.Contrato__r.DiaVencimento__c);
                            
                            if(idc.Contrato__r.ContractTerm != null){
                                vPrazoVigencia = idc.Contrato__r.ContractTerm;
                            } else {
                                vPrazoVigencia = 0;
                            }
                            
                            if(idc.Contrato__r.Permuta__c == False){
                                vPermuta = 'N';
                            } else {
                                vPermuta = 'S';
                            }
                            
                            if(idc.Contrato__r.Cortesia__c == False){
                                vCortesia = 'N';
                            } else {
                                vCortesia = 'S';
                            }
                            
                            if(idc.Quantidade__c != null){
                                vQuantidadeProduto = Integer.valueOf(idc.Quantidade__c);
                            } else {
                                vQuantidadeProduto = 1;
                            }
                            
                            if(idc.Banda__c != null && idc.Banda__c != 0){
                                Decimal vBandaInt = idc.Banda__c*1024;
                                vBanda = String.valueOf(vBandaInt);
                            } else {
                                vBanda = '';
                            }
                            
                            vBodyContract = '{"CustomerCode": "'+idc.Conta__r.Codigo_SAP_cliente__c+'","StartDate": "'+idc.Contrato__r.StartDate+'","EndDate": "'+idc.Contrato__r.EndDate+'","Remarks": "Número do Contrato Salesforce: '+idc.Contrato__r.ContractNumber+'","U_BIT_Dia_Fat": '+vDiaVenc+', "Status": "A", "U_Permuta": "'+vPermuta+'", "U_Vigencia": '+vPrazoVigencia+', "U_Cortesia": "'+vCortesia+'", "ServiceContract_Lines": [{"LineNum": '+idc.NumeroItemContrato__c+',"U_FLX_Status":"A", "ItemCode": "'+idc.Produto__r.ProductCode+'","ManufacturerSerialNum": "'+SerialNumConcatenado+'", "U_SalesItem": "'+idc.Analise_de_Viabilidade__r.Name+'", "U_BIT_Valor_Unit": "'+idc.Valor__c+'", "U_Quantidade": '+vQuantidadeProduto+',"U_FLX_Banda":"'+vBanda+'", "U_ControleAlt": "SI"}]}';
                            system.debug('vBodyContract: '+vBodyContract);
                            
                            //Requisição Criação do Contrato no SAP
                            if(Test.isRunningTest()){
                                responseBodyContract = '{"ContractID":"TESTE123"}';
                                HttpMock httpMock = new HttpMock(201, 'OK', responseBodyContract, new Map<String,String>());
                                resCreateContract = httpMock.respond(reqTest);
                            }else{
                                resCreateContract = HttpUtils.getInstance().sendRequestPOSTContrato('POST', 'callout:ApiContratoSAP', 120000, vBodyContract, vToken);
                                System.debug('resCreateContract ' + resCreateContract); 
                                System.debug('resCreateContract.getStatusCode ' + resCreateContract.getStatusCode()); 
                                System.debug('resCreateContract.getbody() ' + resCreateContract.getbody());    
                            }
                            responseBodyContract = resCreateContract.getbody();
                            responseCodePostContract = resCreateContract.getStatusCode();
                            responseStatusContract = resCreateContract.getStatus();
                            
                            if(responseCodePostContract == 201){
                                
                                JSONParser parser2 = JSON.createParser(responseBodyContract);
                                while(parser2.nextToken()!= null && vNumContrato == null) {
                                    if(parser2.getCurrentToken() == JSONToken.FIELD_NAME) {
                                        parser2.nextValue();
                                        if(parser2.getCurrentName() == 'ContractID'){
                                            vNumContrato = String.valueOf(parser2.getText());
                                            system.debug('vNumContrato: ' + vNumContrato);
                                        }
                                    }
                                }
                                
                                System.debug('vNumContrato: '+vNumContrato);
                                
                                vNumeroItemContrato = formatarCodigo(vNumContrato, idc.NumeroItemContrato__c);
                                System.debug('vNumeroItemContrato: '+vNumeroItemContrato);
                                
                                String responseBodyUpdateItem1, responseStatusUpdateItem1;
                                Integer responseCodeUpdateItem1;
                                
                                //Requisição de Atualização do Número do Circuito no primeiro Item
                                String vBodyJSONUpdate = '{"ServiceContract_Lines": [{"LineNum": 1,"U_NumeroCircuito": "'+vNumeroItemContrato+'"}]}';
                                
                                if(Test.isRunningTest()){
                                    responseBodyUpdateItem1 = '{"ItemId":"TESTE123"}';
                                    HttpMock httpMock = new HttpMock(204, 'OK', responseBodyUpdateItem1, new Map<String,String>());
                                    resUpdateItem1 = httpMock.respond(reqTest);
                                }else{
                                    
                                    List<NamedCredential> listCredContrato = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'ApiContratoSAP' LIMIT 1];
                                    
                                    String vEndpoint = listCredContrato[0].Endpoint + '('+vNumContrato+')';
                                    
                                    resUpdateItem1 = HttpUtils.getInstance().sendRequestPatchItemContrato('PATCH', vEndpoint, 120000, vBodyJSONUpdate, vToken);
                                    System.debug('resUpdateItem1 ' + resUpdateItem1);                               
                                    System.debug('resUpdateItem1.getStatusCode ' + resUpdateItem1.getStatusCode());    
                                    System.debug('resUpdateItem1.getbody() ' + resUpdateItem1.getbody());     
                                }
                                responseBodyUpdateItem1 = resUpdateItem1.getbody();
                                responseCodeUpdateItem1 = resUpdateItem1.getStatusCode();
                                responseStatusUpdateItem1 = resUpdateItem1.getStatus();
                                
                                if(responseCodeUpdateItem1 == 204){
                                    
                                    String responseBodyTaxa, responseStatusTaxa;
                                    Integer responseCodeTaxa;
                                    
                                    if(idc.TaxaInstalacao__c != null && idc.TaxaInstalacao__c > 0){
                                        vStatusTaxa = 'P';
                                        vFormaPagamentoTaxa = idc.FormaPagamentoInstalacao__c;
                                    } else {
                                        vStatusTaxa = 'I';
                                        vFormaPagamentoTaxa = '-1';
                                    }
                                    
                                    String vJSONTaxaInstalacao = '{"DataSource": "O", "U_ContractID": "'+vNumContrato+'", "U_Line": "'+idc.NumeroItemContrato__c+'", "U_NumeroCircuito": "'+vNumeroItemContrato+'", "U_Valor": '+idc.TaxaInstalacao__c+', "U_Status": "'+vStatusTaxa+'", "U_Data": "'+vToday+'", "U_FormaPagto": "'+vFormaPagamentoTaxa+'"}';
                                    
                                    if(Test.isRunningTest()){
                                        responseBodyTaxa = '{"ItemId":"TESTE123"}';
                                        HttpMock httpMock = new HttpMock(201, 'OK', responseBodyTaxa, new Map<String,String>());
                                        resTaxa = httpMock.respond(reqTest);
                                    }else{
                                        resTaxa = HttpUtils.getInstance().sendRequestPostTaxaInstalacao('POST', 'callout:APITaxaInstacaoContrato', 120000, vJSONTaxaInstalacao, vToken);
                                        System.debug('resTaxa ' + resTaxa);                               
                                        System.debug('resTaxa.getStatusCode ' + resTaxa.getStatusCode());    
                                        System.debug('resTaxa.getbody() ' + resTaxa.getbody());     
                                    }
                                    
                                    responseBodyTaxa = resTaxa.getbody();
                                    responseStatusTaxa = resTaxa.getStatus();
                                    responseCodeTaxa = resTaxa.getStatusCode();
                                    
                                    if(responseCodeTaxa != 201){
                                        insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'POST - Inclusão Taxa de Instalação - Id: '+idc.Id, vJSONTaxaInstalacao, responseBodyTaxa, responseStatusTaxa, responseCodeTaxa, System.Now(), True);
                                    }
                                    
                                } else {
                                    insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'PATCH - Atualização Item 1 - Id: '+idc.Id, vBodyJSONUpdate, responseBodyUpdateItem1, responseStatusUpdateItem1, responseCodeUpdateItem1, System.Now(), True);
                                }
                                
                            } else {
                                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'POST - Insere Contrato no SAP - Id: '+idc.Id, vBodyContract, responseBodyContract, responseStatusContract, responseCodePostContract, System.Now(), True);
                                break;
                            }
                            
                            idc.IDCartaoDoEquipamentoSAP__c = SerialNumConcatenado;
                            idc.Numero_do_circuito__c = vNumeroItemContrato;
                            
                            Contract c = new Contract();
                            c.Id = idc.Contrato__c;
                            c.Codigo_do_contrato__c = vNumContrato;
                            c.EnviadoSAP__c = TRUE;
                            update c;                        
                            
                        } else {
                            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'POST - Cartão de Equipamento Item 1 SAP - Id: '+idc.Id, vBodyJSONCartaoEquip1, responseBodyCartaoEquip1, responseStatusCartaoEquip1, responseCodeCartaoEquip1, System.Now(), True);
                        }
                        
                        //Decisão para adicionar demais Itens no Contrato
                    } else if(idc.NumeroItemContrato__c != 1) {
                        
                        String responseBodyCartaoEquip2, responseStatusCartaoEquip2, vBodyJSONCartaoEquip2, vConcentrador;
                        Integer responseCodeCartaoEquip2;
                        
                        if(idc.Cidade_de_origem__c != null){
                            vCodigoCidadeOrigemSAP = [SELECT ChaveSAP__c FROM Municipio_IBGE__c WHERE Name =: idc.Cidade_de_origem__c AND Sigla_UF__c =: idc.Estado_de_origem__c].ChaveSAP__c;
                        } else {
                            vCodigoCidadeOrigemSAP = '';
                        }
                        
                        if(idc.Cidade_de_destino__c != null){
                            vCodigoCidadeDestinoSAP = [SELECT ChaveSAP__c FROM Municipio_IBGE__c WHERE Name =: idc.Cidade_de_destino__c AND Sigla_UF__c =: idc.Estado_de_destino__c].ChaveSAP__c;
                        } else {
                            vCodigoCidadeDestinoSAP = '';
                        }
                        
                        if(idc.Concentrador__c == False){
                            vConcentrador = 'Não';
                        } else {
                            vConcentrador = 'Sim';
                        }
                        
                        if(idc.Quantidade__c != null){
                            vQuantidadeProduto = Integer.valueOf(idc.Quantidade__c);
                        } else {
                            vQuantidadeProduto = 1;
                        }
                        
                        JSONGenerator genEquip = JSON.createGenerator(true);
                        genEquip.writeStartObject();
                        genEquip.writeStringField('CustomerCode',idc.Conta__r.Codigo_SAP_cliente__c); 
                        genEquip.writeStringField('ItemCode', idc.Produto__r.ProductCode);
                        genEquip.writeStringField('ManufacturerSerialNum',SerialNumConcatenado);
                        genEquip.writeStringField('U_TI_CONCENT', vConcentrador);
                        
                        genEquip.writeStringField('Street', vRuaOrigem.abbreviate(50));
                        genEquip.writeStringField('StreetNo', vNumeroOrigem.abbreviate(20));
                        
                        vComplementoOrigem = vComplementoOrigem.abbreviate(100);
                        
                        genEquip.writeStringField('BuildingFloorRoom', vComplementoOrigem.abbreviate(60));
                        genEquip.writeStringField('ZipCode', vCEPOrigem.abbreviate(10));
                        genEquip.writeStringField('City', vCidadeOrigem.abbreviate(50));
                        genEquip.writeStringField('Block', vBairroOrigem.abbreviate(50));
                        genEquip.writeStringField('StateCode', vEstadoOrigem);
                        genEquip.writeStringField('County', vCodigoCidadeOrigemSAP);
                        genEquip.writeStringField('CountryCode', 'BR');
                        
                        genEquip.writeStringField('U_AddrType', vTipoLogrDestino);
                        genEquip.writeStringField('U_Street', vRuaDestino.abbreviate(50));
                        genEquip.writeStringField('U_StreetNo', vNumeroDestino.abbreviate(20));
                        
                        vComplementoDestino = vComplementoDestino.abbreviate(100);
                        
                        genEquip.writeStringField('U_Building', vComplementoDestino.abbreviate(60));
                        genEquip.writeStringField('U_ZipCode', vCEPDestino.abbreviate(10));
                        genEquip.writeStringField('U_City', vCidadeDestino.abbreviate(50));
                        genEquip.writeStringField('U_Block', vBairroDestino.abbreviate(50));
                        genEquip.writeStringField('U_State', vEstadoDestino);
                        genEquip.writeStringField('U_County', vCodigoCidadeDestinoSAP);
                        genEquip.writeStringField('U_PontoReferencia', vPontoRefDestino.abbreviate(20));
                        genEquip.writeEndObject();
                        
                        vBodyJSONCartaoEquip2 = genEquip.getAsString();
                        
                        //Requisição Criar Cartão de Equipamento dos demais Itens
                        if(Test.isRunningTest()){
                            responseBodyCartaoEquip2 = '{"CardEquipamentId":"TESTE123"}';
                            HttpMock httpMock = new HttpMock(201, 'OK', responseBodyCartaoEquip2, new Map<String,String>());
                            resCartaoEquip2 = httpMock.respond(reqTest);
                        }else{
                            resCartaoEquip2 = HttpUtils.getInstance().sendRequestPOSTCartaoEquipamento('POST', 'callout:ApiCartaoEquipamentoSAP', 120000, vBodyJSONCartaoEquip2, vToken);
                            System.debug('resCartaoEquip2 ' + resCartaoEquip2); 
                            System.debug('resCartaoEquip2.getStatusCode ' + resCartaoEquip2.getStatusCode());    
                            System.debug('resCartaoEquip2.getbody() ' + resCartaoEquip2.getbody());      
                        }
                        
                        responseBodyCartaoEquip2 = resCartaoEquip2.getbody();
                        responseCodeCartaoEquip2 = resCartaoEquip2.getStatusCode();
                        responseStatusCartaoEquip2 = resCartaoEquip2.getStatus();
                        
                        if(responseCodeCartaoEquip2 == 201){
                            String responseBodyCreateItem, responseStatusCreateItem, vBodyJSONCreateItem;
                            Integer responseCodeCreateItem;
                            
                            //Pausa de 3 segundos
                            Datetime startTime = Datetime.now(), endTime;
                            
                            do {
                                endTime = Datetime.now();
                            } while (endTime.getTime() - startTime.getTime() < 3000);
                                                        
                            Contract cont = [SELECT Id, Codigo_do_contrato__c FROM Contract WHERE Id =: idc.Contrato__c];
                            
                            String vNumeroItemContrato = formatarCodigo(cont.Codigo_do_contrato__c, idc.NumeroItemContrato__c);
                            
                            if(idc.Banda__c != null && idc.Banda__c != 0){
                                Decimal vBandaInt = idc.Banda__c*1024;
                                vBanda = String.valueOf(vBandaInt);
                            } else {
                                vBanda = '';
                            }
                            
                            vBodyJSONCreateItem = '{"ServiceContract_Lines": [{"LineNum": '+idc.NumeroItemContrato__c+',"ItemCode": "'+idc.Produto__r.ProductCode+'","ManufacturerSerialNum": "'+SerialNumConcatenado+'","U_NumeroCircuito": "'+vNumeroItemContrato+'","U_SalesItem": "'+idc.Analise_de_Viabilidade__r.Name+'", "U_FLX_Status":"A", "U_BIT_Valor_Unit": "'+idc.Valor__c+'", "U_FLX_Banda":"'+vBanda+'", "U_Quantidade": '+vQuantidadeProduto+', "U_ControleAlt": "SI"}]}';
                            
                            //Requisição Criar os demais Itens no Contrato
                            if(Test.isRunningTest()){
                                responseBodyCreateItem = '{"ItemId":"TESTE123"}';
                                HttpMock httpMock = new HttpMock(204, 'OK', responseBodyCreateItem, new Map<String,String>());
                                resCreateItem = httpMock.respond(reqTest);
                            }else{
                                List<NamedCredential> listCredContrato = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'ApiContratoSAP' LIMIT 1];
                                
                                String vEndpoint = listCredContrato[0].Endpoint + '('+cont.Codigo_do_contrato__c+')';
                                
                                resCreateItem = HttpUtils.getInstance().sendRequestPatchItemContrato('PATCH', vEndpoint, 120000, vBodyJSONCreateItem, vToken);
                                System.debug('resCreateItem ' + resCreateItem); 
                                System.debug('resCreateItem.getStatusCode ' + resCreateItem.getStatusCode());    
                                System.debug('resCreateItem.getbody() ' + resCreateItem.getbody());      
                            }
                            
                            responseBodyCreateItem = resCreateItem.getbody();
                            responseCodeCreateItem = resCreateItem.getStatusCode();
                            responseStatusCreateItem = resCreateItem.getStatus();
                            
                            if(responseCodeCreateItem ==  204){
                                
                                idc.IDCartaoDoEquipamentoSAP__c = SerialNumConcatenado;
                                idc.Numero_do_circuito__c = vNumeroItemContrato;
                                
                                String responseBodyTaxa, responseStatusTaxa;
                                Integer responseCodeTaxa;
                                
                                if(idc.TaxaInstalacao__c != null && idc.TaxaInstalacao__c > 0){
                                    vStatusTaxa = 'P';
                                    vFormaPagamentoTaxa = idc.FormaPagamentoInstalacao__c;
                                } else {
                                    vStatusTaxa = 'I';
                                    vFormaPagamentoTaxa = '-1';
                                }
                                
                                String vJSONTaxaInstalacao = '{"DataSource": "O", "U_ContractID": "'+cont.Codigo_do_contrato__c+'", "U_Line": "'+idc.NumeroItemContrato__c+'", "U_NumeroCircuito": "'+vNumeroItemContrato+'", "U_Valor": '+idc.TaxaInstalacao__c+', "U_Status": "'+vStatusTaxa+'", "U_Data": "'+vToday+'", "U_FormaPagto": "'+vFormaPagamentoTaxa+'"}';
                                
                                if(Test.isRunningTest()){
                                    responseBodyTaxa = '{"ItemId":"TESTE123"}';
                                    HttpMock httpMock = new HttpMock(201, 'OK', responseBodyTaxa, new Map<String,String>());
                                    resTaxa = httpMock.respond(reqTest);
                                }else{
                                    resTaxa = HttpUtils.getInstance().sendRequestPostTaxaInstalacao('POST', 'callout:APITaxaInstacaoContrato', 120000, vJSONTaxaInstalacao, vToken);
                                    System.debug('resTaxa ' + resTaxa);                               
                                    System.debug('resTaxa.getStatusCode ' + resTaxa.getStatusCode());    
                                    System.debug('resTaxa.getbody() ' + resTaxa.getbody());     
                                }
                                
                                responseBodyTaxa = resTaxa.getbody();
                                responseStatusTaxa = resTaxa.getStatus();
                                responseCodeTaxa = resTaxa.getStatusCode();
                                
                                if(responseCodeTaxa != 201){
                                    insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'POST - Inclusão Taxa de Instalação - Id: '+idc.Id, vJSONTaxaInstalacao, responseBodyTaxa, responseStatusTaxa, responseCodeTaxa, System.Now(), True);
                                }
                                
                            } else {
                                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'PATCH - Inclusão Item: '+idc.NumeroItemContrato__c+' SAP - Id: '+idc.Id, vBodyJSONCreateItem, responseBodyCreateItem, responseStatusCreateItem, responseCodeCreateItem, System.Now(), True);
                            }
                        } else {
                            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'POST - Cartão de Equipamento Item: '+idc.NumeroItemContrato__c+' SAP - Id: '+idc.Id, vBodyJSONCartaoEquip2, responseBodyCartaoEquip2, responseStatusCartaoEquip2, responseCodeCartaoEquip2, System.Now(), True);
                        }
                    }
                } else {
                    insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP', 'POST - Sessão Token SAP - Id: '+idc.Id, bodyJsonAcesso, responseBodyAcesso, responseStatusAcesso, responseCodeAcesso, System.Now(), True);
                    break;
                }
            }
            
            update scope;
        } catch (Exception e){
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchEnviaContratoAoSAP - ContractId: '+listQuery[0], 'POST - Contrato SAP', 'Custom Exception Interno Salesforce: ' + e.getMessage() + ' Linha: '+e.getLineNumber()+' Tipo: '+e.getTypeName(), null, null, null, System.Now(), True);
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
        String vIdContract = listQuery[0];
        
        List<AggregateResult> aggregateResults = [SELECT count(Id) qtddItemContrato FROM Item_do_Contrato__c WHERE Contrato__c = :vIdContract AND Numero_do_circuito__c =: NULL];
        Decimal vQtddItemSucesso = (Decimal) aggregateResults[0].get('qtddItemContrato');
        
        if(vQtddItemSucesso == 0){
            
            insert ControleDeServicoBO.getInstance().gerarLogPai('Sucesso', 'BatchEnviaContratoAoSAP', 'Finish - Contrato: '+vIdContract, null, null, null, null, System.Now(), True);
            
            Contract c = new Contract();
            c.Id = vIdContract;
            c.CriadoComSucessoNoSAP__c = True;
            update c;                    
        } else {
            insert ControleDeServicoBO.getInstance().gerarLogPai('Parcialmente executado', 'BatchEnviaContratoAoSAP', 'Finish', null, null, null, null, System.Now(), True);
            //Atualiza uma Flag no Contrato para saberem que algo deu errado
        }
        
    }
    
    public static String formatarCodigo(String codigoContrato, Decimal numeroItem) {
        String resultado = '';
        
        if (codigoContrato.length() == 1) {
            resultado += '00000' + codigoContrato;
        } else if (codigoContrato.length() == 2) {
            resultado += '0000' + codigoContrato;
        } else if (codigoContrato.length() == 3) {
            resultado += '000' + codigoContrato;
        } else if (codigoContrato.length() == 4) {
            resultado += '00' + codigoContrato;
        } else if (codigoContrato.length() == 5) {
            resultado += '0' + codigoContrato;
        } else {
            resultado += codigoContrato;
        }
        
        String strNumeroItem = String.valueOf(numeroItem);
        if (strNumeroItem.length() == 1) {
            resultado += '000' + strNumeroItem;
        } else if (strNumeroItem.length() == 2) {
            resultado += '00' + strNumeroItem;
        } else if (strNumeroItem.length() == 3) {
            resultado += '0' + strNumeroItem;
        } else {
            resultado += strNumeroItem;
        }
        
        return resultado;
    }
}