public class EnviarSAPCTRL  {

	@AuraEnabled
    public static List<OpportunityLineItem> listaProduto(String idOportunidade) {
		
		List<Analise_de_viabilidade__c> listAnalise = [SELECT Id FROM Analise_de_viabilidade__c Where Oportunidade__c =: idOportunidade];
		if(listAnalise.isEmpty()) throw new AuraHandledException( 'Não há produtos disponíveis');
		Set<String> setAV = new Set<String>(); 
		for(Analise_de_viabilidade__c av : listAnalise){
			setAV.add(av.Id);
		}
		
		List<Item_do_Contrato__c> itensExistentes = [Select Id, Analise_de_viabilidade__c FROM Item_do_Contrato__c where Analise_de_viabilidade__c IN:setAV];
		for(Item_do_Contrato__c ic : itensExistentes){
			if(setAV.contains(ic.Analise_de_viabilidade__c)) setAV.remove(ic.Analise_de_viabilidade__c);
		}

        List<OpportunityLineItem> listOli = [SELECT Id, Analise_de_viabilidade__c, Product2Id, Product2.Name, Product2.ProductCode, UnitPrice, OpportunityId, Opportunity.Amount  FROM OpportunityLineItem WHERE Analise_de_viabilidade__c IN:setAV];
    
		system.debug(listOli.size());
		return listOli;
	}
			
	@AuraEnabled
	public static void getEnvioSAPCliente (String accId, String TipoChamada){

		List<Profile> perfis = [Select Id FROM Profile Where Name='Administrador do Sistema' OR Name='Faturamento'];  
		Id profileId = UserInfo.getProfileId();
		
		if(perfis.get(0).Id != profileId && perfis.get(1).Id != profileId) throw new AuraHandledException('Apenas usuários do perfil Faturamento podem executar está ação.');

		Account conta = [SELECT Id, Name, Type,  Grupo__c, OwnerId, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, 
									BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, 
									ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, Phone, AccountSource, CNPJ__c, Razao_Social__c, Nome_Fantasia__c, Capital_Social__c, 
									Natureza_Juridica__c, Data_de_Abertura__c, Situacao_RFB__c, Tipo_RFB__c, Inscricao_Estadual__c, Data_da_Situacao_Sintegra__c, Situacao_Sintegra__c, 
									Regime_de_Tributacao__c, Bairro__c, Complemento_de_cobranca__c, Numero_de_cobranca__c, CNAE_Principal__c, Porte_da_Empresa__c, Inscricao_municipal__c, 
									Descricao_das_Atividades__c, Geolocalizacao__Latitude__s, Geolocalizacao__Longitude__s, Geolocalizacao__c, Bairro_de_cobranca__c, Numero_de_entrega__c, 
									Bairro_de_entrega__c, Complemento_de_entrega__c, Owner.Codigo_do_vendedor__c, Owner.Email, Email__c, Tipo_de_logradouro_cobranca__c, Tipo_de_logradouro_entrega__c, 
									codigo_SAP_cliente__c, codigo_SAP_cobranca__c,  codigo_SAP_envio__c, Codigo_SAP_parceiro__c
									FROM Account WHERE Id =: accId];
		
		if(conta.grupo__c==null) throw new AuraHandledException('O preenchimento do campo grupo é obrigátorio.');
		
		List<Contact> contato = [SELECT Id, AccountId, LastName, FirstName, Salutation, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude, 
									MailingGeocodeAccuracy, MailingAddress, Phone, Fax, MobilePhone, Email, Title, Department,  Poder_de_Decisao__c, Percepcao_de_interesse__c, codigo_SAP_contato__c
									FROM Contact WHERE AccountId =: accId AND Email != NULL LIMIT 1];
		if(contato.isEmpty()){
			throw new AuraHandledException('Não há contatos com emails disponíveis.');
		}
		String codClienteParceiro;
		if((String.isBlank(conta.Codigo_SAP_cliente__c) && TipoChamada=='C') || (String.isBlank(conta.Codigo_SAP_parceiro__c) && TipoChamada=='F')){
			IntegrationModels.ClienteResponse cliente = IntegrationServices.EnviarSAPServiceCliente(conta, TipoChamada);
            system.debug('>>>>> '+ cliente);
            if(String.isNotBlank(cliente.codigo)){  
				if(TipoChamada=='C'){
					conta.Codigo_SAP_cliente__c = cliente.codigo;
				}else if(TipoChamada=='F'){
					conta.Codigo_SAP_parceiro__c = cliente.codigo;
				}
				codClienteParceiro = cliente.codigo;
            }else{
                if(cliente.error_description.containsIgnoreCase('Já existe um cliente com esse CNPJ cadastrado')){
					system.debug('>>>>> '+cliente.error_description.substringBetween('(',')'));
					if(TipoChamada=='C'){
						conta.Codigo_SAP_cliente__c = cliente.error_description.substringBetween('(',')');
					}else if(TipoChamada=='F'){
						conta.Codigo_SAP_parceiro__c = cliente.error_description.substringBetween('(',')');
					}
					codClienteParceiro = cliente.error_description.substringBetween('(',')');
                }else{
                    throw new AuraHandledException(cliente.error_description);
                }
            }
		}
		try{
			
			if(String.isBlank(conta.Codigo_SAP_envio__c)){
				IntegrationModels.ClienteResponse envio = IntegrationServices.EnviarSAPServiceEndereco(conta,'ENVIO',codClienteParceiro);
				conta.Codigo_SAP_envio__c = envio.codigo;
			}

			if(String.isBlank(conta.Codigo_SAP_cobranca__c)){
				IntegrationModels.ClienteResponse cobranca = IntegrationServices.EnviarSAPServiceEndereco(conta,'COBRANÇA',codClienteParceiro);
				conta.Codigo_SAP_cobranca__c = cobranca.codigo;
			}

			if(String.isBlank(contato.get(0).codigo_SAP_contato__c)){
				IntegrationModels.ClienteResponse contatoSAP = IntegrationServices.EnviarSAPServiceContato(contato.get(0),codClienteParceiro);
				if(String.isNotBlank(contatoSAP.codigo)){  
					contato.get(0).codigo_SAP_contato__c = contatoSAP.codigo;
				}else{
					if(contatoSAP.error_description.containsIgnoreCase('Já existe um contato cadastrado com esse nome')){
						system.debug('>>>>> '+contatoSAP.error_description.substringBetween('(',')'));
						contato.get(0).codigo_SAP_contato__c = contatoSAP.error_description.substringBetween('(',')');
					}else{
						throw new AuraHandledException(contatoSAP.error_description);
					}
				}
				update contato;
			}
			
			update conta;
		}catch(Exception ex){
			throw new AuraHandledException('Erro: '+ex.getMessage()+' Linha:'+ex.getLineNumber());
		}
	}

