public class OpportunityTriggerHandler {
    
	public static void atualizarProdutoDaOportunidade() {
        List<Opportunity> listOpp = (List<Opportunity>) Trigger.new;
		Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
		Set<String> idSet = new Set<String>();
		for(Opportunity opp : listOpp){
			if(opp.StageName == 'Viabilidade' && oldMapOpp.get(opp.Id).StageName != 'Viabilidade' ){
				idSet.add(opp.id); 
			}
        }

        if(idSet.size()>0){
			List<OpportunityLineItem> oliList = [Select Id, UnitPrice, Name, TotalPrice, Quantity, Taxa_de_instalacao__c, Analise_de_viabilidade__c, Analise_de_viabilidade__r.Status__c, Product2.Viabilidade__c, Product2.Name, Product2.Taxa_de_instalacao__c, Opportunity.Name, OpportunityId, Product2Id From OpportunityLineItem Where OpportunityId IN :idSet AND Product2.Viabilidade__c =: true];
			Id registroAnaliseLink = Schema.SObjectType.Analise_de_viabilidade__c.getRecordTypeInfosByDeveloperName().get('Link').getRecordTypeId();
			Id registroAnaliseLan = Schema.SObjectType.Analise_de_viabilidade__c.getRecordTypeInfosByDeveloperName().get('Lan_to_Lan_L2L').getRecordTypeId();
			List<OpportunityLineItem> olisAtualizar = new List<OpportunityLineItem>();
			Map<Id,Analise_de_viabilidade__c> mapOliAnalise = new Map<Id,Analise_de_viabilidade__c>();
			
			for(OpportunityLineItem oli : oliList){
				if(oli.Analise_de_viabilidade__c == Null || (oli.Analise_de_viabilidade__c != null && ('Vencida, Cancelada').contains(oli.Analise_de_viabilidade__r.Status__c))){
					Analise_de_viabilidade__c analise = new Analise_de_viabilidade__c();
					analise.Tipo_de_link__c = oli.Name;
					analise.Status__c = 'Aberta';
					analise.Oportunidade__c = oli.OpportunityId;
					analise.RecordTypeId = ((oli.Product2.Name).containsIgnoreCase('Link') ? registroAnaliseLink : registroAnaliseLan);
                    analise.Produto_de_oportunidade__c = oli.Id;
					mapOliAnalise.put(oli.Id,analise);
				}
			}
			System.debug('size>> '+mapOliAnalise.size());
			if(mapOliAnalise.size()>0) insert mapOliAnalise.values();

			for(OpportunityLineItem oli : oliList){
				if(mapOliAnalise.containsKey(oli.Id)){
					System.debug('mapOliAnalise.get(oli.Id).Id'+mapOliAnalise.get(oli.Id).Id);
					oli.Analise_de_viabilidade__c = mapOliAnalise.get(oli.Id).Id;
					olisAtualizar.add(oli); 
				}
			}

			update olisAtualizar;
		}
    }
	
	public static void calculaCapexGeralOportunidade() {
        List<Opportunity> listOpp = (List<Opportunity>) Trigger.new;
		Map<Id,List<OpportunityLineItem>> mapOli = new Map<Id,List<OpportunityLineItem>>();
		Set<String> idSet = new Set<String>();
		
		for(Opportunity opp : listOpp){
			idSet.add(opp.id);
        }

		List<OpportunityLineItem> oliList = [Select Id, UnitPrice, Retorno__c, Name, Quantity, Taxa_de_instalacao__c, OpportunityId, Product2Id, TotalPrice From OpportunityLineItem Where OpportunityId IN :idSet];
		if(oliList.size()>0){
			for(OpportunityLineItem oli : oliList){
				if(!mapOli.containsKey(oli.OpportunityId)){
					mapOli.put(oli.OpportunityId, new List<OpportunityLineItem>());
				}
				mapOli.get(oli.OpportunityId).add(oli); 
			}
		}

		for(Opportunity opp : listOpp){
			opp.Amount = 0;
			if(mapOli.containsKey(opp.Id) && mapOli.get(opp.Id).size()>0){
				for(OpportunityLineItem oli : mapOli.get(opp.Id)){
					opp.Amount = opp.Amount + oli.TotalPrice;
				}
			}
			opp.Valor_da_mensalidade__c = opp.Amount;
		}
    }
	
