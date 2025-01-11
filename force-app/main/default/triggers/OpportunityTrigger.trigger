trigger OpportunityTrigger on Opportunity (before insert, before update, after update) {
    
	if(Trigger.isBefore && Trigger.isInsert){
		OpportunityTriggerHandler.associarOppCatalogo();
	}
	
	if( Trigger.isBefore && Trigger.IsUpdate){
		//OpportunityTriggerHandler.validaFaseItemContrato();
		OpportunityTriggerHandler.validarAnalise();
		OpportunityTriggerHandler.calculaCapexGeralOportunidade();
        	OpportunityTriggerHandler.validaFase();
        OpportunityTriggerHandler.marcarRebertura();
        
	}

	if( Trigger.isAfter && Trigger.IsUpdate){
		OpportunityTriggerHandler.atualizarProdutoDaOportunidade();
		OpportunityTriggerHandler.cancelaAnalises();
	}
}