global class BatchCriaItensContrato implements Database.Batchable<SObject>, Database.Stateful{
    
    public List<String> listQuery;
    
    public BatchCriaItensContrato(List<String> queryString1) {
        this.listQuery = queryString1;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String vIdOpp = listQuery[0];
        
        String queryString = 'Select Id, Quantity, Forma_de_pagamento_da_instalacao__c, Taxa_de_instalacao__c, OpportunityId, Opportunity.ContractId, Opportunity.AccountId, TipoFaturamento__c, Product2Id, Product2.Name, Product2.Family, TotalPrice, UnitPrice, Analise_de_viabilidade__c, Analise_de_viabilidade__r.Atendido_por_parceiro__c, Analise_de_viabilidade__r.Burst__c, Analise_de_viabilidade__r.Banda_Burst__c, Analise_de_viabilidade__r.Concentrador__c, Analise_de_viabilidade__r.NomeDaUnidadeDeOrigem__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c, Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.CEP_de_origem__c, Analise_de_viabilidade__r.Complemento_da_origem__c, Analise_de_viabilidade__r.Numero_de_origem__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, Analise_de_viabilidade__r.Observacoes_de_origem__c, Analise_de_viabilidade__r.LinkPontoDeReferenciaDeOrigem__c, Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Latitude__s, Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Longitude__s, Analise_de_viabilidade__r.NomeDaUnidadeDeDestino__c, Analise_de_viabilidade__r.Estado_de_destino__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_destino__c, Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Numero_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Observacoes_do_destino__c, Analise_de_viabilidade__r.LinkPontoDeReferenciaDeDestino__c, Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps_do_Destino__Latitude__s, Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps_do_Destino__Longitude__s FROM OpportunityLineItem WHERE OpportunityId =\''+vIdOpp+'\'';
        
        return Database.getQueryLocator(queryString);
    }
    
    public void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope) {
        String vIdItem = null;
        //Decimal maxNumeroItemContrato = null;
        
        try {
            
            for(OpportunityLineItem oli : scope) {
                
               /* List<AggregateResult> aggregateResults = [SELECT MAX(NumeroItemContrato__c) maxNumeroItemContrato FROM Item_do_Contrato__c WHERE Contrato__c = :oli.Opportunity.ContractId];
                maxNumeroItemContrato = (Decimal) aggregateResults[0].get('maxNumeroItemContrato');
                
                if(maxNumeroItemContrato == null){
                    maxNumeroItemContrato = 1;
                } else {
                    maxNumeroItemContrato++;
                }*/
                
                Item_do_Contrato__c item = new Item_do_Contrato__c();
                
                if(oli.Product2.Name.length() > 80) {
                    item.Name = oli.Product2.Name.substring(0, 80);
                } else {
                    item.Name = oli.Product2.Name;
                }
                
                item.TaxaInstalacao__c = oli.Taxa_de_instalacao__c;
                
                if(oli.Taxa_de_instalacao__c != null && oli.Taxa_de_instalacao__c > 0 && oli.Forma_de_pagamento_da_instalacao__c == null){
                    oli.Forma_de_pagamento_da_instalacao__c = '-1';
                    item.FormaPagamentoInstalacao__c = '-1';
                } else {
                    item.FormaPagamentoInstalacao__c = oli.Forma_de_pagamento_da_instalacao__c;
                }
                
                item.Quantidade__c = oli.Quantity;
                item.Produto__c = oli.Product2Id;
                item.Valor__c = oli.TotalPrice;
                item.ValorUnitario__c = oli.UnitPrice;
                //item.NumeroItemContrato__c = maxNumeroItemContrato;
                item.Status__c = 'AGUARDANDO';
                item.TipoFaturamento__c = oli.TipoFaturamento__c;
                item.Contrato__c = oli.Opportunity.ContractId;
                item.Conta__c = oli.Opportunity.AccountId;
                item.Oportunidade__c = oli.OpportunityId;
                item.Atendimento_por_parceiro__c = oli.Analise_de_viabilidade__r.Atendido_por_parceiro__c;
                item.Analise_de_Viabilidade__c = oli.Analise_de_viabilidade__c;
                item.Concentrador__c = oli.Analise_de_viabilidade__r.Concentrador__c;
                item.Banda__c = oli.Quantity;
                item.NomeDaUnidadeDeOrigem__c = oli.Analise_de_viabilidade__r.NomeDaUnidadeDeOrigem__c;
                item.Estado_de_origem__c = oli.Analise_de_viabilidade__r.Estado_de_origem__c;
                item.Cidade_de_origem__c = oli.Analise_de_viabilidade__r.Cidade_de_origem__c;
                item.Bairro_de_origem__c = oli.Analise_de_viabilidade__r.Bairro_de_origem__c;
                item.Tipo_de_logradouro_de_origem__c = oli.Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c;
                item.Rua_de_origem__c = oli.Analise_de_viabilidade__r.Rua_de_origem__c;
                item.Cep_de_origem__c = oli.Analise_de_viabilidade__r.CEP_de_origem__c;
                item.Complemento_de_origem__c = oli.Analise_de_viabilidade__r.Complemento_da_origem__c;
                item.Numero_de_origem__c = oli.Analise_de_viabilidade__r.Numero_de_origem__c;
                item.Ponto_de_referencia_de_origem__c = oli.Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c;
                item.Observacoes__c = oli.Analise_de_viabilidade__r.Observacoes_de_origem__c;
                item.LinkPontoDeReferenciaDeOrigem__c = oli.Analise_de_viabilidade__r.LinkPontoDeReferenciaDeOrigem__c;
                item.GeolocalizacaoGoogleMaps__Latitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Latitude__s;
                item.GeolocalizacaoGoogleMaps__Longitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Longitude__s;
                
                item.NomeDaUnidadeDeDestino__c = oli.Analise_de_viabilidade__r.NomeDaUnidadeDeDestino__c; 
                item.Estado_de_destino__c = oli.Analise_de_viabilidade__r.Estado_de_destino__c;
                item.Cidade_de_destino__c = oli.Analise_de_viabilidade__r.Cidade_de_destino__c;
                item.Bairro_de_destino__c = oli.Analise_de_viabilidade__r.Bairro_de_destino__c;
                item.Tipo_de_logradouro_de_destino__c = oli.Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c;
                item.Rua_de_destino__c = oli.Analise_de_viabilidade__r.Rua_de_destino__c;
                item.Cep_de_destino__c = oli.Analise_de_viabilidade__r.CEP_de_destino__c;
                item.Complemento_de_destino__c = oli.Analise_de_viabilidade__r.Complemento_do_destino__c;
                item.Numero_de_destino__c = oli.Analise_de_viabilidade__r.Numero_de_destino__c;
                item.Ponto_de_referencia_do_destino__c = oli.Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c;
                item.ObservacoesDoDestino__c = oli.Analise_de_viabilidade__r.Observacoes_do_destino__c;
                item.LinkPontoDeReferenciaDeDestino__c = oli.Analise_de_viabilidade__r.LinkPontoDeReferenciaDeDestino__c;
                item.GeolocalizacaoGoogleMapsDestino__Latitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps_do_Destino__Latitude__s;
                item.GeolocalizacaoGoogleMapsDestino__Longitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps_do_Destino__Longitude__s;  
                insert item;
                
                vIdItem = item.Id;
                
                //Atualizar o Produto da Opp e Analise de Viabilidade com o Item
                oli.Item_do_Contrato__c = vIdItem;
                
                if(oli.Analise_de_viabilidade__c != null){
                Analise_de_viabilidade__c av = new Analise_de_viabilidade__c();
                av.Id = oli.Analise_de_viabilidade__c;
                av.Circuito_Existente__c = vIdItem;
                update av;
                }
                
                //Criar uma OS Pai por Item de Contrato
                WorkOrder wo = new WorkOrder();
                wo.AccountId = oli.Opportunity.AccountId;
                wo.Contrato__c = oli.Opportunity.ContractId;
                wo.Circuito__c = vIdItem;
                wo.EnviarEmailDeBoasVindas__c = 'Não';
                wo.ParceiroDeUltimaMilha__c = oli.Analise_de_viabilidade__r.Atendido_por_parceiro__c;
                wo.AnaliseDeViabilidade__c = oli.Analise_de_viabilidade__c;
                wo.TipoDeOrdemDeServico__c = 'Implantação';
                
                //Catálogo de Preço: Equipamentos e Insumos
                String vIdPricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Equipamentos e Insumos'].Id;
                wo.Pricebook2Id = vIdPricebook; 
                system.debug('vIdPricebook: '+vIdPricebook);
                
                //Direito de Implantação Geral
                String vIdDireito = [SELECT Id FROM Entitlement WHERE Name = 'Implantação - Geral'].Id;
                wo.EntitlementId = vIdDireito;
                system.debug('vIdDireito: '+vIdDireito);                
                
                if(oli.Product2.Family == 'Conectividade'){
                    String vIdConectividade = [SELECT Id FROM WorkType WHERE Name = 'Controle geral da implantação Conectividade'].Id;
                    wo.WorkTypeId = vIdConectividade;
                    system.debug('vIdConectividade: '+vIdConectividade);
                } else {
                    String vIdSolucoesDigitais = [SELECT Id FROM WorkType WHERE Name = 'Controle geral da implantação Soluções Digitais'].Id;
                    wo.WorkTypeId = vIdSolucoesDigitais;
                    system.debug('vIdSolucoesDigitais: '+vIdSolucoesDigitais);
                }
                
                if(oli.Analise_de_viabilidade__r.Concentrador__c == True){
                    wo.NomeDaUnidade__c = oli.Analise_de_viabilidade__r.NomeDaUnidadeDeOrigem__c;
                    wo.Street = oli.Analise_de_viabilidade__r.Rua_de_origem__c +' - '+oli.Analise_de_viabilidade__r.Numero_de_origem__c;
                    wo.City = oli.Analise_de_viabilidade__r.Cidade_de_origem__c;
                    wo.State = oli.Analise_de_viabilidade__r.Estado_de_origem__c;
                    wo.PostalCode = oli.Analise_de_viabilidade__r.CEP_de_origem__c;
                    wo.Country = 'BR';
                    wo.Bairro__c = oli.Analise_de_viabilidade__r.Bairro_de_origem__c;
                    wo.ComplementoDoEndereco__c = oli.Analise_de_viabilidade__r.Complemento_da_origem__c;
                    wo.ReferenciaDoEndereco__c = oli.Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c;
                    wo.ObservacoesDoEndereco__c = oli.Analise_de_viabilidade__r.Observacoes_de_origem__c;
                    wo.LinkPontoDeReferenciaDoEndereco__c = oli.Analise_de_viabilidade__r.LinkPontoDeReferenciaDeOrigem__c;
                    wo.GeolocalizacaoGoogleMaps__Latitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Latitude__s;
                    wo.GeolocalizacaoGoogleMaps__Longitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Longitude__s;
                } else {
                    if(oli.Analise_de_viabilidade__r.Rua_de_destino__c != null && oli.Analise_de_viabilidade__r.CEP_de_destino__c != null){
                        wo.NomeDaUnidade__c = oli.Analise_de_viabilidade__r.NomeDaUnidadeDeDestino__c;
                        wo.Street = oli.Analise_de_viabilidade__r.Rua_de_destino__c +' - '+oli.Analise_de_viabilidade__r.Numero_de_destino__c;
                        wo.City = oli.Analise_de_viabilidade__r.Cidade_de_destino__c;
                        wo.State = oli.Analise_de_viabilidade__r.Estado_de_destino__c;
                        wo.PostalCode = oli.Analise_de_viabilidade__r.CEP_de_destino__c;
                        wo.Country = 'BR';
                        wo.Bairro__c = oli.Analise_de_viabilidade__r.Bairro_de_destino__c;
                        wo.ComplementoDoEndereco__c = oli.Analise_de_viabilidade__r.Complemento_do_destino__c;
                        wo.ReferenciaDoEndereco__c = oli.Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c;
                        wo.ObservacoesDoEndereco__c = oli.Analise_de_viabilidade__r.Observacoes_do_destino__c;
                        wo.LinkPontoDeReferenciaDoEndereco__c = oli.Analise_de_viabilidade__r.LinkPontoDeReferenciaDeDestino__c;
                        wo.GeolocalizacaoGoogleMaps__Latitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps_do_Destino__Latitude__s;
                        wo.GeolocalizacaoGoogleMaps__Longitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps_do_Destino__Longitude__s;
                        
                    } else {
                        wo.NomeDaUnidade__c = oli.Analise_de_viabilidade__r.NomeDaUnidadeDeOrigem__c;
                        wo.Street = oli.Analise_de_viabilidade__r.Rua_de_origem__c+' - '+oli.Analise_de_viabilidade__r.Numero_de_origem__c;
                        wo.City = oli.Analise_de_viabilidade__r.Cidade_de_origem__c;
                        wo.State = oli.Analise_de_viabilidade__r.Estado_de_origem__c;
                        wo.PostalCode = oli.Analise_de_viabilidade__r.CEP_de_origem__c;
                        wo.Country = 'BR';
                        wo.Bairro__c = oli.Analise_de_viabilidade__r.Bairro_de_origem__c;
                        wo.ComplementoDoEndereco__c = oli.Analise_de_viabilidade__r.Complemento_da_origem__c;
                        wo.ReferenciaDoEndereco__c = oli.Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c;
                        wo.ObservacoesDoEndereco__c = oli.Analise_de_viabilidade__r.Observacoes_de_origem__c;
                        wo.LinkPontoDeReferenciaDoEndereco__c = oli.Analise_de_viabilidade__r.LinkPontoDeReferenciaDeOrigem__c;
                        wo.GeolocalizacaoGoogleMaps__Latitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Latitude__s;
                        wo.GeolocalizacaoGoogleMaps__Longitude__s = oli.Analise_de_viabilidade__r.Geolocaliza_o_Google_Maps__Longitude__s;
                    }
                }
                insert wo;
            }
            update scope;
        }catch (Exception e){
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'BatchCriaItensContrato', 'Automação Criação Contrato', 'Custom Exception Interno Salesforce: ' + e.getMessage() + ' Linha: '+e.getLineNumber()+' Tipo: '+e.getTypeName(), null, null, null, System.Now(), True);
        }
    }
    
    public void finish(Database.BatchableContext BC) {
                
        //Linhas comentadas a partir de 10/01/2025, motivo inclusão do ContractPlus 
           /*    String vIdOpp = listQuery[0];
        List<String> queryString1 = new List<String>();
        String vIdContract = [SELECT ContractId FROM Opportunity WHERE Id =: vIdOpp].ContractId;
        
        Contract cct = new Contract();
        cct.Id = vIdContract;
        cct.Status = 'Autorizado';
        update cct;
        
        queryString1.add(vIdContract);
        
        BatchEnviaContratoAoSAP batch = new BatchEnviaContratoAoSAP(queryString1);
        Database.executeBatch(batch, 1);*/
    }
    
}