	public static void validarAnalise() {
        List<Opportunity> listOpp = (List<Opportunity>) Trigger.new;
		Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
		Set<String> idSet = new Set<String>();

		for(Opportunity opp : listOpp){
			if(!opp.by_pass__c && opp.StageName != 'Viabilidade' && oldMapOpp.get(opp.Id).StageName == 'Viabilidade' ){
				idSet.add(opp.id);
    		}
        }

		if(!idSet.isEmpty()){
			Map<Id,List<Analise_de_viabilidade__c>> mapIndices = new Map<Id,List<Analise_de_viabilidade__c>>();
			Map<Id,List<Analise_de_viabilidade__c>> mapVencidas = new Map<Id,List<Analise_de_viabilidade__c>>();
			List<Analise_de_viabilidade__c> listAnalises = [Select Id, Status__c, Oportunidade__c, Data_da_conclusao__c FROM Analise_de_viabilidade__c Where Oportunidade__c IN :idSet AND RecordType.DeveloperName!= 'Desativado'];
			Indicador_de_tempo__c indicaTempo = Indicador_de_tempo__c.getValues('Sinal');
			Set<String> idAnalises = new Set<String>();

			if(listAnalises.size()>0){
				for(Analise_de_viabilidade__c analise : listAnalises){
					if(analise.Status__c!= 'Concluída'){
						if(!mapIndices.containsKey(analise.Oportunidade__c)){
							mapIndices.put(analise.Oportunidade__c, new List<Analise_de_viabilidade__c>());	
						}
						mapIndices.get(analise.Oportunidade__c).add(analise);
					}else if(analise.Status__c== 'Concluída'){
						if(analise.Data_da_conclusao__c > Date.today().addDays(Integer.valueOf(indicaTempo.Dias__c))){ 
							if(!mapVencidas.containsKey(analise.Oportunidade__c)){
								mapVencidas.put(analise.Oportunidade__c, new List<Analise_de_viabilidade__c>());	
							}
							mapVencidas.get(analise.Oportunidade__c).add(analise);
							idAnalises.add(analise.Id);
						}
					}
				}
			}

			if(idAnalises.size()>0){
				atualizaRecordTypeItensAnalisesFuture(idAnalises, 'Vencida');
			}

			for(Opportunity opp : listOpp){
				if(mapIndices.containsKey(opp.Id) && opp.StageName != 'Fechado Perdido'){
					opp.addError('Essa oportunidade possui ainda análises de viabilidade em aberto: '+mapIndices.get(opp.Id).size());
				}

				if(mapVencidas.containsKey(opp.Id) && opp.StageName != 'Fechado Perdido'){
					opp.addError('Essa oportunidade possui análises com data de conclusão vencidas. Por favor, refaça as análises');
				}
			}
		}
    }
	
	public static void cancelaAnalises(){

		List<Opportunity> listOpp = (List<Opportunity>) Trigger.new;
		Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
		Set<String> idSet = new Set<String>();

		for(Opportunity opp : listOpp){
			if(opp.by_pass__c && !oldMapOpp.get(opp.Id).by_pass__c){
				idSet.add(opp.id);
    		}
        }

		if(!idSet.isEmpty()){
			List<Analise_de_viabilidade__c> listAnalises = [Select Id, Status__c, Oportunidade__c, Data_da_conclusao__c FROM Analise_de_viabilidade__c Where Oportunidade__c IN :idSet AND RecordType.DeveloperName!= 'Desativado'];
			Set<String> idAnalises = new Set<String>();
			
			if(listAnalises.size()>0){
				for(Analise_de_viabilidade__c analise : listAnalises){
					idAnalises.add(analise.Id);
				}

				if(idAnalises.size()>0){
					atualizaRecordTypeItensAnalises(idAnalises, 'Cancelada');
				}
			}
		}
	}

