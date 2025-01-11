trigger EmailMessagetrigger on EmailMessage (after insert) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            EmailMessageTriggerHandler.replicarEmailCasoFilho();
        }	
    }
}