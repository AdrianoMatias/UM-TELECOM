@isTest
public class CaseTriggerHandlerTest {

    @TestSetup public static void DataFactory(){
        
        
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        //Id CaseRecordTypeIdMassivo = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Evento Massivo').getRecordTypeId();
        
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
        
        comentario.CommentBody = 'DreammXp';
        update comentario;
        
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
        Boolean itensVerificados = false;
        List<String> listDescricao = new List<String>();
        List<Item_do_Contrato__c> listItens = [ SELECT id, Cep_de_destino__c, Cidade_de_destino__c, Complemento_de_destino__c, Referencia_de_destino__c, Rua_de_destino__c, Bairro_de_destino__c, Cep_de_origem__c, Cidade_de_origem__c, Complemento_de_origem__c, Referencia_de_origem__c, Rua_de_origem__c, Bairro_de_origem__c FROM Item_do_Contrato__c ];
        
        listDescricao.add('recife');
        listDescricao.add('imbiribeira');
        itensVerificados = CaseTriggerHandler.varerItensContrato(listDescricao, listItens);
        System.assertEquals(true, itensVerificados);
        Test.stopTest();
    }
    
    @isTest public static void HandleUpdate(){      
        Test.startTest();
        List<Case> lstCaso = [SELECT id, ContactId, Regional__c, Fila_Setor__c, Status, Origin, Protocolo_Externo_Callcenter__c FROM case WHERE Regional__c =: 'R'];
        Case caso = lstCaso[0];
        caso.Status = 'Fechado';
        update caso;
        Test.stopTest();   
    }


    @isTest public static void EnviarDescontoSAPTest(){

       Test.startTest();
       Set<id> idCase = new Set<id>();
       List<Case> lstCaso = [SELECT Id, Item_do_Contrato__r.Numero_do_Circuito__c, Indisponibilidade_Total__c FROM Case ];
       for(Case caso : lstCaso){ idCase.add(caso.id);}

        String strRetorno = IntegrationUtils.removerCaracteresCGC('DREAMMTESTE22-09-2020%$#');
        
        String jsonStringCliente  = '{"codigo":"C0007044"}';
        
        HttpMock mock = new HttpMock(200,'OK',jsonStringCliente, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
            CaseTriggerHandler.enviaIndisponibilidadeSAP(idCase);
		Test.stopTest();
    }

    @isTest public static void kpiTMRTest() {
        Test.startTest();
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Em andamento';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Priority = 'Média';
        caso.Area__c = 'FIELD SERVICE';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        update caso;

        caso.Status = 'Pausado';
        update caso;
        Test.stopTest();
    }


    @isTest public static void kpiTMPTest() {
        Test.startTest();
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Pausado';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Area__c = 'FIELD SERVICE';
        caso.Priority = 'Média';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        update caso;

        //caso.Status = 'Escalado';
        //update caso;
        Test.stopTest();
    }

    @isTest public static void kpiSLOTest() {
        Test.startTest();
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Escalado';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Area__c = 'FIELD SERVICE';
        caso.Priority = 'Média';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        update caso;

        //caso.Status = 'Resolvido';
        //update caso;
        Test.stopTest();
    }
    
    @isTest public static void sendCustomNotificationTest(){
        Test.startTest();
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Em andamento';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Area__c = 'FIELD SERVICE';
        caso.Priority = 'Média';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        caso.KPI_TMR_Violado__c = true;
        update caso;

        //caso.Status = 'Pausado';
        //update caso;
        Test.stopTest();
    }
    
    @isTest public static void sendCustomNotificationCenario2Test(){
        Test.startTest();
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Escalado';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Priority = 'Média';
        caso.Area__c = 'FIELD SERVICE';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        caso.KPI_SLO_Violado__c = true;
        update caso;

        Test.stopTest();
    }
    
    @isTest public static void sendCustomNotificationCenario3Test(){
        Test.startTest();
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Pausado';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Priority = 'Média';
        caso.Area__c = 'FIELD SERVICE';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        caso.KPI_TMP_Violado__c = true;
        update caso;

        Test.stopTest();
    }
    
    @isTest public static void sendCustomNotificationCenario4Test(){
        Test.startTest();
        
        Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
        Case caso = [SELECT Id, Status, Motivo_da_Pausa__c, Categoria__c, SLA_por_Tipo_de_Atendimento__c, Tipo_Atendimento__c, Area__c, Subject, Motivo_do_Escalonamento__c FROM Case WHERE RecordTypeId = :CaseRecordTypeIdChamado LIMIT 1];
        caso.Status = 'Encerrado';
        caso.Categoria__c = 'Proativo';
        caso.Tipo_Atendimento__c = 'NOC|Degradação - Alta Latência';
        caso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 04 horas';
        caso.Subject = 'Teste';
        caso.Area__c = 'FIELD SERVICE';
        caso.Priority = 'Média';
        caso.Motivo_do_Escalonamento__c = 'Proativo (Encaminhamento para Campo sem Contato com Cliente)';
        caso.Motivo_da_Pausa__c = 'Aguardando Disponibilidade de Técnico do Cliente Inloco';
        caso.KPI_TMS_Violado__c = true;
        caso.RFO__c = 'Teste';
        caso.Motivo_do_Encerramento__c = 'Parceiros_Todos_Servicos_Executados_Corretamente';
        caso.Descricao_do_Encerramento__c = 'Testes';
        caso.Indisponibilidade__c = true;
        
        update caso;
        
        Test.stopTest();
    }
    
    @isTest public static void stringCaixaBaixaTest(){
        Test.startTest();
        	CaseTriggerHandler.stringEmCaixaBaixa(new List<String>{'Teste', 'teste1', 'TESTE2'});
        Test.stopTest();
        
    }
    
}