	@Future
	private static void	atualizaRecordTypeItensAnalisesFuture(Set<String> idAnalises, String value){
		atualizaRecordTypeItensAnalises(idAnalises,value);
	}

	
	private static void	atualizaRecordTypeItensAnalises(Set<String> idAnalises, String value){
		
		List<Item_da_viabilidade__c> listItens = [Select Id, RecordTypeId FROM Item_da_viabilidade__c WHERE Analise_de_Viabilidade__c IN:idAnalises];
		if(listItens.size()>0){
			for(Item_da_viabilidade__c itemViab : listItens){
				itemViab.RecordTypeId = Schema.SObjectType.Item_da_viabilidade__c.getRecordTypeInfosByDeveloperName().get('Concluida').getRecordTypeId();
			}
			Database.update(listItens, false);
		}

		List<Analise_de_viabilidade__c> listAnalises =[Select Id, RecordTypeId FROM Analise_de_viabilidade__c WHERE Id IN:idAnalises];
		if(listAnalises.size()>0){
			Id recordTypeDesativado = Schema.SObjectType.Analise_de_viabilidade__c.getRecordTypeInfosByDeveloperName().get('Desativado').getRecordTypeId();
			for(Analise_de_viabilidade__c av : listAnalises){
				av.RecordTypeId = recordTypeDesativado;
				av.Status__c = value;
			}
			Database.update(listAnalises,false);
		}
	}

	/*public static void validaFaseItemContrato(){
		Map<Id,Opportunity> mapOpp = (Map<Id,Opportunity>) Trigger.newMap;
		Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
		Set<String> setIdOpps = new Set<String>();

		for(Opportunity opp : mapOpp.values()){
			if(oldMapOpp.get(opp.Id).StageName == 'Contrato' && opp.StageName == 'Validação Jurídico'){
				setIdOpps.add(opp.Id);
			}
		}
		system.debug(setIdOpps);
		if(!setIdOpps.isEmpty()){
			List<OpportunityLineItem> listProduto = [Select Id, Analise_de_viabilidade__c, OpportunityId FROM OpportunityLineItem where OpportunityId IN: setIdOpps];
			Map<String,String> mapOli = new Map<String,String>();
			for(OpportunityLineItem oli : listProduto){
				if(oli.Analise_de_viabilidade__c != null) mapOli.put(oli.Analise_de_viabilidade__c, oli.OpportunityId);
			}
			
			List<Item_do_contrato__c> listItemContrato = [Select Id, Analise_de_viabilidade__c, oportunidade__c FROM Item_do_contrato__c where oportunidade__c IN: setIdOpps AND Status__c != 'Cancelado'];
			Map<String, String> mapItens = new Map<String, String>();
			for(Item_do_contrato__c item : listItemContrato){
				mapItens.put(item.Analise_de_viabilidade__c,item.oportunidade__c);
			}
			
			for(String keyS : mapOli.keySet()){
				if(!mapItens.containsKey(keyS)) mapOpp.get(mapOli.get(keyS)).addError('Há itens que estão disponível para efetuar geração de contrato');
			}
		}
	}*/

	//public static void criarContrato(){

		/*List<Opportunity> listOpp = (List<Opportunity>) Trigger.new;
		Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
		Map<Id,Contract> mapContract = new Map<Id,Contract>();
		Set<Id> idOpp = new Set<Id>();*/