	@AuraEnabled
	public static void getEnvioSAPContrato (String oppId, String IdOlis){

		List<Profile> perfis = [Select Id FROM Profile Where Name='Administrador do Sistema' OR Name='Faturamento'];  
		Id profileId = UserInfo.getProfileId();
		
		if(perfis.get(0).Id != profileId && perfis.get(1).Id != profileId) throw new AuraHandledException('Apenas usuários do perfil Faturamento podem executar está ação.');

		List<Opportunity> opps = [SELECT Id, StageName, ContractId, Contract.Codigo_do_contrato__c, Account.Name, Account.Codigo_SAP_cliente__c, AccountId, Dia_do_vencimento__c, Permuta__c, Cortesia__c,CloseDate,
									Meses__c, Description
							FROM Opportunity WHERE Id =: oppId AND StageName =: 'Fechado Ganho' ORDER BY CreatedDate ASC LIMIT 1];
		
		if(opps.isEmpty())	throw new AuraHandledException('Essa oportunidade pode apenas ser enviada ao SAP na fase Fechado Ganho.');

		List<String> idProdOpp = (List<String>) JSON.deserialize(IdOlis, List<String>.class);
		system.debug(idProdOpp);
		if(idProdOpp.isEmpty()) throw new AuraHandledException('Você precisa selecionar ao menos um produto para gerar um item do contrato.');
		
		Opportunity opp = opps.get(0);

		Map<Id,Analise_de_viabilidade__c> analises = new Map<Id,Analise_de_viabilidade__c>();
		
		List<OpportunityLineItem> listOli = [Select Id, quantity, Acao_contratual__c, Numero_de_Circuito__c, Opportunity.Dia_do_vencimento__c, UnitPrice, Product2.Name, OpportunityId, Opportunity.AccountId, TotalPrice, ProductCode, Analise_de_viabilidade__c, Analise_de_viabilidade__r.RecordTypeId, Analise_de_viabilidade__r.Name, 
												Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_origem__c, Analise_de_viabilidade__r.CEP_de_destino__c, Analise_de_viabilidade__r.Numero_de_destino__c, 
												Analise_de_viabilidade__r.Data_da_conclusao__c, Analise_de_viabilidade__r.Qtd_Itens_Aprovacao__c, Analise_de_viabilidade__r.RecordType.Name, Analise_de_viabilidade__r.Complemento_da_origem__c, Analise_de_viabilidade__r.Numero_de_origem__c,
												Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Estado_de_destino__c, 
												Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, 
												Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Status__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c,
												Analise_de_viabilidade__r.Redundancia__c, Analise_de_viabilidade__r.Bloco_de_Ips__c, Analise_de_viabilidade__r.Tipo_de_atendimento__c, Analise_de_viabilidade__r.Burst__c, Analise_de_viabilidade__r.Cliente_final__c, 
												Analise_de_viabilidade__r.Quantidade_de_Ips__c, Analise_de_viabilidade__r.Atendido_por_parceiro__r.Codigo_SAP_cliente__c, Taxa_de_instalacao__c, Forma_de_pagamento_da_instalacao__c, Taxa_de_Burst__c, Banda_burst__c, 
												Analise_de_viabilidade__r.Atendido_por_parceiro__r.Codigo_SAP_parceiro__c
												FROM OpportunityLineItem WHERE Id IN: idProdOpp];
		system.debug('Aqui >>>> '+listOli.size());
		system.debug('>>>>'+listOli);
		//Adiciono os itens a um mapa com chave da analise
		/*List<Item_do_contrato__c> listItens = [Select Id, Analise_de_viabilidade__c, contrato__c FROM Item_do_contrato__c where Oportunidade__c =: oppId];
		Map<String,Item_do_contrato__c> mapItens = new Map<String,Item_do_contrato__c>();
		for(Item_do_contrato__c it : listItens){
			mapItens.put(it.Analise_de_viabilidade__c,it);
		}*/

		//Map<String,List<OpportunityLineItem>> mapListOli = new Map<String,List<OpportunityLineItem>>();
		//Set<String> KeyMapContratos = new Set<String>();
		for (OpportunityLineItem oli :listOli){
			system.debug(oli.Analise_de_viabilidade__c);
			system.debug(oli.Analise_de_viabilidade__r.Status__c);
			system.debug(oli.Analise_de_viabilidade__r.RecordType.Name);
			if(oli.Analise_de_viabilidade__c != null && oli.Analise_de_viabilidade__r.Status__c=='Concluída' && oli.Analise_de_viabilidade__r.RecordType.Name =='Concluída'){
				analises.put(oli.Id,oli.Analise_de_viabilidade__r);
			} else{
				throw new AuraHandledException('Precisa ter uma análise de viabilidade com Status concluída e Tipo de Registro Concluída.');
			}
			//Adiciono o contrato com os oli
			/*if(mapItens.containsKey(oli.Analise_de_viabilidade__c)){
				if(!mapListOli.containsKey(mapItens.get(oli.Analise_de_viabilidade__c).Contrato__c)){
					mapListOli.put(mapItens.get(oli.Analise_de_viabilidade__c).Contrato__c, New List<OpportunityLineItem>());
				}
				mapListOli.get(mapItens.get(oli.Analise_de_viabilidade__c).Contrato__c).add(oli);
				KeyMapContratos.add(mapItens.get(oli.Analise_de_viabilidade__c).Contrato__c);
			}*/
		}
		Map<String,String> mapItemAtualizar = new Map<String,String>();

		/*for(String keyContrato : KeyMapContratos){
			System.debug(analises);
			try{
				IntegrationModels.ClienteResponse ContratoResponse = IntegrationServices.EnviarSAPServiceOportunidade(opp.get(0),mapListOli.get(keyContrato),analises);
				if(ContratoResponse != null){
					for(IntegrationModels.ItensResponse icr : ContratoResponse.itens){
						mapItemAtualizar.put(icr.sales_item,icr.circuito); 
					}
				}
			}catch(Exception ex){
				throw new AuraHandledException('Erro: '+ex.getMessage()+' Linha:'+ex.getLineNumber());
			}
		}*/

		//for(Item_do_contrato__c item : mapItens.values()){
		//	item.Numero_do_circuito__c = mapItemAtualizar.get(item.Analise_de_viabilidade__c);
		//}
		//update mapItens.values();
		IntegrationModels.ClienteResponse ContratoResponse = IntegrationServices.EnviarSAPServiceOportunidade(opp,listOli,analises);
		if(ContratoResponse != null){
			mapItemAtualizar.put('CODIGO_CONTRATO',ContratoResponse.contrato);
			for(IntegrationModels.ItensResponse icr : ContratoResponse.itens){
				mapItemAtualizar.put(icr.sales_item,icr.circuito); 
			}
		}

		try{
			criarContrato(opp,listOli,mapItemAtualizar);
		}catch(Exception ex){
			throw new AuraHandledException('Erro: '+ex.getMessage()+' Linha: '+ex.getLineNumber());
		}
	}

