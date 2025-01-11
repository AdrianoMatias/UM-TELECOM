public without sharing class AsyncEnviaContractPlusAoSAP {
    
    @InvocableMethod
    public static void upsertContractPlusSAP(List<String> queryString1){
        String vToken, responseBody, responseStatus, vEndpointContractPlus, vEndpointArvoreProd, vNumeroUltimoContrato;
        String responseBodyAcesso, responseStatusAcesso, responseBodyArvore, responseBodyUtil, responseStatusUtil, responseStatusArvore, vNumeroCircuito, vTaxaInstalacao, vFormaPagmt;
        String responseBodyTokenUlt, responseStatusTokenUlt, vTokenUlt, responseBodyGetUlt, responseStatusGetUlt, vCentroCusto, userFieldsForma, userFieldsTaxa, userFieldEndA, userFieldEndB, vIdContractPlus;
        Integer responseStatusCode, responseCodeAcesso,  responseCodeArvore, responseCodeTokenUlt, responseCodeGetUlt, responseStatusCodeUtil, vQtddParcelasTaxa;
        Date vDataVencimentoTaxa = null;
        Decimal vNumeroItem;
        
        HttpRequest reqTest = new HttpRequest();
        HttpResponse resAcesso = new HttpResponse();
        HttpResponse resTokenUlt = new HttpResponse();
        HttpResponse resGetUlt = new HttpResponse();
        HttpResponse resArvoreProd = new HttpResponse();
        HttpResponse resUtilizacaoProd = new HttpResponse();
        HttpResponse resUpsertContract = new HttpResponse();
        
        Item_do_Contrato__c itemContrato = [Select Id, Quantidade__c, ValorUnitario__c, Banda__c, Numero_do_circuito__c, Data_de_Inicio__c, Data_de_Termino__c, NumeroItemContrato__c, TipoFaturamento__c, FormaPagamentoInstalacao__c, TaxaInstalacao__c, Recorrencia__c, Status__c, Rua_de_origem__c, Numero_de_origem__c, Complemento_de_origem__c, Bairro_de_origem__c, Cep_de_origem__c, Cidade_de_origem__c, Estado_de_origem__c, Tipo_de_logradouro_de_origem__c, Rua_de_destino__c, Numero_de_destino__c, Complemento_de_destino__c, Bairro_de_destino__c, Cep_de_destino__c, Cidade_de_destino__c, Estado_de_destino__c, Tipo_de_logradouro_de_destino__c, Contrato__c, Contrato__r.ContractTerm, Contrato__r.AluguelContractPlus__c, Contrato__r.TemporarioContractPlus__c, Contrato__r.PermutaContractPlus__c, Contrato__r.RecorrenteContractPlus__c, Contrato__r.TipoNotaContractPlus__c, Contrato__r.ContractNumber, Contrato__r.Codigo_do_contrato__c, Contrato__r.Status, Contrato__r.Description, Contrato__r.Owner.Codigo_do_vendedor__c, Contrato__r.DiaVencimento__c, Contrato__r.StartDate, Contrato__r.EndDate, Contrato__r.EnviadoSAP__c, Produto__r.ProductCode, Produto__r.Name, Produto__r.QuantityUnitOfMeasure, Conta__r.Codigo_SAP_cliente__c, Conta__r.Grupo__c, Conta__r.Name FROM Item_do_Contrato__c WHERE Id =: queryString1[0]];
        
        try{
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
                
                List<NamedCredential> listArvoreProd = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'ApiGetArvoreProdutos' LIMIT 1];
                
                vEndpointArvoreProd = listArvoreProd[0].Endpoint + '(\''+ itemContrato.Produto__r.ProductCode + '\')';
                system.debug('vEndpointArvoreProd: '+vEndpointArvoreProd);
                
                //2ª Requisição: GET na Arvore de Sub-Produtos
                if(Test.isRunningTest()){
                    responseBodyArvore = '{"TreeCode": "C000001", "ProductTreeLines": [{"ItemCode": "SP00061","Quantity": 1.0,"Warehouse": "01","Price": 0.0,"Currency": "","IssueMethod": "im_Backflush","InventoryUOM": null,"Comment": null,"ParentItem": "C000001","PriceList": 11,"DistributionRule": null,"Project": null,"DistributionRule2": null,"DistributionRule3": null,"DistributionRule4": null,"DistributionRule5": null,"WipAccount": null,"ItemType": "pit_Item","LineText": null,"AdditionalQuantity": 0.0,"StageID": null, "ChildNum": 1, "VisualOrder": 1,"ItemName": "SERVIÇO DE CONEXÃO A INTERNET - SCI", "U_Percentual": 50.0}]}';
                    HttpMock httpMock = new HttpMock(200, 'OK', responseBodyArvore, new Map<String,String>());
                    resArvoreProd = httpMock.respond(reqTest);
                }else{
                    resArvoreProd = HttpUtils.getInstance().sendRequestGetArvoreProd('GET', vEndpointArvoreProd, 120000, vToken);
                    System.debug('resArvoreProd ' + resArvoreProd); 
                    System.debug('resArvoreProd.getStatusCode ' + resArvoreProd.getStatusCode());    
                    System.debug('resArvoreProd.getbody() ' + resArvoreProd.getbody());       
                }   
                
                responseBodyArvore = resArvoreProd.getbody();
                responseCodeArvore = resArvoreProd.getStatusCode();
                responseStatusArvore = resArvoreProd.getStatus();
                
                if(responseCodeArvore == 200){
                    
                    if(itemContrato.Contrato__r.Codigo_do_contrato__c == null){
                        
                        List<SAP_Integration__mdt> credentialTokenUltimoContrato = [SELECT UserName__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'UltimoContractPlus'];
                        
                        String requestBodyToken = 'Username='+credentialTokenUltimoContrato[0].UserName__c+'&Password='+credentialTokenUltimoContrato[0].Password__c+'';
                        
                        //3ª Requisição: Solicitar Token Ultimo ContractPlus
                        if(Test.isRunningTest()){
                            responseBodyTokenUlt = '{"access_token": "yTXJiGyzsiDIwG5s"}';
                            HttpMock httpMock = new HttpMock(200, 'OK', responseBodyTokenUlt, new Map<String,String>());
                            resTokenUlt = httpMock.respond(reqTest);
                        }else{
                            resTokenUlt = HttpUtils.getInstance().sendRequestPostTokenUltimoContractPlus('POST', 'callout:API_TokenUltimoContractPlus', 120000, requestBodyToken);
                            System.debug('resTokenUlt.getStatusCode ' + resTokenUlt.getStatusCode());    
                            System.debug('resTokenUlt.getbody() ' + resTokenUlt.getbody());    
                        }
                        responseBodyTokenUlt = resTokenUlt.getbody();
                        responseCodeTokenUlt = resTokenUlt.getStatusCode();
                        responseStatusTokenUlt = resTokenUlt.getStatus();
                        
                        
                        if(responseCodeTokenUlt == 200){
                            
                            JSONParser parserUltToken = JSON.createParser(responseBodyTokenUlt);
                            while(parserUltToken.nextToken()!= null) {
                                if(parserUltToken.getCurrentToken() == JSONToken.FIELD_NAME) {
                                    parserUltToken.nextValue();
                                    if(parserUltToken.getCurrentName() == 'access_token'){
                                        vTokenUlt = String.valueOf(parserUltToken.getText());
                                        system.debug('vTokenUlt: ' + vTokenUlt);
                                    }
                                }
                            }
                            
                            if(vTokenUlt != null && vTokenUlt != ''){
                                
                                //4ª Requisição: Solicitar GET Ultimo ContractPlus
                                if(Test.isRunningTest()){
                                    responseBodyGetUlt = '{"AlternativeNumber": 9523, "Id": 5236}';
                                    HttpMock httpMock = new HttpMock(200, 'OK', responseBodyGetUlt, new Map<String,String>());
                                    resGetUlt = httpMock.respond(reqTest);
                                    responseBodyGetUlt = resGetUlt.getbody();
                                }else{
                                    resGetUlt = HttpUtils.getInstance().sendRequestGetUltimoContractPlus('GET', 'callout:API_NumeroUltimoContractPlus', 120000, vTokenUlt);
                                    System.debug('resGetUlt.getStatusCode ' + resGetUlt.getStatusCode());    
                                    System.debug('resGetUlt.getbody() ' + resGetUlt.getbody());    
                                }
                                
                                responseBodyGetUlt = String.valueOf(resGetUlt.getbody());
                                responseCodeGetUlt = resGetUlt.getStatusCode();
                                responseStatusGetUlt = resGetUlt.getStatus();
                                
                                if(responseCodeGetUlt == 200){
                                    
                                    JSONParser parserUltContrato = JSON.createParser(responseBodyGetUlt);
                                    while (parserUltContrato.nextToken() != null) {
                                        if (parserUltContrato.getCurrentToken() == JSONToken.FIELD_NAME) {
                                            String fieldName = parserUltContrato.getCurrentName();
                                            parserUltContrato.nextToken();                                             
                                            if (fieldName.equals('AlternativeNumber')) {
                                                vNumeroUltimoContrato = parserUltContrato.getText();
                                                System.debug('vNumeroUltimoContrato: ' + vNumeroUltimoContrato);
                                            } else if (fieldName.equals('Id')) {
                                                vIdContractPlus = String.valueOf(parserUltContrato.getIntegerValue());
                                                System.debug('vIdContractPlus: ' + vIdContractPlus);
                                            }
                                        }
                                    }
                                    
                                    Integer vNumeroId = Integer.valueOf(vIdContractPlus);
                                    vNumeroId++;
                                    vIdContractPlus = String.valueOf(vNumeroId);
                                                                        
                                    Integer vNumero = Integer.valueOf(vNumeroUltimoContrato);
                                    vNumero++;
                                    vNumeroUltimoContrato = String.valueOf(vNumero);
                                    vNumeroItem = 1;
                                    system.debug('vNumeroUltimoContrato: '+vNumeroUltimoContrato);
                                    
                                    vNumeroCircuito = formatarCodigo(vNumeroUltimoContrato, vNumeroItem);
                                    
                                } else {
                                    //Erro GET Ultimo ContractPlus 
                                    insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsycEnviaContractPlusAoSAP', 'GET - Ultimo ContractPlus: '+itemContrato.Id, 'callout:API_NumeroUltimoContractPlus', responseBodyGetUlt, responseStatusGetUlt, responseCodeGetUlt, System.Now(), False);
                                    System.debug('Erro GET Ultimo ContractPlus');
                                    return;
                                }
                            } else {
                                //Erro Token POST Ultimo ContractPlus, Token Vazio
                                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsycEnviaContractPlusAoSAP', 'POST - Token Vazio Ultimo ContractPlus: '+itemContrato.Id, 'callout:API_TokenUltimoContractPlus', responseBodyTokenUlt, responseStatusTokenUlt, responseCodeTokenUlt, System.Now(), False);
                                System.debug('Erro Token POST Ultimo ContractPlus, Token Vazio');
                                return;
                            }
                        } else {
                            //Erro Token POST Ultimo ContractPlus
                            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsyncEnviaContractPlusAoSAP', 'POST - Token Error Ultimo ContractPlus: '+itemContrato.Id, 'callout:API_TokenUltimoContractPlus', responseBodyTokenUlt, responseStatusTokenUlt, responseCodeTokenUlt, System.Now(), False);
                            System.debug('Erro Token POST Ultimo ContractPlus');
                            return;
                        }
                        
                    } else {
                        AggregateResult[] result = [SELECT MAX(NumeroItemContrato__c) maxNumero FROM Item_do_Contrato__c WHERE Contrato__c = :itemContrato.Contrato__c];
                        
                        Decimal maxNumeroItemContrato = (Decimal) result[0].get('maxNumero');
                        vNumeroItem = maxNumeroItemContrato + 1;
                        
                        vNumeroCircuito = formatarCodigo(itemContrato.Contrato__r.Codigo_do_contrato__c, vNumeroItem);
                    }
                    
                    List<SAP_Integration__mdt> credential = [SELECT URL_Parameters__c, Password__c FROM SAP_Integration__mdt WHERE DeveloperName = 'ContractPlus'];
                    
                    vEndpointContractPlus = credential[0].URL_Parameters__c + credential[0].Password__c;
                    
                    JSONGenerator genContract = JSON.createGenerator(false);
                    genContract.writeStartObject();
                    genContract.writeStringField('id', credential[0].Password__c);
                    genContract.writeStringField('hookName', 'Contract');
                    genContract.writeFieldName('contracts');
                    genContract.writeStartArray();
                    
                    // Inicia o objeto dentro do array de contracts
                    genContract.writeStartObject();
                    genContract.writeNumberField('companyId', 1); //Chumbado
                    genContract.writeStringField('cardCode', itemContrato.Conta__r.Codigo_SAP_cliente__c); //Obrigatório
                    genContract.writeStringField('cardName', itemContrato.Conta__r.Name); //Obrigatório
                    genContract.writeStringField('dateConclusion', String.valueOf(itemContrato.Contrato__r.EndDate)); //Obrigatório
                    genContract.writeStringField('dateStart', String.valueOf(itemContrato.Contrato__r.StartDate)); //Obrigatório
                    genContract.writeStringField('projectId', ''); //Chumbado
                    
                    if(itemContrato.Contrato__r.Owner.Codigo_do_vendedor__c != null){
                        genContract.writeNumberField('slpCode', Decimal.valueOf(itemContrato.Contrato__r.Owner.Codigo_do_vendedor__c)); //Se o usuário tiver o 'Código vendedor' enviar, se não pode deixar 0
                    } else {
                        genContract.writeNumberField('slpCode', 0);
                    }
                    
                    genContract.writeStringField('groupNum', itemContrato.Contrato__r.DiaVencimento__c); //Obrigatório dia do Vencimento
                    
                    if(itemContrato.Conta__r.Grupo__c == 'Evento' || itemContrato.Conta__r.Grupo__c == '103'){
                        genContract.writeNumberField('classificationId', 3);
                        vCentroCusto = '205';
                        
                    } else if(itemContrato.Conta__r.Grupo__c == '123'){
                        genContract.writeNumberField('classificationId', 6);
                        vCentroCusto = '202';
                        
                    }else if(itemContrato.Conta__r.Grupo__c == '150'){
                        genContract.writeNumberField('classificationId', 4);
                        vCentroCusto = '206';
                        
                    }else if(itemContrato.Conta__r.Grupo__c == '156'){
                        genContract.writeNumberField('classificationId', 1);
                        vCentroCusto = '203';
                        
                    }else if(itemContrato.Conta__r.Grupo__c == '161'){
                        genContract.writeNumberField('classificationId', 2);
                        vCentroCusto = '214';
                    }
                    
                    genContract.writeStringField('OcrCode', vCentroCusto);
                    
                    genContract.writeNumberField('contractTypeId', 2); //Chumbado
                    
                    if(itemContrato.Contrato__r.Codigo_do_contrato__c == null){ //Obrigatório
                        genContract.writeStringField('alternateNumber', vNumeroUltimoContrato);
                    } else {
                        genContract.writeStringField('alternateNumber', itemContrato.Contrato__r.Codigo_do_contrato__c); 
                    }
                    
                    genContract.writeStringField('paymentMethod', '');
                    
                    if(itemContrato.Contrato__r.Description != null){
                        genContract.writeStringField('comments', itemContrato.Contrato__r.Description);
                    } else {
                        genContract.writeStringField('comments', '');
                    }
                    
                    genContract.writeStringField('U_ALUGUEL2', itemContrato.Contrato__r.AluguelContractPlus__c); //Obrigatório
                    genContract.writeStringField('U_TEMPORARIO2', itemContrato.Contrato__r.TemporarioContractPlus__c); //Obrigatório
                    genContract.writeStringField('U_PERMUTA2', itemContrato.Contrato__r.PermutaContractPlus__c); //Obrigatório
                    genContract.writeStringField('U_RECORRENTE2', itemContrato.Contrato__r.RecorrenteContractPlus__c); //Obrigatório
                    genContract.writeNumberField('U_TipoNota2', Decimal.valueOf(itemContrato.Contrato__r.TipoNotaContractPlus__c)); //Obrigatório
                    
                    genContract.writeStringField('header', ''); //Chumbado
                    genContract.writeStringField('footer', ''); //Chumbado
                    genContract.writeStringField('currency', 'R$'); //Chumbado
                    genContract.writeBooleanField('proBonoRelationShip', false); //Chumbado
                    genContract.writeBooleanField('expensesRefund', false); //Chumbado
                    genContract.writeStringField('objectOfTheContract', ''); //Chumbado
                    genContract.writeStringField('fine', ''); //Chumbado
                    genContract.writeBooleanField('allowAdvance', false); //Chumbado
                    genContract.writeBooleanField('royalties', false); //Chumbado
                    genContract.writeStringField('royaltiesDesc', ''); //Chumbado
                    genContract.writeNumberField('docEntrySbo', 0); //Chumbado
                    genContract.writeNumberField('objTypeSbo', 0); //Chumbado
                    genContract.writeNumberField('productSaleReportType', 0); //Chumbado
                    
                    genContract.writeFieldName('userFields');
                    genContract.writeStartObject();
                    genContract.writeStringField('TipoNota2', '1');
                    genContract.writeEndObject();
                    
                    String userFieldsContract = '{"TipoNota2":"1"}';
                    
                    // Inicia o array de lines
                    genContract.writeFieldName('lines');
                    genContract.writeStartArray();
                    genContract.writeStartObject();
                    genContract.writeNumberField('treeType', 0); //Chumbado
                    
                    genContract.writeStringField('itemCode', itemContrato.Produto__r.ProductCode); //Obrigatório
                    
                    genContract.writeStringField('itemName', itemContrato.Produto__r.Name); //Obrigatório
                    
                    genContract.writeNumberField('quantity', Integer.valueOf(itemContrato.Quantidade__c)); //Obrigatório
                    
                    genContract.writeNumberField('quantityHired', 0); //Chumbado
                    
                    genContract.writeNumberField('priceUnit', itemContrato.ValorUnitario__c); //Obrigatório
                    
                    genContract.writeNumberField('billingType', Decimal.valueOf(itemContrato.TipoFaturamento__c)); //Obrigatório
                    
                    genContract.writeNumberField('calculationTypeId', 0); //chumbado
                    
                    if(itemContrato.Recorrencia__c == 'Mensal'){
                        genContract.writeNumberField('recurrenceType', 2); //Campo dependente do TipoFaturamento__c, sempre que for Recorrente, o valor é Mensal. Qualquer valor diferente disso, enviar 'Não se aplica'
                    } else {
                        genContract.writeNumberField('recurrenceType', 1); 
                    }
                    
                    genContract.writeNumberField('installmentsTotal', 0); //Chumbado
                    
                    Date vDataVencimento = AsyncEnviaContractPlusAoSAP.getNextSpecificDayDate(Integer.valueOf(itemContrato.Contrato__r.DiaVencimento__c));
                    genContract.writeStringField('dueDateBase', String.valueOf(vDataVencimento)); //Obrigatório Data de Vencimento(Verificar dia de Vencimento de jogar para o próximo mês)
                    
                    genContract.writeStringField('birthdayDate', String.valueOf(itemContrato.Contrato__r.StartDate.addYears(1))); //Passar Data de 1 ano após a data de inicio do Contrato *Obrigatório
                    
                    genContract.writeDateField('ReferenceDate', System.Today()); //Obrigatório
                    
                    
                    Date billingDate = AsyncEnviaContractPlusAoSAP.calculateBillingDate(vDataVencimento);
                    System.debug('Data de faturamento: ' + billingDate);
                    
                    genContract.writeStringField('dateBilling', String.valueOf(billingDate));
                    genContract.writeStringField('dateBillingBase', String.valueOf(billingDate));
                    
                    genContract.writeNumberField('inicialBalance', 0); //Chumbado
                    genContract.writeNumberField('usageId', 37); //Chumbado
                    
                    if(itemContrato.Produto__r.QuantityUnitOfMeasure == 'MB'){
                        genContract.writeStringField('measureUnitId', 'Mb'); //Obrigatório
                    } else if(itemContrato.Produto__r.QuantityUnitOfMeasure == 'GB'){
                        genContract.writeStringField('measureUnitId', 'Gb'); //Obrigatório
                    } else {
                        genContract.writeStringField('measureUnitId', 'Und'); //Obrigatório
                    }
                    
                    genContract.writeStringField('OcrCode', vCentroCusto);
                    genContract.writeStringField('OcrCode2', ''); //Chumbado
                    genContract.writeStringField('OcrCode3', ''); //Chumbado
                    genContract.writeStringField('OcrCode4', ''); //Chumbado
                    genContract.writeStringField('OcrCode5', ''); //Chumbado
                    genContract.writeStringField('whsCode', ''); //Chumbado
                    genContract.writeStringField('objectOfTheContract', ''); //Chumbado
                    genContract.writeNumberField('quotationLineNum', 0); //Chumbado
                    genContract.writeStringField('prjCode', ''); //Chumbado
                    
                    if(itemContrato.Contrato__r.Owner.Codigo_do_vendedor__c != null){
                        genContract.writeNumberField('slpCode', Decimal.valueOf(itemContrato.Contrato__r.Owner.Codigo_do_vendedor__c)); //Se o usuário tiver o 'Código vendedor' enviar, se não pode deixar 0
                    } else {
                        genContract.writeNumberField('slpCode', 0);
                    }
                    
                    genContract.writeNumberField('financialIndexId', 0); //Chumbado
                    genContract.writeNumberField('readjustmentValueType', 0); //Chumbado
                    genContract.writeNumberField('billingMonth', 0); //Chumbado
                    genContract.writeNumberField('billingDay', 0); //Chumbado
                    genContract.writeNumberField('measurementById', 1); //Chumbado
                    genContract.writeStringField('effectiveDate', String.valueOf(itemContrato.Contrato__r.StartDate));
                    genContract.writeNumberField('saleReportValueSource', 0); //Chumbado
                    genContract.writeNumberField('saleRepRangeType', 0); //Chumbado
                    genContract.writeNumberField('saleReportValueBase', 0); //Chumbado
                    
                    //Endereços Origem e Destino
                    String vEnderecoOrigem, vEnderecoDestino;
                    
                    // Concatenação Endereço Origem
                    if (String.isNotBlank(itemContrato.Rua_de_origem__c) && itemContrato.Rua_de_origem__c != null){
                        
                        if (String.isNotBlank(itemContrato.Tipo_de_logradouro_de_origem__c)) {
                            vEnderecoOrigem = itemContrato.Tipo_de_logradouro_de_origem__c + ' ';
                        }
                        if (String.isNotBlank(itemContrato.Rua_de_origem__c) && vEnderecoOrigem != null) {
                            vEnderecoOrigem += itemContrato.Rua_de_origem__c;
                        } else {
                            vEnderecoOrigem = itemContrato.Rua_de_origem__c;
                        }
                        if (String.isNotBlank(itemContrato.Numero_de_origem__c)) {
                            vEnderecoOrigem += ', ' + itemContrato.Numero_de_origem__c;
                        }
                        if (String.isNotBlank(itemContrato.Complemento_de_origem__c)) {
                            vEnderecoOrigem += ' - ' + itemContrato.Complemento_de_origem__c;
                        }
                        if (String.isNotBlank(itemContrato.Bairro_de_origem__c)) {
                            vEnderecoOrigem += ' - ' + itemContrato.Bairro_de_origem__c;
                        }
                        if (String.isNotBlank(itemContrato.Cidade_de_origem__c)) {
                            vEnderecoOrigem += ' - ' + itemContrato.Cidade_de_origem__c;
                        }
                        if (String.isNotBlank(itemContrato.Estado_de_origem__c)) {
                            vEnderecoOrigem += '/' + itemContrato.Estado_de_origem__c;
                        }
                        if (String.isNotBlank(itemContrato.Cep_de_origem__c)) {
                            vEnderecoOrigem += ' - ' + itemContrato.Cep_de_origem__c;
                        }
                    }
                    
                    // Concatenação EndereçoDestino
                    if (String.isNotBlank(itemContrato.Rua_de_destino__c) && itemContrato.Rua_de_destino__c != null){
                        
                        if (String.isNotBlank(itemContrato.Tipo_de_logradouro_de_destino__c)) {
                            vEnderecoDestino = itemContrato.Tipo_de_logradouro_de_destino__c + ' ';
                        }
                        if (String.isNotBlank(itemContrato.Rua_de_destino__c) && vEnderecoDestino != null) {
                            vEnderecoDestino += itemContrato.Rua_de_destino__c;
                        } else {
                            vEnderecoDestino = itemContrato.Rua_de_destino__c;
                        }
                        if (String.isNotBlank(itemContrato.Numero_de_destino__c)) {
                            vEnderecoDestino += ', ' + itemContrato.Numero_de_destino__c;
                        }
                        if (String.isNotBlank(itemContrato.Complemento_de_destino__c)) {
                            vEnderecoDestino += ' - ' + itemContrato.Complemento_de_destino__c;
                        }
                        if (String.isNotBlank(itemContrato.Bairro_de_destino__c)) {
                            vEnderecoDestino += ' - ' + itemContrato.Bairro_de_destino__c;
                        }
                        if (String.isNotBlank(itemContrato.Cidade_de_destino__c)) {
                            vEnderecoDestino += ' - ' + itemContrato.Cidade_de_destino__c;
                        }
                        if (String.isNotBlank(itemContrato.Estado_de_destino__c)) {
                            vEnderecoDestino += '/' + itemContrato.Estado_de_destino__c;
                        }
                        if (String.isNotBlank(itemContrato.Cep_de_destino__c)) {
                            vEnderecoDestino += ' - ' + itemContrato.Cep_de_destino__c;
                        }
                    }
                    
                    genContract.writeFieldName('userFields');
                    genContract.writeStartObject();
                    genContract.writeStringField('NumCircuito2', vNumeroCircuito);
                    genContract.writeStringField('Banda2', String.valueOf(itemContrato.Banda__c));
                    
                    String userFieldsNumCircuito = '{"NumCircuito2":"'+vNumeroCircuito+'"';
                    String userFieldsBanda =  '"Banda2":"'+String.valueOf(itemContrato.Banda__c)+'"';
                    
                    if(itemContrato.TaxaInstalacao__c != null && itemContrato.TaxaInstalacao__c > 0){
                        genContract.writeStringField('TaxaInstalacao2', String.valueOf(itemContrato.TaxaInstalacao__c));
                        vTaxaInstalacao = String.valueOf(itemContrato.TaxaInstalacao__c);
                        userFieldsTaxa = '"TaxaInstalacao2":"'+String.valueOf(itemContrato.TaxaInstalacao__c)+'"';
                    } else {
                        genContract.writeStringField('TaxaInstalacao2', '');
                        vTaxaInstalacao = '';
                        userFieldsTaxa = '"TaxaInstalacao2":""';
                    }
                    if(itemContrato.FormaPagamentoInstalacao__c != null){
                        genContract.writeStringField('FormaPagamento2', itemContrato.FormaPagamentoInstalacao__c);
                        vFormaPagmt = itemContrato.FormaPagamentoInstalacao__c;
                        
                        //Quantidade de Parcelas
                        if(vFormaPagmt == '-1'){
                            vQtddParcelasTaxa = 1;
                        } else if(vFormaPagmt == '106'){
                            vQtddParcelasTaxa = 2;
                        } else if(vFormaPagmt == '2'){
                            vQtddParcelasTaxa = 3;
                        } else if(vFormaPagmt == '67'){
                            vQtddParcelasTaxa = 4;
                        } else if(vFormaPagmt == '37'){
                            vQtddParcelasTaxa = 5;
                        } else if(vFormaPagmt == '42'){
                            vQtddParcelasTaxa = 6;
                        } else if(vFormaPagmt == '45'){
                            vQtddParcelasTaxa = 7;
                        } else if(vFormaPagmt == '116'){
                            vQtddParcelasTaxa = 8;
                        } else if(vFormaPagmt == '65'){
                            vQtddParcelasTaxa = 9;
                        } else if(vFormaPagmt == '54'){
                            vQtddParcelasTaxa = 10;
                        } else if(vFormaPagmt == '59'){
                            vQtddParcelasTaxa = 11;
                        } else if(vFormaPagmt == '56'){
                            vQtddParcelasTaxa = 12;
                        } else if(vFormaPagmt == '132'){
                            vQtddParcelasTaxa = 24;
                        }                    
                        userFieldsForma = '"FormaPagamento2":"'+itemContrato.FormaPagamentoInstalacao__c+'"';
                    } else {
                        genContract.writeStringField('FormaPagamento2', ''); 
                        vFormaPagmt = null;
                        vQtddParcelasTaxa = 0;
                        userFieldsForma = '"FormaPagamento2":""';
                    }
                    
                    //Inclusão dos Endereços no JSON
                    if(vEnderecoOrigem != null && String.isNotBlank(vEnderecoOrigem)){
                        genContract.writeStringField('CircEnderecoA', vEnderecoOrigem);
                        userFieldEndA = '"CircEnderecoA":"'+vEnderecoOrigem+'"';
                    } else {
                        genContract.writeStringField('CircEnderecoA', '');
                        userFieldEndA = '"CircEnderecoA":""';
                    }
                    
                    if(vEnderecoDestino != null && String.isNotBlank(vEnderecoDestino)){
                        genContract.writeStringField('CircEnderecoB', vEnderecoDestino);
                        userFieldEndB = '"CircEnderecoB":"'+vEnderecoDestino+'"}';
                    } else {
                        genContract.writeStringField('CircEnderecoB', '');
                        userFieldEndB = '"CircEnderecoB":""}';
                    }
                    
                    genContract.writeEndObject();
                    
                    genContract.writeFieldName('apportionments');
                    genContract.writeStartArray();
                    
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(responseBodyArvore);
                    List<Object> productTreeLinesRaw = (List<Object>) root.get('ProductTreeLines');
                    
                    if(productTreeLinesRaw.size()>0){
                        
                        List<NamedCredential> listUtilizacaoProd = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'ApiItemsSAP' LIMIT 1];
                        
                        String vEndpointUtilizacaoProd = listUtilizacaoProd[0].Endpoint;
                        system.debug('vEndpointUtilizacaoProd: '+vEndpointUtilizacaoProd);
                        
                        for (Object obj : productTreeLinesRaw) {
                            Map<String, Object> line = (Map<String, Object>) obj;
                            String vUtilizacao = null;
                            
                            genContract.writeStartObject();
                            
                            genContract.writeStringField('itemCode', (String) line.get('ItemCode'));
                            genContract.writeStringField('itemName', (String) line.get('ItemName'));
                            genContract.writeStringField('cardCode', itemContrato.Conta__r.Codigo_SAP_cliente__c);
                            genContract.writeStringField('cardName', itemContrato.Conta__r.Name);
                            genContract.writeNumberField('percentage', (Double) line.get('U_Percentual'));
                            genContract.writeStringField('companyId', '1');
                            
                            if(Test.isRunningTest()){
                                responseBody = '{"U_UsgConfFonteS": 38}';
                                HttpMock httpMock = new HttpMock(200, 'OK', responseBody, new Map<String,String>());
                                resUtilizacaoProd = httpMock.respond(reqTest);
                            }else{
                                resUtilizacaoProd = HttpUtils.getInstance().sendRequestUtilizacao('GET', vEndpointUtilizacaoProd+'(\''+(String) line.get('ItemCode')+'\')?$select=ItemCode,ItemName,U_UsgConfFonteS', 120000, vToken);
                                System.debug('resUtilizacaoProd.getStatusCode ' + resUtilizacaoProd.getStatusCode());    
                                System.debug('resUtilizacaoProd.getbody() ' + resUtilizacaoProd.getbody());      
                            }
                            
                            responseBodyUtil = resUtilizacaoProd.getbody();
                            responseStatusCodeUtil = resUtilizacaoProd.getStatusCode();
                            responseStatusUtil = resUtilizacaoProd.getStatus();
                            
                            if(responseStatusCodeUtil == 200) {
                                
                                JSONParser parserUltToken = JSON.createParser(responseBodyUtil);
                                while(parserUltToken.nextToken()!= null) {
                                    if(parserUltToken.getCurrentToken() == JSONToken.FIELD_NAME) {
                                        parserUltToken.nextValue();
                                        if(parserUltToken.getCurrentName() == 'U_UsgConfFonteS'){
                                            vUtilizacao = String.valueOf(parserUltToken.getText());
                                            system.debug('vUtilizacao: ' + vUtilizacao);
                                        }
                                    }
                                }
                                if(vUtilizacao != null && vUtilizacao != '') {
                                    genContract.writeNumberField('usage', Integer.valueOf(vUtilizacao));
                                } else {
                                    genContract.writeNumberField('usage', 37);
                                }
                                
                            } else {
                                //Erro Utilização Produto Filho
                                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsyncEnviaContractPlusAoSAP', 'GET - Utilização de Produtos: '+itemContrato.Id, vEndpointUtilizacaoProd+'(\''+(String) line.get('ItemCode')+'\')?$select=ItemCode,ItemName,U_UsgConfFonteS', responseBodyUtil, responseStatusUtil, responseStatusCodeUtil, System.Now(), False);
                                genContract.writeNumberField('usage', 37);
                            }
                            
                            genContract.writeStringField('whsCode', '');
                            genContract.writeStringField('alternativeItemName', '');
                            
                            genContract.writeEndObject();
                        }
                    }
                    
                    genContract.writeEndArray();
                    genContract.writeFieldName('saleRepRanges');
                    genContract.writeStartArray();
                    genContract.writeEndArray();
                    genContract.writeEndObject();
                    
                    if(vFormaPagmt != null){
                        
                        //Divisão da Taxa de Instalação em Parcelas
                        Double vValorTaxaParcelada = itemContrato.TaxaInstalacao__c / vQtddParcelasTaxa;
                        system.debug('vFormaPagmt: '+vFormaPagmt);
                        system.debug('TaxaInstalacao__c: '+itemContrato.TaxaInstalacao__c);
                        system.debug('vQtddParcelasTaxa: '+vQtddParcelasTaxa);
                        system.debug('vValorTaxaParcelada: '+vValorTaxaParcelada);
                        
                        //Adicionar Item de Cobrança de Taxa de Instalação
                        for (Integer i = 0; i < vQtddParcelasTaxa; i++) {
                            genContract.writeStartObject();
                            genContract.writeNumberField('treeType', 0); //Chumbado
                            genContract.writeStringField('itemCode', 'S000002'); //Obrigatório
                            genContract.writeStringField('itemName', 'SERVIÇO DE INSTALAÇÃO DE LINK'); //Obrigatório
                            genContract.writeNumberField('quantity', 1); //Obrigatório
                            genContract.writeNumberField('quantityHired', 0); //Chumbado
                            genContract.writeNumberField('priceUnit', vValorTaxaParcelada); //Obrigatório
                            genContract.writeNumberField('billingType', 3); //Obrigatório
                            genContract.writeNumberField('calculationTypeId', 0); //chumbado
                            genContract.writeNumberField('recurrenceType', 2);        
                            genContract.writeNumberField('installmentsTotal', 0); //Chumbado
                            genContract.writeStringField('dateBilling', String.valueOf(billingDate));
                            
                            billingDate = billingDate.addMonths(1);
                            System.debug('Data de faturamento: ' + billingDate);                                        
                            
                            if(vDataVencimentoTaxa == null){
                                vDataVencimentoTaxa = AsyncEnviaContractPlusAoSAP.getNextSpecificDayDate(Integer.valueOf(itemContrato.Contrato__r.DiaVencimento__c));
                                genContract.writeStringField('dueDateBase', String.valueOf(vDataVencimentoTaxa)); //Obrigatório Data de Vencimento(Verificar dia de Vencimento de jogar para o próximo mês)
                            } else {
                                vDataVencimentoTaxa = vDataVencimentoTaxa.addMonths(1);
                                genContract.writeStringField('dueDateBase', String.valueOf(vDataVencimentoTaxa)); //Obrigatório Data de Vencimento(Verificar dia de Vencimento de jogar para o próximo mês)
                            }
                            
                            genContract.writeStringField('birthdayDate', String.valueOf(itemContrato.Contrato__r.StartDate.addYears(1))); //Passar Data de 1 ano após a data de inicio do Contrato *Obrigatório
                            genContract.writeDateField('ReferenceDate', System.Today()); //Obrigatório
                            genContract.writeNumberField('inicialBalance', 0); //Chumbado
                            genContract.writeNumberField('usageId', 38); //Chumbado
                            genContract.writeStringField('measureUnitId', 'Und');
                            genContract.writeStringField('OcrCode', vCentroCusto);
                            genContract.writeStringField('OcrCode2', ''); //Chumbado
                            genContract.writeStringField('OcrCode3', ''); //Chumbado
                            genContract.writeStringField('OcrCode4', ''); //Chumbado
                            genContract.writeStringField('OcrCode5', ''); //Chumbado
                            genContract.writeStringField('whsCode', ''); //Chumbado
                            genContract.writeStringField('objectOfTheContract', ''); //Chumbado
                            genContract.writeNumberField('quotationLineNum', 0); //Chumbado
                            genContract.writeStringField('prjCode', ''); //Chumbado
                            genContract.writeNumberField('slpCode', 0);
                            genContract.writeNumberField('financialIndexId', 0); //Chumbado
                            genContract.writeNumberField('readjustmentValueType', 0); //Chumbado
                            genContract.writeNumberField('billingMonth', 0); //Chumbado
                            genContract.writeNumberField('billingDay', 0); //Chumbado
                            genContract.writeNumberField('measurementById', 1); //Chumbado
                            genContract.writeStringField('effectiveDate', String.valueOf(itemContrato.Contrato__r.StartDate)); //Confirmar campo correto
                            genContract.writeNumberField('saleReportValueSource', 0); //Chumbado
                            genContract.writeNumberField('saleRepRangeType', 0); //Chumbado
                            genContract.writeNumberField('saleReportValueBase', 0); //Chumbado
                            
                            genContract.writeFieldName('userFields');
                            
                            genContract.writeStartObject();
                            genContract.writeStringField('NumCircuito2', '');
                            genContract.writeStringField('Banda2', '');
                            genContract.writeStringField('TaxaInstalacao2', '');
                            genContract.writeStringField('FormaPagamento2', '');
                            genContract.writeStringField('CircEnderecoA', '');
                            genContract.writeStringField('CircEnderecoB', '');
                            genContract.writeEndObject();
                            
                            genContract.writeFieldName('apportionments');
                            genContract.writeStartArray();
                            genContract.writeEndArray();
                            genContract.writeFieldName('saleRepRanges');
                            genContract.writeStartArray();
                            genContract.writeEndArray();
                            
                            genContract.writeEndObject();       
                            System.debug('Iteração Quantidade Parcelas Taxa de Instalação: ' + i);
                        }
                        
                    }
                    
                    genContract.writeEndArray();                
                    genContract.writeFieldName('representatives');
                    genContract.writeStartArray();
                    genContract.writeEndArray();
                    genContract.writeEndObject();  
                    genContract.writeEndArray();
                    genContract.writeEndObject();  
                    
                    String jsonString = genContract.getAsString();
                    System.debug('jsonString: '+jsonString);
                    
                    String escapedContractJson1 = userFieldsContract.replaceAll('"', '\\\\"');
                    String vComAspas1 = escapedContractJson1.replace('{', '"{');
                    String vComAspas2 = vComAspas1.replace('}', '}"');
                    
                    String modifiedJsonString1 = jsonString.replace(userFieldsContract, vComAspas2);
                    
                    String escapedContractJson2 = userFieldsNumCircuito.replaceAll('"', '\\\\"');
                    String vComAspasNumCircuito = escapedContractJson2.replace('{', '"{');
                    String modifiedJsonString2 = modifiedJsonString1.replace(userFieldsNumCircuito, vComAspasNumCircuito);
                    
                    String escapedContractJson3 = userFieldsBanda.replaceAll('"', '\\\\"');
                    String modifiedJsonString3 = modifiedJsonString2.replace(userFieldsBanda, escapedContractJson3);
                    
                    String escapedContractJson4 = userFieldsTaxa.replaceAll('"', '\\\\"');
                    String modifiedJsonString4 = modifiedJsonString3.replace(userFieldsTaxa, escapedContractJson4);
                    
                    String escapedContractJson5 = userFieldsForma.replaceAll('"', '\\\\"');
                    String modifiedJsonString5 = modifiedJsonString4.replace(userFieldsForma, escapedContractJson5);
                    
                    String escapedContractJson6 = userFieldEndA.replaceAll('"', '\\\\"');
                    String modifiedJsonString6 = modifiedJsonString5.replace(userFieldEndA, escapedContractJson6);
                    
                    String escapedContractJson7 = userFieldEndB.replaceAll('"', '\\\\"');
                    String vComAspasEnd = escapedContractJson7.replace('}', '}"');
                    String modifiedJsonString7 = modifiedJsonString6.replace(userFieldEndB, vComAspasEnd);
                    
                    String modifiedJsonString8 = modifiedJsonString7.replaceAll('"userFields":\\{"NumCircuito2":"","Banda2":"","TaxaInstalacao2":"","FormaPagamento2":"","CircEnderecoA":"","CircEnderecoB":""\\}','"userFields":"{\\\\"NumCircuito2\\\\":\\\\"\\\\",\\\\"Banda2\\\\":\\\\"\\\\",\\\\"TaxaInstalacao2\\\\":\\\\"\\\\",\\\\"FormaPagamento2\\\\":\\\\"\\\\",\\\\"CircEnderecoA\\\\":\\\\"\\\\",\\\\"CircEnderecoB\\\\":\\\\"\\\\"}"');
                    
                    
                    //5ª Requisição: POST ContractPlus
                    if(Test.isRunningTest()){
                        responseBody = '{"Teste":"TESTE123"}';
                        HttpMock httpMock = new HttpMock(202, 'OK', responseBody, new Map<String,String>());
                        resUpsertContract = httpMock.respond(reqTest);
                    }else{
                        resUpsertContract = HttpUtils.getInstance().sendRequestContractPlus('POST', vEndpointContractPlus, modifiedJsonString8, 120000);
                        System.debug('resUpsertContract.getStatusCode ' + resUpsertContract.getStatusCode());    
                        System.debug('resUpsertContract.getbody() ' + resUpsertContract.getbody());      
                    }
                    
                    responseBody = resUpsertContract.getbody();
                    responseStatusCode = resUpsertContract.getStatusCode();
                    responseStatus = resUpsertContract.getStatus();
                    
                    if(responseStatusCode == 202){
                        
                        if(itemContrato.Contrato__r.Status == 'Esboço'){
                            Contract c = new Contract();
                            c.Id = itemContrato.Contrato__c;
                            c.EnviadoSAP__c = True;
                            c.Status = 'Autorizado';
                            c.Codigo_do_contrato__c = vNumeroUltimoContrato;
                            c.IdContractPlus__c = vIdContractPlus;
                            update c;
                        }
                        
                        if(itemContrato.Status__c == 'AGUARDANDO'){
                            Item_do_Contrato__c item = new Item_do_Contrato__c();
                            item.Id = itemContrato.Id;
                            item.Status__c = 'INICIADO';
                            item.Data_de_Inicio__c = Date.today();
                            item.Data_de_Termino__c = Date.today().addMonths(itemContrato.Contrato__r.ContractTerm);
                            item.Numero_do_circuito__c = vNumeroCircuito; 
                            item.NumeroItemContrato__c = vNumeroItem;
                            update item;            
                        }
                        //Sucesso ContractPlus
                        insert ControleDeServicoBO.getInstance().gerarLogPai('Sucesso', 'AsyncEnviaContractPlusAoSAP', 'POST - ItemId do ContractPlus: '+itemContrato.Id, modifiedJsonString8, responseBody, responseStatus, responseStatusCode, System.Now(), False);
                        
                    } else {
                        //Erro ContractPlus
                        insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsyncEnviaContractPlusAoSAP', 'POST - ItemId do ContractPlus: '+itemContrato.Id, modifiedJsonString8, responseBody, responseStatus, responseStatusCode, System.Now(), False);
                    }
                } else {
                    //Erro Arvore de Produtos
                    insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsyncEnviaContractPlusAoSAP', 'GET - Arvore de Produtos: '+itemContrato.Id, vEndpointArvoreProd, responseBodyArvore, responseStatusArvore, responseCodeArvore, System.Now(), False);
                }
                
            } else {
                //Erro Acesso Token
                insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsyncEnviaContractPlusAoSAP', 'POST - Acesso: '+itemContrato.Id, bodyJsonAcesso, responseBodyAcesso, responseStatusAcesso, responseCodeAcesso, System.Now(), False);
            }
        } catch (Exception e){
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'AsyncEnviaContractPlusAoSAP - ItemtId: '+itemContrato.Id, 'POST - ContractPlus SAP', 'Custom Exception Interno Salesforce: ' + e.getMessage() + ' Linha: '+e.getLineNumber()+' Tipo: '+e.getTypeName(), null, null, null, System.Now(), True);
        }
    }
    
    public static Date getNextSpecificDayDate(Integer dayOfMonth) {
        
        Date vToday = Date.today();
        Date futureDate = vToday.addDays(30);
        Integer futureMonth = futureDate.month();
        Integer futureYear = futureDate.year();
        
        // Se o dia fornecido já passou neste mês após adicionar 30 dias, move para o próximo mês
        if (futureDate.day() > dayOfMonth) {
            futureMonth++;
            if (futureMonth > 12) {
                futureMonth = 1;
                futureYear++;
            }
        }
        return Date.newInstance(futureYear, futureMonth, dayOfMonth);
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
    
    // Método para calcular a Data de Faturamento dos Itens com base na Data de Vencimento
    public static Date calculateBillingDate(Date dueDate) {
        Integer dueDay = dueDate.day(), billingDay;
        Date previousMonth = dueDate.addMonths(-1);
        
        if (dueDay >= 1 && dueDay <= 3) {
            billingDay = 13;
        } else if (dueDay >= 4 && dueDay <= 9) {
            billingDay = 16;
        } else if (dueDay >= 10 && dueDay <= 14) {
            billingDay = 21;
        } else if (dueDay >= 15 && dueDay <= 18) {
            billingDay = 26;
        } else if (dueDay >= 19 && dueDay <= 23) {
            billingDay = 1;
        } else if (dueDay >= 24 && dueDay <= 27) {
            billingDay = 6;
        } else if (dueDay >= 28 && dueDay <= 30) {
            billingDay = 11;
        } else {
            throw new IllegalArgumentException('Dia de vencimento inválido.');
        }
        
        // Verifica se o mês anterior tem o número de dias suficientes
        Integer daysInPreviousMonth = Date.daysInMonth(previousMonth.year(), previousMonth.month());
        Date calculatedBillingDate;
        
        if (billingDay > daysInPreviousMonth) {
            calculatedBillingDate = Date.newInstance(previousMonth.year(), previousMonth.month(), daysInPreviousMonth);
        } else {
            calculatedBillingDate = Date.newInstance(previousMonth.year(), previousMonth.month(), billingDay);
        }
        
        // Verifica se a data de faturamento calculada já passou (é anterior à data atual)
        Date vToday = System.Today();
        
        if (calculatedBillingDate < vToday) {
            // Ajusta a data de faturamento para o próximo mês
            system.debug('Entrou no cálculo para o próximo mês');
            Date nextMonth = vToday.addMonths(1);
            Integer daysInNextMonth = Date.daysInMonth(nextMonth.year(), nextMonth.month());
            
            // Verifica se o próximo mês tem o número de dias suficientes
            if (billingDay > daysInNextMonth) {
                return Date.newInstance(nextMonth.year(), nextMonth.month(), daysInNextMonth);
            } else {
                return Date.newInstance(nextMonth.year(), nextMonth.month(), billingDay);
            }
        }
        return calculatedBillingDate;
    }
    
}