		/*for(Opportunity opp : listOpp){
			if(oldMapOpp.get(opp.Id).StageName == 'Negociação de valores' && opp.StageName == 'Contrato'){
				System.debug('Entrou');
				Contract contrato = new Contract();
				contrato.AccountId = opp.AccountId;
				contrato.ContractTerm = Integer.valueOf(opp.Meses__c);
				contrato.StartDate = opp.CloseDate;
				contrato.Status = 'Esboço';
				contrato.Oportunidade__C = opp.Id;
				contrato.Cortesia__c = opp.Cortesia__c;
				contrato.Permuta__c = opp.Permuta__c;
				mapContract.put(opp.Id,contrato);
    		}
        }
		System.debug('mapContract>> '+mapContract.size());
		if(mapContract.size()>0){
			insert mapContract.values();
		
			List<OpportunityLineItem> listOli = [Select Id, TotalPrice, OpportunityId, Quantity, Analise_de_viabilidade__c, Product2Id, Product2.Name, Banda_Mbps__c, UnitPrice, Acao_contratual__c, Analise_de_viabilidade__r.CEP_de_destino__c, Opportunity.Dia_do_vencimento__c,
														Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_origem__c, Analise_de_viabilidade__r.Numero_de_origem__c,Analise_de_viabilidade__r.Numero_de_destino__c,
													Analise_de_viabilidade__r.Data_da_conclusao__c, Analise_de_viabilidade__r.Qtd_Itens_Aprovacao__c, Analise_de_viabilidade__r.RecordType.Name, Analise_de_viabilidade__r.Complemento_da_origem__c, 
													Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Estado_de_destino__c, 
													Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, 
													Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Status__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c, Opportunity.AccountId 
													FROM OpportunityLineItem WHERE OpportunityId IN: mapContract.keySet()];

			if(listOli.size()>0){

				List<Item_do_Contrato__c> listItensContrato = new List<Item_do_Contrato__c>();
				for(OpportunityLineItem oli : listOli){
					Item_do_Contrato__c item = new Item_do_Contrato__c();
					system.debug('analise >>>'+oli.Analise_de_viabilidade__c);
					item.Analise_de_Viabilidade__c = oli.Analise_de_viabilidade__c;
					item.Name =  oli.Product2.Name;
					item.Oportunidade__c = oli.OpportunityId;
					item.Produto__c = oli.Product2Id;
					item.Conta__c = oli.Opportunity.AccountId;
					system.debug('mapContract >>>'+mapContract.get(oli.OpportunityId).Id);
					item.Contrato__c = mapContract.get(oli.OpportunityId).Id;
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

					listItensContrato.add(item);
				}

				if(listItensContrato.size()>0) insert listItensContrato;
			}
		}*/