	/*@AuraEnabled
	public static void criarContrato(String oppId, String IdOlis){*/
	public static void criarContrato(Opportunity opp, List<OpportunityLineItem> listOli,Map<String, String> mapItemAtualizar){

		// Quando for realiza a criação do  contratro na fase de contrato descomentar essa parte
		/*List<Opportunity> opps = [SELECT Id, StageName, Account.Name, Account.Codigo_SAP_cliente__c, AccountId, Dia_do_vencimento__c, Permuta__c, Cortesia__c,CloseDate,
									Meses__c, Description
							FROM Opportunity WHERE Id =: oppId AND StageName =: 'Contrato' ORDER BY CreatedDate ASC LIMIT 1];
		
		if(opps.isEmpty()){
			throw new AuraHandledException('O contrato só pode ser criado na fase de contrato.');
		}
		List<String> idProdOpp = (List<String>) JSON.deserialize(IdOlis, List<String>.class);
		system.debug(idProdOpp);
		if(idProdOpp.isEmpty()){
			throw new AuraHandledException('Você precisa selecionar ao menos um produto para gerar um item do contrato.');
		}
		Opportunity opp = opps.get(0);

		system.debug(idProdOpp);
		List<OpportunityLineItem> listOli = [Select Id, quantity, Acao_contratual__c, Opportunity.Dia_do_vencimento__c, UnitPrice, Product2.Name, OpportunityId, Opportunity.AccountId, TotalPrice, ProductCode, Analise_de_viabilidade__c, Analise_de_viabilidade__r.RecordTypeId, Analise_de_viabilidade__r.Name, 
												Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_origem__c, Analise_de_viabilidade__r.CEP_de_destino__c, Analise_de_viabilidade__r.Numero_de_destino__c, 
												Analise_de_viabilidade__r.Data_da_conclusao__c, Analise_de_viabilidade__r.Qtd_Itens_Aprovacao__c, Analise_de_viabilidade__r.RecordType.Name, Analise_de_viabilidade__r.Complemento_da_origem__c, Analise_de_viabilidade__r.Numero_de_origem__c,
												Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Estado_de_destino__c, 
												Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, 
												Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Status__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c,
												Analise_de_viabilidade__r.Redundancia__c, Analise_de_viabilidade__r.Bloco_de_Ips__c, Analise_de_viabilidade__r.Tipo_de_atendimento__c, Analise_de_viabilidade__r.Burst__c, Analise_de_viabilidade__r.Cliente_final__c, 
												Analise_de_viabilidade__r.Quantidade_de_Ips__c, Analise_de_viabilidade__r.Atendido_por_parceiro__r.Codigo_SAP_cliente__c, Taxa_de_instalacao__c, Forma_de_pagamento_da_instalacao__c, Taxa_de_Burst__c, Banda_burst__c,
												Analise_de_viabilidade__r.Atendido_por_parceiro__c
												FROM OpportunityLineItem WHERE Id IN: idProdOpp];*/
		system.debug('Aqui >>>> '+listOli.size());
		system.debug('>>>>'+listOli);

		Contract contrato = new Contract();
		if(opp.ContractId == null){			
			contrato.AccountId = opp.AccountId;
			contrato.ContractTerm = Integer.valueOf(opp.Meses__c);
			contrato.StartDate = opp.CloseDate;
			contrato.Status = 'Esboço';
			contrato.Oportunidade__C = opp.Id;
			contrato.Cortesia__c = opp.Cortesia__c;
			contrato.Permuta__c = opp.Permuta__c;
			contrato.Codigo_do_contrato__c = mapItemAtualizar.get('CODIGO_CONTRATO');
			insert contrato;
		} else {
			contrato.Id = opp.ContractId;
			contrato.Status = 'Esboço';
		} 

		List<Item_do_Contrato__c> listItensContratoExistentes = [SELECT Numero_do_circuito__c, Item_Antigo__c FROM Item_do_Contrato__c WHERE Contrato__c = :contrato.Id];		
		List<Item_do_Contrato__c> listItensContratoAlterados = new List<Item_do_Contrato__c>();

		List<Item_do_Contrato__c> listItensContrato = new List<Item_do_Contrato__c>();
		for(OpportunityLineItem oli : listOli){
			if(listItensContratoExistentes.size() > 0){
				for(Item_do_Contrato__c itemExistente : listItensContratoExistentes){
					if(oli.Numero_de_Circuito__c == itemExistente.Numero_do_circuito__c){
						itemExistente.Status__c = 'FECHADO';
						itemExistente.Item_Antigo__c = true;
						listItensContratoAlterados.add(itemExistente);
					}
				}
			}			
			Item_do_Contrato__c item = new Item_do_Contrato__c();
			system.debug('analise >>>'+oli.Analise_de_viabilidade__c);
			item.Analise_de_Viabilidade__c = oli.Analise_de_viabilidade__c;
			item.Name =  oli.Product2.Name;
			item.Oportunidade__c = oli.OpportunityId;
			item.Produto__c = oli.Product2Id;
			item.Numero_do_circuito__c = mapItemAtualizar.get(oli.Analise_de_viabilidade__r.Name);
			item.Conta__c = oli.Opportunity.AccountId;
			system.debug('contrato >>>'+contrato.Id);
			item.Contrato__c = contrato.Id;
			item.Banda__c = oli.Quantity;
			item.Valor__c = oli.TotalPrice;
			item.Ultima_acao_contratual__c = oli.Acao_contratual__c;
			item.Dia_de_Vencimento__c = String.valueOf(oli.Opportunity.Dia_do_vencimento__c);
			item.Status__c = 'AGUARDANDO';
			item.Tipo_de_logradouro_de_origem__c = oli.Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c;
			item.numero_de_origem__c = oli.Analise_de_viabilidade__r.numero_de_origem__c;
			item.Rua_de_origem__c = oli.Analise_de_viabilidade__r.Rua_de_origem__c;
			item.Estado_de_origem__c = oli.Analise_de_viabilidade__r.Estado_de_origem__c;
			item.Complemento_de_origem__c = oli.Analise_de_viabilidade__r.Complemento_da_origem__c;
			item.Cidade_de_origem__c = oli.Analise_de_viabilidade__r.Cidade_de_origem__c;
			item.CEP_de_origem__c = oli.Analise_de_viabilidade__r.CEP_de_origem__c;
			item.Bairro_de_origem__c = oli.Analise_de_viabilidade__r.Bairro_de_origem__c;
			item.Tipo_de_logradouro_de_destino__c = oli.Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c;
			item.numero_de_destino__c = oli.Analise_de_viabilidade__r.numero_de_destino__c;
			item.Rua_de_destino__c = oli.Analise_de_viabilidade__r.Rua_de_destino__c;
			item.Estado_de_destino__c = oli.Analise_de_viabilidade__r.Estado_de_destino__c;
			item.Complemento_de_destino__c = oli.Analise_de_viabilidade__r.Complemento_do_destino__c;
			item.Cidade_de_destino__c = oli.Analise_de_viabilidade__r.Cidade_de_destino__c;
			item.CEP_de_destino__c = oli.Analise_de_viabilidade__r.CEP_de_destino__c;
			item.Bairro_de_destino__c = oli.Analise_de_viabilidade__r.Bairro_de_destino__c;	
			item.Atendimento_por_parceiro__c = oli.Analise_de_viabilidade__r.Atendido_por_parceiro__c;
			item.Item_Antigo__c = false;
			//criar campos no item para

			//Adicionar campos novos da analise e do produto da oportunidade
			listItensContrato.add(item);
		}

		if(listItensContrato.size()>0) insert listItensContrato;
		if(listItensContratoAlterados.size() > 0) update listItensContratoAlterados;
	}
}