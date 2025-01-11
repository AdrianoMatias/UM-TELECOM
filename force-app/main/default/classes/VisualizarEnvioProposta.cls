public with sharing class VisualizarEnvioProposta{

	private static final String EMAIL_TELECOM = 'UmTelecom';

    @AuraEnabled
    public static void enviarProposta( String oppId ) {
        PageReference pdf = Page.Proposta;
        pdf.getParameters().put('id',oppId);
        Blob content = !Test.isRunningTest() ? pdf.getContentAsPDF() : Blob.valueOf('Teste');
        
		Opportunity opp = [Select Id, Amount, StageName, AccountId, Name, Account.Name from Opportunity where Id = :oppId];
        if(opp.StageName != 'Proposta'){
			throw new AuraHandledException( 'Ñão é possível enviar a proposta nessa fase da oportunidade. Fale com o administrador.');
		}else{
            try {
                Contact contato = [Select Id, Email from Contact where AccountId = :opp.AccountId LIMIT 1];
				List<OrgWideEmailAddress> owes = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = :EMAIL_TELECOM LIMIT 1];
                EmailTemplate template = [Select Id from EmailTemplate where DeveloperName='Envio_proposta'];
                
                Messaging.EmailFileAttachment anexo = new Messaging.EmailFileAttachment();
                anexo.Body = content;
                anexo.contentType = 'application/pdf';
                anexo.filename = 'Proposta '+Account.Name+'.pdf';
                
                EmailUtils.sendEmail( new List<String>{ contato.Email }, new List<String>{UserInfo.getUserEmail()}, null, template.Id, opp.Id, contato.Id, new List<Messaging.EmailFileAttachment> {anexo} );           
                
                Opportunity oportunidade = [SELECT Id, StageName FROM Opportunity WHERE Id=:opp.Id LIMIT 1];
                oportunidade.StageName = 'Negociação de valores';
                update oportunidade;
                
            } catch( Exception e ) {
                System.debug(e.getMessage());
				System.debug(e.getStackTraceString());
				throw new AuraHandledException(e.getMessage());    
            }
        }
    }

    @AuraEnabled
    public static String visualizarPropostaCTRL( String oppId ) {
		Opportunity opp = [Select Id, Amount, StageName, AccountId, Name from Opportunity where Id = :oppId];
		PageReference pdf = Page.Proposta;
		pdf.getParameters().put('id',opp.Id);
		Blob content = !Test.isRunningTest() ? pdf.getContentAsPDF() : Blob.valueOf('Teste');

		//caso nao exista proposta, cria anexo
		String idContentDocument = criarAnexoProposta(opp.Id, content);
                                
		return idContentDocument;
    }

    private static String criarAnexoProposta(String opportunityId, Blob content){
        List<ContentDocumentLink> contentDocumentLinkComPreAmbulo  = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :opportunityId AND ContentDocument.Title like '%Proposta%'];
        if(contentDocumentLinkComPreAmbulo.size()>0){
            List<String> contentDocumentIds = new List<String>();
            for(ContentDocumentLink cd : contentDocumentLinkComPreAmbulo){
                contentDocumentIds.add(cd.ContentDocumentId);
            }

            delete contentDocumentLinkComPreAmbulo;
            if(contentDocumentIds.size()>0){
                List<ContentDocument> contents = [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIds];
                delete contents;
            }
        }

        ContentVersion cv = new ContentVersion();
        cv.VersionData = content;
        cv.Title = 'Proposta - ' + Datetime.now() + '.pdf';
        cv.PathOnClient = 'Proposta - ' + Datetime.now() + '.pdf';
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = opportunityId;
        cdl.ShareType = 'V';
        insert cdl;        

        return cdl.ContentDocumentId;
    }
}