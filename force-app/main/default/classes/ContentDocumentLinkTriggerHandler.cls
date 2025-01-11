public with sharing class ContentDocumentLinkTriggerHandler {
    
    public static Boolean ignoreHandler = false;
    
    public static void alteraStatusCaso() {
        List<ContentDocumentLink> cdls = (List<ContentDocumentLink>) Trigger.new;

        Set<String> idCasos = new Set<String>();
        for( ContentDocumentLink cdl : cdls ) {
            if( cdl.LinkedEntityId.getSobjectType() == Schema.Case.SObjectType ) {
                idCasos.add( cdl.LinkedEntityId );
            }
        }

        List<Case> casos = [Select Id, Status from Case where Id in :idCasos and Status='Novo'];
        for( Case caso : casos ) {
            caso.Status = 'Em andamento';
        }

        if( casos.size() > 0 ) {
            update casos;
        }
    }


}