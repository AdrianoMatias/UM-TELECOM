trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, before delete, before update, after update) {
    
	if(OpportunityLineItemTriggerHandler.ignoreHandler) return;

	if(Trigger.IsBefore){	
		if(Trigger.isDelete){
			OpportunityLineItemTriggerHandler.deletarAnalises();
		}
		
		if(Trigger.isUpdate){
			OpportunityLineItemTriggerHandler.atualizaCampo();
		}
        if(Trigger.isInsert){
			OpportunityLineItemTriggerHandler.atualizaCampo();
		}
	} 
	
	if(Trigger.isAfter){
        if(Trigger.isInsert){
			OpportunityLineItemTriggerHandler.arredondaPrecoOli();
            OpportunityLineItemTriggerHandler.criarProdutosOportunidadeQtd();
		}
        
		if(Trigger.isUpdate){
            OpportunityLineItemTriggerHandler.arredondaPrecoOli();
			OpportunityLineItemTriggerHandler.atualizaOportunidade();
		}
	}
}