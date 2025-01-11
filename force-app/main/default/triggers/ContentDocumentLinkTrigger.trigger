trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    if(ContentDocumentLinkTriggerHandler.ignoreHandler) return;

    if(Trigger.isAfter && Trigger.isInsert){
        ContentDocumentLinkTriggerHandler.alteraStatusCaso();
    }
}