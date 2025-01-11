trigger CaseCommentTrigger on CaseComment (before insert, before update, after insert) {
    
    if(CaseCommentTriggerHandler.ignoreHandler){
        return;
    }else{
        
        if(Trigger.isBefore){
            if(Trigger.isUpdate){
                CaseCommentTriggerHandler.validarEdicaoComentarioCaso();
            }
        }
        
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                CaseCommentTriggerHandler.replicarComentarioCasoFilho();
            }
        }
    } 
}