		/*for(Opportunity opp : listOpp){
			if(oldMapOpp.get(opp.Id).StageName == 'Negociação de valores' && opp.StageName == 'Contrato'){
				idOpp.add(opp.Id);
    		}
        }

		if(!idOpp.isEmpty()){

			List<Contract> listaContratosDelete = [Select Id FROM Contract WHERE Oportunidade__c IN:idOpp AND Status = 'Esboço'];
			if(!listaContratosDelete.isEmpty()) delete listaContratosDelete;
			
			Map<String,Map<String,List<Item_do_Contrato__c>>> mapContratoItem = new Map<String,Map<String,List<Item_do_Contrato__c>>>();
			List<Item_do_Contrato__c> listItensContrato = new List<Item_do_Contrato__c>();
			Map<String,Set<String>> mapOppProduto = new Map<String,Set<String>> ();

			List<OpportunityLineItem> listOli = [Select Id, TotalPrice, OpportunityId, Quantity, Analise_de_viabilidade__c, Product2Id, Product2.Name, Banda_Mbps__c, UnitPrice, Acao_contratual__c, Analise_de_viabilidade__r.CEP_de_destino__c, Opportunity.Dia_do_vencimento__c,
															Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_origem__c, Analise_de_viabilidade__r.Numero_de_origem__c,Analise_de_viabilidade__r.Numero_de_destino__c,
														Analise_de_viabilidade__r.Data_da_conclusao__c, Analise_de_viabilidade__r.Qtd_Itens_Aprovacao__c, Analise_de_viabilidade__r.RecordType.Name, Analise_de_viabilidade__r.Complemento_da_origem__c, ProductCode, 
														Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Estado_de_destino__c, 
														Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, 
														Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Status__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c, Opportunity.AccountId 
														FROM OpportunityLineItem WHERE OpportunityId IN:idOpp];
			
			for(OpportunityLineItem oli : listOli){

				if(!mapContratoItem.containsKey(oli.OpportunityId)){
					mapContratoItem.put(oli.OpportunityId, new Map <String,List<Item_do_Contrato__c>>());
					System.debug('Entrou '+mapContratoItem.get(oli.OpportunityId).containsKey(oli.ProductCode));
					System.debug('>>>'+oli.ProductCode);
					if(!mapContratoItem.get(oli.OpportunityId).containsKey(oli.ProductCode)){
						System.debug('Entrou >>>');
						mapContratoItem.get(oli.OpportunityId).put(oli.ProductCode, new List<Item_do_Contrato__c>());

					}
				}else if(mapContratoItem.containsKey(oli.OpportunityId)){
					if(!mapContratoItem.get(oli.OpportunityId).containsKey(oli.ProductCode)){
						mapContratoItem.get(oli.OpportunityId).put(oli.ProductCode, new List<Item_do_Contrato__c>());
					}
				}

				if(!mapOppProduto.containsKey(oli.OpportunityId)){
					mapOppProduto.put(oli.OpportunityId, new Set<String>());
				}

				mapOppProduto.get(oli.OpportunityId).add(oli.ProductCode);

				Item_do_Contrato__c item = new Item_do_Contrato__c();
				item.Analise_de_Viabilidade__c = oli.Analise_de_viabilidade__c;
				item.Name =  oli.Product2.Name;
				item.Oportunidade__c = oli.OpportunityId;
				item.Produto__c = oli.Product2Id;
				item.Conta__c = oli.Opportunity.AccountId;
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
				
				system.debug('>>> '+mapContratoItem.get(oli.OpportunityId));
				system.debug('>>>> '+mapContratoItem.get(oli.OpportunityId).get(oli.ProductCode));
				system.debug('>>>> '+oli.ProductCode);
				if(mapContratoItem.containsKey(oli.OpportunityId) && mapContratoItem.get(oli.OpportunityId).containsKey(oli.ProductCode)){
					mapContratoItem.get(oli.OpportunityId).get(oli.ProductCode).add(item);
				}
			}
			
			List<Contract> listaContratos = new List<Contract>();
			Map<String,Map<String,Contract>> mapContratosOpp = new Map<String,Map<String,Contract>>();

			for(Opportunity opp : listOpp){
				for(String value : mapOppProduto.get(opp.Id)){
					Contract contrato = new Contract();
					contrato.AccountId = opp.AccountId;
					contrato.ContractTerm = Integer.valueOf(opp.Meses__c);
					contrato.StartDate = opp.CloseDate;
					contrato.Status = 'Esboço';
					contrato.Oportunidade__c = opp.Id;
					contrato.Cortesia__c = opp.Cortesia__c;
					contrato.Permuta__c = opp.Permuta__c;
					if(!mapContratosOpp.containsKey(Opp.Id)){
						mapContratosOpp.put(Opp.Id, new Map<String,Contract>());
						if(!mapContratosOpp.get(Opp.Id).containsKey(value)){
							mapContratosOpp.get(Opp.Id).put(value,contrato);
						}
					}else if(mapContratosOpp.containsKey(Opp.Id)){
						if(!mapContratosOpp.get(Opp.Id).containsKey(value)){
							mapContratosOpp.get(Opp.Id).put(value,contrato);
						}
					}
					listaContratos.add(contrato);
				}
			}

			if(!listaContratos.isEmpty()) insert listaContratos;

			for(Opportunity opp : listOpp){
				for(String value : mapOppProduto.get(opp.Id)){
					if(mapContratoItem.containsKey(opp.Id) && mapContratoItem.get(opp.Id).containsKey(value)){
						for(Item_do_Contrato__c item : mapContratoItem.get(opp.Id).get(value)){
							System.debug('>>> '+mapContratosOpp.get(opp.Id));
							System.debug('>>> '+mapContratosOpp.get(opp.Id).get(value));
							
							item.Contrato__c = mapContratosOpp.get(opp.Id).get(value).Id;
							listItensContrato.add(item);
						}
					}
				}
			}

			if(!listItensContrato.isEmpty()) insert listItensContrato;
		}*/
	//}

