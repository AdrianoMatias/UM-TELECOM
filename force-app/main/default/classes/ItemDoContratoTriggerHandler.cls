public class ItemDoContratoTriggerHandler  {

	public static void atualizaStatusContrato (){
		/*List<Item_do_Contrato__c> listItens = (List<Item_do_Contrato__c>) Trigger.new;
	
		Set<Id> IdAutorizado = new Set<Id>();
		Set<Id> IdEncerrado = new Set<Id>();

		for(Item_do_Contrato__c item : listItens){
			if(item.Status__c =='INICIADO'||item.Status__c =='SUSPENSO'){
				IdAutorizado.add(item.Contrato__c);
			}

			if((item.Status__c =='FECHADO'||item.Status__c =='CANCELADO'||item.Status__c =='CIRCUITO CANCELADO') && IdAutorizado != null && !IdAutorizado.contains(item.Contrato__c)){
				IdEncerrado.add(item.Contrato__c);
			}
		}

		if(!IdAutorizado.isEmpty()){
			Map<Id,Contract> mapContract = New Map<Id,Contract>([Select Id, Status FROM Contract WHERE Status != 'Autorizado' AND Id IN:IdAutorizado]);

			if(!mapContract.isEmpty()){
				for(Contract contrato : mapContract.values()){
					contrato.Status = 'Autorizado';
				}
				update mapContract.values();
			}

		}

		if(!IdEncerrado.isEmpty()){
			Map<Id,List<Item_do_Contrato__c>> mapItensContrato = new Map<Id,List<Item_do_Contrato__c>>();
			List<Item_do_Contrato__c>  listItensEncerrados = [SELECT Id, Contrato__c, Status__c FROM Item_do_Contrato__c WHERE Contrato__c IN: IdEncerrado];
			
			for(Item_do_Contrato__c itens : listItensEncerrados){
				if(!mapItensContrato.containsKey(itens.Contrato__c)){
					mapItensContrato.put(itens.Contrato__c, new List<Item_do_Contrato__c>());
				}
				mapItensContrato.get(itens.Contrato__c).add(itens);
			}

			Set<Id> setIdContratoRemover = new Set<Id>();
			for(Id idEnc : IdEncerrado){
				for(Item_do_Contrato__c ic : mapItensContrato.get(idEnc)){
					if(ic.Status__c=='INICIADO'||ic.Status__c =='SUSPENSO'){
						setIdContratoRemover.add(idEnc);	
					}
				}
			}

			if(!setIdContratoRemover.isEmpty()){
				for(Id IdRemover : setIdContratoRemover){
					mapItensContrato.remove(IdRemover);
				}
			}

			if(!mapItensContrato.isEmpty()){
				Map<Id,Contract> contratos = New Map<Id,Contract>([Select Id, Status FROM Contract WHERE Status != 'Encerrado' AND Id IN:mapItensContrato.keySet()]);

				if(!contratos.isEmpty()){
					for(Contract contrato : contratos.values()){
						contrato.Status = 'Encerrado';
					}
					update contratos.values();
				}
			}

		}*/
	}

	public static void setarConta(){

		/* List<Item_do_Contrato__c> lstItens = (List<Item_do_Contrato__c>) Trigger.new;
		Set<id> contratos = new Set<id>();
		if(!lstItens.isEmpty()){
			for(Item_do_Contrato__c item : lstItens){
				contratos.add(item.Contrato__c);
			}
			Map<Id,Contract> mapContract = New Map<Id,Contract>( [SELECT id, AccountId FROM Contract WHERE id IN:contratos]);
			
			for(Item_do_Contrato__c itemAtt : lstItens){
				itemAtt.Conta_do_Contrato__c = mapContract.get(itemAtt.Contrato__c).AccountId;
			}
		}*/
	}
    
}