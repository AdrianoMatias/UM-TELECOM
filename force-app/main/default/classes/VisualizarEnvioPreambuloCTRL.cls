public class VisualizarEnvioPreambuloCTRL  {

	private static final String EMAIL_TELECOM = 'UmTelecom';
	private static Map<String,String> mapaContratos;

	static {
        mapaContratos = new Map<String,String>{
                        
            'Coletivo por Adesão#17' => 'CONTRATO PJ ADESAO - ORTOCLIN PLUS.pdf',
            'Coletivo Empresarial#6' => 'CONTRATO PJ - CLINCLASS.pdf'
        };
    }

	@AuraEnabled
    public static List<Contact> listaContato(String idcontrato) {
        
		Contract contrato = [SELECT Id, AccountId FROM Contract WHERE Id =: idcontrato];

		List<Contact> listContato = [SELECT Id, Name, Email, Phone, MobilePhone FROM Contact WHERE AccountId =: contrato.AccountId];
		if(listContato.isEmpty()) throw new AuraHandledException( 'Não há usuários disponíveis para o envio desse preâmbulo');
		return listContato;
    }

    @AuraEnabled
    public static void enviarPreambulo(String contractId, String idsContatos) {
		Type idArrType = Type.forName('List<string>');
		List<string> listContatos = (List<string>) JSON.deserialize(idsContatos, idArrType);
		
		System.debug('listContatos>> '+listContatos);
		if(listContatos.size()==0){
			throw new AuraHandledException('Selecione algum usuário para o envio do email.');
		}

		List<Contact> contato = [Select Id, Name, Email from Contact where Id IN:listContatos LIMIT 1];
		List<String> contatosEmail = new List<String>();
		for(Contact con : contato){
			if(con.Email == null){
				throw new AuraHandledException('O usuário '+ con.Name +' não está com email preenchido.');
			}
			contatosEmail.add(con.Email);
		}

        PageReference pdf = Page.Preambulo;
		System.debug('contrato Id>>'+contractId);
        pdf.getParameters().put('id',contractId);
        Blob content = !Test.isRunningTest() ? pdf.getContentAsPDF() : Blob.valueOf('Teste');
        
		Contract contrato = [Select Id, AccountId, Name,Status, DocumentId__c, Enviar_Contratos_Padroes__c from Contract where Id = :contractId];
        if(contrato.Status != 'Esboço'){
			throw new AuraHandledException('O status não permite o envio do preâmbulo. Fale com o administrador.');
		}else{
			try {
                List<Messaging.EmailFileAttachment> anexosContrato = new List<Messaging.EmailFileAttachment>();
				Set<String> nomeContratos = new Set<String>();

				List<OrgWideEmailAddress> owes = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = :EMAIL_TELECOM LIMIT 1];
                EmailTemplate template = [Select Id from EmailTemplate where DeveloperName='Envio_proposta'];
				 
				//verificando contrato
                ContentVersion contratoPersonalizado;
                Boolean temContratoPersonalizado = false;
                if(String.isNotBlank(contrato.DocumentId__c)){
                    List<ContentVersion> contratosPersoanlizados = [SELECT Id, Title, FileType, VersionData FROM ContentVersion WHERE ContentDocumentId = :contrato.DocumentId__c];
                    if(contratosPersoanlizados.size() > 0){
                        temContratoPersonalizado = true;
                        contratoPersonalizado = contratosPersoanlizados.get(0);
                    }
                }

				//if( !mapaContratos.containsKey( contrato.Tipo_de_Plano__c + '#' + p.ProductCode ) ) {
                    //throw new AuraHandledException( 'Não foi encontrado nenhum contrato com este tipo de contratação e produto selecionado' );
                //} else {
                //    nomeContratos.add(mapaContratos.get( contrato.Tipo_de_Plano__c + '#' + p.ProductCode ));
                //}

				if(temContratoPersonalizado){
                    Messaging.EmailFileAttachment anexoContratoPersonalizado = new Messaging.EmailFileAttachment();
                    anexoContratoPersonalizado.Body = contratoPersonalizado.VersionData;
                    anexoContratoPersonalizado.contentType = 'application/pdf';
                    anexoContratoPersonalizado.filename = contratoPersonalizado.Title;
                    anexosContrato.add(anexoContratoPersonalizado); 
                }

                System.debug(contrato.Enviar_Contratos_Padroes__c || !temContratoPersonalizado);
                if(contrato.Enviar_Contratos_Padroes__c || !temContratoPersonalizado){
                    for( Document c : [SELECT Id, Body, Name FROM Document WHERE Name=:nomeContratos] ) {                        
                        Messaging.EmailFileAttachment anexoContrato = new Messaging.EmailFileAttachment();
                        anexoContrato.Body = c.Body;
                        anexoContrato.contentType = 'application/pdf';
                        anexoContrato.filename = c.Name;
                        anexosContrato.add(anexoContrato);                        
                    }
                }

                Messaging.EmailFileAttachment anexo = new Messaging.EmailFileAttachment();
                anexo.Body = content;
                anexo.contentType = 'application/pdf';
                anexo.filename = 'Preambulo '+Account.Name+'.pdf';
                anexosContrato.add(anexo);

                EmailUtils.sendEmail( contatosEmail, new List<String>{UserInfo.getUserEmail()}, null, template.Id, contrato.Id, contato.get(0).Id,anexosContrato);           
                
                contrato.Status = 'Autorizado';
                update contrato;
                
            } catch( Exception e ) {
                System.debug(e.getMessage());
		  		System.debug(e.getStackTraceString());
				throw new AuraHandledException(e.getMessage());    
            }
        }
    }

    @AuraEnabled
    public static String visualizarPreambulo(String contractId) {
		
		Contract contrato = [Select Id from Contract where Id = :contractId];
		PageReference pdf = Page.Preambulo;
		pdf.getParameters().put('id',contrato.Id);
		
		Blob content = !Test.isRunningTest() ? pdf.getContentAsPDF() : Blob.valueOf('Teste');

		//caso nao exista proposta, cria anexo
		String idContentDocument = criarAnexoProposta(contrato.Id, content);
                                
		return idContentDocument;
    }

    private static String criarAnexoProposta(String opportunityId, Blob content){
        List<ContentDocumentLink> contentDocumentLinkComPreAmbulo  = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :opportunityId AND ContentDocument.Title like '%Preambulo%'];
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
        cv.Title = 'Preambulo - ' + Datetime.now() + '.pdf';
        cv.PathOnClient = 'Preambulo - ' + Datetime.now() + '.pdf';
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = opportunityId;
        cdl.ShareType = 'V';
        insert cdl;        

        return cdl.ContentDocumentId;
    }
}