	public static void associarOppCatalogo(){
	
		List<Opportunity> listOpp = (List<Opportunity>) Trigger.new;
		Set<String> idAcc = new Set<String>();

		for(Opportunity opp : listOpp){
			if(opp.Pricebook2Id == null && opp.StageName == 'Mapeamento'){
				idAcc.add(opp.AccountId);
			}
		}

		if(idAcc.size()>0){
			List<Account> listAcc = [SELECT id, BillingState  FROM Account WHERE Id IN: idAcc];
			Map<String,String> mapAccUF = new Map<String,String>();

			for(Account acc : listAcc){
				if(acc.BillingState != null) mapAccUF.put(acc.Id, acc.BillingState);		
			}

			if(mapAccUF.size()>0){
				String Idpapel = UserInfo.getUserRoleId();
				List<Group> papeis = [Select Id, DeveloperName FROM Group Where Id =:Idpapel];
				String TipoPapel = null;
				if(!papeis.isEmpty()){
					if(papeis.get(0).DeveloperName.containsIgnoreCase('CARRIER')||papeis.get(0).DeveloperName.containsIgnoreCase('ISP')){
						TipoPapel = 'CARRIER';
					}else if(papeis.get(0).DeveloperName.containsIgnoreCase('GOVERNO')||papeis.get(0).DeveloperName.containsIgnoreCase('ISP')){
						TipoPapel = 'CORPORATIVO';
					}
				}

				List<Pricebook2> catalogos = [SELECT Id, UF__c FROM Pricebook2 Where UF__c IN: mapAccUF.values() and isActive =:true and Tipo_do_catalogo__c =:TipoPapel];
				Map<String,String> mapPricebook = new Map<String,String>();
				if(catalogos.size()>0){
					for(Pricebook2 pb : catalogos){
						mapPricebook.put(pb.UF__c, pb.Id);
					}
				}
				
				for(Opportunity opp : listOpp){
					opp.Pricebook2Id = mapPricebook.get(mapAccUF.get(opp.AccountId));	
				}
			}
		}
	}
    
    public static void validaFase() {	
		List<Opportunity> opps = Trigger.new;
        Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
        for(Opportunity opp : opps) {
            if(opp.StageName == 'Proposta' && oldMapOpp.get(opp.Id).StageName != 'Proposta' && opp.Qtd_Itens_Inviaveis__c > 0 && !opp.Aprovacao_Diretor__c) {
              opp.addError('A oportunidade contém item não viável. Envie para aprovação!');  
            }else if(opp.StageName == 'Proposta' && oldMapOpp.get(opp.Id).StageName != 'Proposta') {
			  opp.Aprovacao_Diretor__c = false;		
            }
        }
    }

	public static void marcarRebertura() {	
		List<Opportunity> opps = Trigger.new;
        Map<Id,Opportunity> oldMapOpp = (Map<Id,Opportunity>) Trigger.oldMap;
        for(Opportunity opp : opps) {
            if( (opp.StageName != 'Fechado Ganho' && oldMapOpp.get(opp.Id).StageName == 'Fechado Ganho') || (opp.StageName != 'Fechado Perdido' && oldMapOpp.get(opp.Id).StageName == 'Fechado Perdido')) {
              opp.Oportunidade_Reaberta__c = true;
            }
        }
    }
}