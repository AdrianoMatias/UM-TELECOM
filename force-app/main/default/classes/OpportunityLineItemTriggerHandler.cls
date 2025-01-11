public class OpportunityLineItemTriggerHandler {

	public static Boolean ignoreHandler = false;

    public static void deletarAnalises() {
		Set<String> analiseId = new Set<String>();
		List<OpportunityLineItem> oliList = (List<OpportunityLineItem>) Trigger.new;
		System.debug('OpportunityLineItem '+oliList);
		if(oliList!= null){
			for(OpportunityLineItem oli : oliList){
				if(oli.Analise_de_viabilidade__c != NULL){
					analiseId.add(oli.Analise_de_viabilidade__c); 
				}
			}
			List<Analise_de_viabilidade__c>analiseList = [SELECT Id From Analise_de_viabilidade__c Where Id IN: analiseId];
			if(analiseList.size()>0){
				delete analiseList;
			}
		} 
    }

	public static void atualizaCampo(){
	
		List<OpportunityLineItem> oliList = (List<OpportunityLineItem>) Trigger.new;
		for(OpportunityLineItem oli : oliList){
			if(oli.Retorno_em__c<0.10){
				oli.Indicativo__c = true;
			}else{
				oli.Indicativo__c = false;
			}
		}
	}

	public static void atualizaOportunidade(){
	
		List<OpportunityLineItem> oliList = (List<OpportunityLineItem>) Trigger.new;
		Map<Id,OpportunityLineItem> oliMap = (Map<Id,OpportunityLineItem>) Trigger.oldMap;
		Set<Id> idsOpp = new Set<Id>(); 
		for(OpportunityLineItem oli : oliList){
			if(oli.Quantity!=oliMap.get(oli.Id).Quantity || oli.UnitPrice!=oliMap.get(oli.Id).UnitPrice){
				idsOpp.add(oli.OpportunityId);
			}
		}
		
		if(!idsOpp.isEmpty()){
			List<Opportunity> opps = [Select Id, StageName From Opportunity where Id IN: idsOpp];
			if(!opps.isEmpty()){
				List<Opportunity> listOppUpdate = new List<Opportunity>();
				for(Opportunity opp : opps){
					if(opp.StageName == 'Negociação de valores'||opp.StageName == 'Contrato'||opp.StageName == 'Proposta'){
						listOppUpdate.add(opp);
					}
				}
				if(!listOppUpdate.isEmpty()){
					for(Opportunity opp : listOppUpdate){
						opp.StageName = 'Formação de preços';
					}
					update listOppUpdate;
				}
			}
		}
	}

	public static void arredondaPrecoOli() {

		List<OpportunityLineItem> oppLs2 = [Select Id, Arredondar_valor__c, TotalPrice, OpportunityId From OpportunityLineItem Where Id IN:Trigger.New];

		List<OpportunityLineItem> itensArredondar = new List<OpportunityLineItem>();
		for(OpportunityLineItem oppL : oppLs2){
			if(oppL.Arredondar_valor__c){
				oppL.TotalPrice = oppL.TotalPrice.round();
				itensArredondar.add(oppL);
			}
		}
		ignoreHandler = true;
		if(!itensArredondar.isEmpty()) update itensArredondar;
		ignoreHandler = false;
		
	}
    
    public static void criarProdutosOportunidadeQtd(){
        
        if(!ignoreHandler){
            List<OpportunityLineItem> lineItens = [SELECT Id, Quantity, UnitPrice , OpportunityId, ServiceDate, Quantidade_de_produtos__c, PricebookEntryId, Product2Id  
                                                   FROM OpportunityLineItem 
                                                   WHERE Id IN:Trigger.New];
            
            if(!lineItens.isEmpty()){
                List<OpportunityLineItem> lstClone = new List<OpportunityLineItem>();
                for(OpportunityLineItem lineItem : lineItens){
                    if(lineItem.Quantidade_de_produtos__c != null && (lineItem.Quantidade_de_produtos__c != 0 || lineItem.Quantidade_de_produtos__c != 1)){
                        Integer qtdProdutos  = Integer.valueOf(lineItem.Quantidade_de_produtos__c) -1; //Integer.valueOf(lineItem.Quantidade_de_produtos__c) > 1 ? Integer.valueOf(lineItem.Quantidade_de_produtos__c) : Integer.valueOf(lineItem.Quantidade_de_produtos__c) -1;
                        for(Integer i=0; i < qtdProdutos; i++){
                            OpportunityLineItem itemClone = lineItem.clone(false,false,true,true);
                            itemClone.OpportunityId 	  = lineItem.OpportunityId;
                            itemClone.PriceBookEntryId    = lineItem.PricebookEntryId;
                            itemClone.Product2Id		  = lineItem.Product2Id;
                            lstClone.add(itemClone);
                        }
                    }
                }
                
                ignoreHandler = true;
                if(!lstClone.isEmpty()){
                    insert lstClone;
                }
                ignoreHandler = false;
            }
        }
    }

	/*public static void produtoTaxaInstalacao() {
		System.debug('ignoreHandler >>> '+ignoreHandler );
		List<OpportunityLineItem> listOli = (List<OpportunityLineItem>) Trigger.new;
		Set<Id> setIdOpp = new Set<Id>();
		List<Id> IdOppInsert = new List<Id>();
		List<Id> IdOliDelete = new List<Id>();
		Map<Id,List<OpportunityLineItem>> mapListOli = new Map<Id,List<OpportunityLineItem>>(); 
		Map<Id,OpportunityLineItem> mapListTaxaOli = new Map<Id,OpportunityLineItem>(); 
		if(listOli!= null){
			for(OpportunityLineItem oli : listOli){
				setIdOpp.add(oli.OpportunityId);
			}
			System.debug('setIdOpp >>> '+setIdOpp );
			List<OpportunityLineItem> listOliTotal = [Select Id, Taxa_de_instalacao__c, Name, Product2Id, Product2.Name, OpportunityId, UnitPrice FROM OpportunityLineItem WHERE OpportunityId IN: setIdOpp];
			System.debug('listOliTotal >>> '+listOliTotal );
			for(OpportunityLineItem oli : listOliTotal){
				if((oli.Taxa_de_instalacao__c!=null&&oli.Taxa_de_instalacao__c>0) && !oli.Name.contains('Taxa de instalação')){
					System.debug('Name >>>'+oli.Name);
					if(!mapListOli.containsKey(oli.OpportunityId)){
						mapListOli.put(oli.OpportunityId, new List<OpportunityLineItem>());
					}
					mapListOli.get(oli.OpportunityId).add(oli);
				}else if(oli.Name.contains('Taxa de instalação')){
					System.debug('Name >>>'+oli.Name);
					mapListTaxaOli.put(oli.OpportunityId,oli);
				}
			}
			System.debug('mapListTaxaOli >>> '+ mapListTaxaOli );
			System.debug('mapListOli >>> ' + mapListOli );
			for(Id IdOpp : setIdOpp){
				if(mapListTaxaOli.containsKey(IdOpp) && mapListOli.containsKey(IdOpp)){
					mapListTaxaOli.get(IdOpp).Taxa_de_instalacao__c = 0;
					for(OpportunityLineItem oliMap : mapListOli.get(IdOpp)){
						mapListTaxaOli.get(IdOpp).Taxa_de_instalacao__c += oliMap.Taxa_de_instalacao__c;
					}
				}else if(!mapListTaxaOli.containsKey(IdOpp) && mapListOli.containsKey(IdOpp)){
					// Verificar se já existe no catálogo padrão, se não houver criar produto, adicionar ao catálogo padrão
					// se já existi pegar a referencia do produto e adicionar ao catalogo da Oportunidade.
					IdOppInsert.add(IdOpp);
				}else if(mapListTaxaOli.containsKey(IdOpp) && !mapListOli.containsKey(IdOpp)){
					//Identifico os produtos da oportunidade que serão deletadas
					IdOliDelete.add(mapListTaxaOli.get(IdOpp).Id);
					mapListTaxaOli.remove(IdOpp);
				}
			}
			System.debug('mapListTaxaOli >>> '+ mapListTaxaOli);
			ignoreHandler = true;
			If(mapListTaxaOli.size()>0){
				System.debug('Entrou 1>>');
				update mapListTaxaOli.values();
			}

			if(IdOliDelete.size()>0){
			System.debug('Entrou 2>>');
				delete [Select Id FROM OpportunityLineItem Where Id IN: IdOliDelete];
			}

			if(IdOppInsert.size()>0){
			System.debug('Entrou 3>>');
				adicionarCatalogo(IdOppInsert,mapListOli);
			}
			ignoreHandler = false;
		}
	}

	private static void adicionarCatalogo(List<Id> idOpps, Map<Id,List<OpportunityLineItem>> mapList) {
		// Verificar se já existe no catálogo padrão, se não houver criar produto, adicionar ao catálogo padrão
		// se já existi pegar a referencia do produto e adicionar ao catalogo da Oportunidade. E depois inserir para a oportunidade
		List<PricebookEntry> listPbe = [Select Id, Pricebook2Id, Product2.Name, Product2Id FROM PricebookEntry WHERE Pricebook2.IsStandard =: true LIMIT 1];
		Id idProdTaxa = null;
		for(PricebookEntry pbe : listPbe){
			if(pbe.Product2.Name=='Taxa de instalação'){
				idProdTaxa = pbe.Product2Id;
			}	
		}

		List<Opportunity> listOpp = [Select Id, Pricebook2Id FROM Opportunity WHERE Id IN: idOpps];

		if(idProdTaxa!=null){
			//Adicionar a entrada de preço e catalogo para depois inserir nos produto de oportunidade 
			List<PricebookEntry> insertPbe = new List<PricebookEntry>();
			for(Opportunity opp : listOpp){
				PricebookEntry pbe = new PricebookEntry(); 
				pbe.Product2Id = idProdTaxa;
				pbe.UnitPrice = 0;
				pbe.UseStandardPrice = true;
				for(OpportunityLineItem oli : mapList.get(opp.Id)){
					pbe.Pricebook2Id = opp.Pricebook2Id;
					pbe.UnitPrice = pbe.UnitPrice + oli.Taxa_de_instalacao__c; 
				}
				insertPbe.add(pbe);
			}
			insert insertPbe;

			List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
			for(Id idOpp : mapList.keySet()){
				OpportunityLineItem oli = new OpportunityLineItem();
				oli.OpportunityId = idOpp;
				oli.Product2Id = idProdTaxa;
				oli.Quantity = 1;
				listOli.add(oli);
			}
			Insert listOli;

		}else{
			//Adicionar o produto
			Product2 prod = new Product2(); 
			prod.Name = 'Taxa de instalação';  
			prod.ProductCode = '0'; 
			prod.IsActive = true; 
			prod.Family = 'Instalação';
			prod.Instalacao__c = false;
			prod.Endereco_Origem__c = false;
			prod.Endereco_Destino__c = false;
			prod.Setor__c = 'TI';
			prod.Viabilidade__c = false; 
			insert prod;
			
			//Adiciona o produto ao catálogo padrão
			PricebookEntry pbeS = new PricebookEntry(); 
			pbeS.Product2Id = prod.Id;
			pbeS.UnitPrice = 0;
			pbeS.IsActive = true;
			pbeS.Preco_Minimo_do_Gerente__c = 0;
			pbeS.Preco_Minimo_do_Executivo__c = 0;
			pbeS.Pricebook2Id = listPbe.get(0).Pricebook2Id;
			insert pbeS;
			
			//Adiciona o produto ao catálogo da oportunidade, caso seja diferente do catálogo padrão
			List<PricebookEntry> insertPbe = new List<PricebookEntry>();
			for(Opportunity opp : listOpp){
				if(listPbe.get(0).Pricebook2Id != opp.Pricebook2Id){
					System.debug('Entrou +1');
					PricebookEntry pbe = new PricebookEntry(); 
					pbe.Product2Id = prod.Id;
					pbe.UnitPrice = 0;
					pbe.Preco_Minimo_do_Gerente__c = 0;
					pbe.Preco_Minimo_do_Executivo__c = 0;
					pbe.IsActive = true;
					pbe.Pricebook2Id = opp.Pricebook2Id;
					insertPbe.add(pbe);
				}
			}
			if(insertPbe.size()>0) insert insertPbe;

			List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
			for(Id idOpp : mapList.keySet()){
				OpportunityLineItem oli = new OpportunityLineItem();
				oli.OpportunityId = idOpp;
				oli.Product2Id = prod.Id;
				oli.UnitPrice = 0;
				oli.Taxa_de_instalacao__c = 0;
				for(OpportunityLineItem oliTaxa : mapList.get(idOpp)){
					System.debug('oli.Taxa_de_instalacao__c' +oli.Taxa_de_instalacao__c);
					System.debug('oliTaxa.Taxa_de_instalacao__c' +oliTaxa.Taxa_de_instalacao__c);
					oli.Taxa_de_instalacao__c = oli.Taxa_de_instalacao__c + oliTaxa.Taxa_de_instalacao__c; 
				} 
				oli.Quantity = 1;
				listOli.add(oli);
			}
			Insert listOli;
		}
	}*/
}