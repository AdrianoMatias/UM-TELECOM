trigger TaskTrigger on Task (after insert, after update) {
	if(Trigger.isAfter){
        if(Trigger.isInsert){
            TaskTriggerHandler.replicarAnexoEmail();
        }
        if(Trigger.isUpdate){
            TaskTriggerHandler.replicarAnexoEmail();
        }
    }
}