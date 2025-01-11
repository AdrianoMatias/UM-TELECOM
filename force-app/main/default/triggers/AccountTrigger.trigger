trigger AccountTrigger on Account (before insert, before update, after update){ 

	if(Trigger.isBefore){
		if(Trigger.isInsert){
			AccountTriggerHandler.validaCnpj();
		}
		
		if(Trigger.isUpdate){
			AccountTriggerHandler.validaCnpj();
			AccountTriggerHandler.formatacaondereco();
		}
	}

	if(Trigger.isAfter && Trigger.isUpdate){
		AccountTriggerHandler.associaCatalogoOpp();
	}

}