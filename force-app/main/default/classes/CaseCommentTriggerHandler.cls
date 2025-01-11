public class CaseCommentTriggerHandler {
    
    public static boolean ignoreHandler = false;

    
    public static void replicarComentarioCasoFilho(){

        if( !ignoreHandler ) {
            List<CaseComment> comentarios = (List<CaseComment>) Trigger.new;
            Map<String,CaseComment> mapaComentarios = new Map<String,CaseComment>();
            
            for( CaseComment comentario : comentarios ) {
                mapaComentarios.put( comentario.ParentId, comentario );
            }
    
            List<CaseComment> comentariosFilho = new List<CaseComment>();
            List<Case> casosFilho = [Select Id, ParentId from Case where ParentId in :mapaComentarios.keySet()];
            for( Case casoFilho : casosFilho ) {
                CaseComment comentarioCasoPai = mapaComentarios.get( casoFilho.ParentId );
                CaseComment comentarioFilho = comentarioCasoPai.clone(false, true, false, false);
                comentarioFilho.ParentId = casoFilho.Id;
                comentariosFilho.add( comentarioFilho );
            }
    
            ignoreHandler = true;
            //CaseTriggerHandler.ignoreHandler = true;
            insert comentariosFilho;
            ignoreHandler = false;
            //CaseTriggerHandler.ignoreHandler = false;
        }
    }
    
    public static void validarEdicaoComentarioCaso(){
        
        if( !ignoreHandler ) {
            List<CaseComment> comentarios = (List<CaseComment>) Trigger.new;
            Map<String,CaseComment> mapaComentarios = new Map<String,CaseComment>();
            
            for( CaseComment comentario : comentarios ) {
                mapaComentarios.put( comentario.ParentId, comentario );
            }
            
            if(!mapaComentarios.isEmpty()){
                List<Case> casos = [SELECT Id, CreatedById, OwnerId FROM Case WHERE Id in :mapaComentarios.keySet()];
                for( Case casoV : casos ) {
                    if( ((String) casoV.OwnerId).startsWith('005') && casoV.OwnerId != Userinfo.getUserId()){
                        if(mapaComentarios.containsKey(casoV.Id)){
                            CaseComment comentarioCaso = mapaComentarios.get(casoV.Id);
                        	comentarioCaso.AddError('Apenas o proprietário do caso tem permissão para edição do comentário.');
                        }
                    }
                }
            }
        }
    }
}