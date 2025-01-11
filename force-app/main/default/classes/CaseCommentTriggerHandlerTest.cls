@isTest
public class CaseCommentTriggerHandlerTest {
    
    @TestSetup public static void DataFactory(){
        
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Chamado').getRecordTypeId();
        
        
        Account conta = new Account();
        conta.Name = 'Dreamm';
        insert conta;
        
        Contact contato = new Contact();
        contato.LastName = 'Dev';
        contato.AccountId = conta.id;
        contato.Email = 'email@email.com';
        insert contato;
        
        Contract contrato = new Contract();
        contrato.AccountId = conta.Id;
        contrato.Status = 'Esboço';
        contrato.StartDate = date.valueOf('2020-08-28');
        contrato.ContractTerm = 12;
        insert contrato;

        List<Item_do_Contrato__c> listaItensContrato = new  List<Item_do_Contrato__c>();
        Item_do_Contrato__c itemContrato = new Item_do_Contrato__c();
        itemContrato.Name = 'Item Teste';
        itemContrato.Contrato__c = contrato.id;
        itemContrato.Cidade_de_destino__c = 'Recife';
        itemContrato.Numero_do_Circuito__c = '123456';
        listaItensContrato.add(itemContrato);

        Item_do_Contrato__c itemContrato2 = new Item_do_Contrato__c();
        itemContrato2.Name = 'Fechado';
        itemContrato2.Contrato__c = contrato.id;
        itemContrato2.Cidade_de_destino__c = 'Recife';
        itemContrato2.Numero_do_Circuito__c = '101010';
        itemContrato2.Status__c = 'FECHADO';
        listaItensContrato.add(itemContrato2);
        insert listaItensContrato;

        List<Case> listaCaso = new  List<Case>();
        Case caso = new Case();
        caso.ContactId = contato.id;
        caso.Regional__c = 'R';
        caso.Fila_Setor__c = 'F';
        caso.Status = 'New';
        caso.Origin = 'Email';
        caso.Protocolo_Externo_Callcenter__c = 'Dreamm0101';
        caso.recordTypeId = CaseRecordTypeIdChamado ; //recordId Massivo
        caso.Description = 'DREAMM \n Dreamm Teste \n Dreamm \n RECIFE \n Recife';
        listaCaso.add(caso);
        
        Case caso2 = new Case();
        caso2.ContactId = contato.id;
        caso2.ParentId = caso.Id;
        caso2.Item_do_Contrato__c = itemContrato.id;
        caso2.Regional__c = 'R';
        caso2.Fila_Setor__c = 'F';
        caso2.Status = 'New';
        caso2.Origin = 'Email';
        caso2.Protocolo_Externo_Callcenter__c = 'Dreamm0101';
        caso2.recordTypeId = CaseRecordTypeIdChamado ; //recordId Chamado
        caso2.Description = 'DREAMM \n Dreamm Teste \n Dreamm \n RECIFE \n Recife';
        caso2.Contrato__c = contrato.id;
        caso2.Item_do_Contrato__c  = itemContrato.id;
        caso2.Data_Hora_Indisponibilidade__c  = datetime.now();
        caso2.Data_Hora_Encerramento__c = datetime.now() + 1;
        listaCaso.add(caso2);
        
        Case caso3 = new Case();
        caso3.ContactId = contato.id;
        caso3.ParentId = caso.Id;
        caso3.Item_do_Contrato__c = itemContrato.id;
        caso3.Regional__c = 'R';
        caso3.Fila_Setor__c = 'F';
        caso3.Status = 'New';
        caso3.Origin = 'Email';
        caso3.Protocolo_Externo_Callcenter__c = 'Dreamm0101';
        caso3.recordTypeId = CaseRecordTypeIdChamado ; //recordId Chamado
        caso3.Description = 'DREAMM \n Dreamm Teste \n Dreamm \n RECIFE \n Recife';
        caso3.Contrato__c = contrato.id;
        listaCaso.add(caso3);
        insert listaCaso;
        
        Case casoFilho = new Case();
        casoFilho.ContactId = contato.id;
        casoFilho.ParentId = caso.id;
        casoFilho.Item_do_Contrato__c = itemContrato.id;
        casoFilho.recordTypeId = CaseRecordTypeIdChamado;
        casoFilho.Regional__c = 'F';
        casoFilho.Fila_Setor__c = 'F';
        casoFilho.Status = 'New';
        casoFilho.Origin = 'Email';
        casoFilho.Contrato__c = contrato.id;
        casoFilho.Protocolo_Externo_Callcenter__c = 'Dreamm0101';        
        insert casoFilho;
        
        CaseComment comentario = new CaseComment();
        comentario.CommentBody = 'Dreamm Teste';
        comentario.ParentId = caso.id;
        insert comentario;
        
        EmailMessage email = new EmailMessage();
        email.TextBody = 'Dreamm Teste';
        email.ParentId = caso.id;
        insert email;

        Integracoes__c integracao = new Integracoes__c();
		integracao.Name = 'Desconto';
		integracao.Token__c = 'teste';
		integracao.url__c = 'teste%codigo';
		integracao.Metodo__c = 'POST';
        insert integracao;
        
        List<User> usuario = [Select Id from User where Name = 'Sistema'];
        if(!usuario.isEmpty()){
            system.runAs(usuario.get(0)){
                ContentNote objCntNote = new ContentNote();
                objCntNote.Title = 'Teste Dreamm';
                objCntNote.Content = Blob.valueOf('Teste dreamm');
                insert objCntNote; //Insert Content Note   
        
                //create ContentDocumentLink  record to link with parentId 
                ContentDocumentLink objCntDocLink = new ContentDocumentLink();
                objCntDocLink.LinkedEntityId = caso.Id; // Specify your parent Id 
                objCntDocLink.ContentDocumentId = objCntNote.Id;  //Content Note Id
                objCntDocLink.shareType = 'V'; // Specify your sharing type 
                insert objCntDocLink;
            }
        }
    }
    
    @isTest public static void testVerifyContractItens() {
        Test.startTest();
			
        Test.stopTest();
    }
}