@isTest
public class CasosRelacionadosCTRLTest {

    @isTest public static void casosRelacionadosTest(){
        
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

        Item_do_Contrato__c itemContrato = new Item_do_Contrato__c();
        itemContrato.Name = 'Item Teste';
        itemContrato.Contrato__c = contrato.id;
        itemContrato.Cidade_de_destino__c = 'Recife';
        itemContrato.Numero_do_Circuito__c = '123456';
        insert itemContrato;
        
        Case caso = new Case();
        caso.ContactId = contato.id;
        caso.Regional__c = 'R';
        caso.Fila_Setor__c = 'F';
        caso.Status = 'New';
        caso.Origin = 'Email';
        caso.Protocolo_Externo_Callcenter__c = 'Dreamm0101';
        caso.AccountId = conta.id;
        caso.Area__c ='COMERCIAL';
        caso.Tipo_do_Chamado__c = 'Novo POP';
        insert caso;
        
        Case casoFilho = new Case();
        casoFilho.ContactId = contato.id;
        casoFilho.ParentId = caso.id;
        casoFilho.Item_do_Contrato__c = itemContrato.id;
        casoFilho.Regional__c = 'F';
        casoFilho.Fila_Setor__c = 'F';
        casoFilho.Status = 'New';
        casoFilho.Origin = 'Email';
        casoFilho.Protocolo_Externo_Callcenter__c = 'Dreamm0101';
        casoFilho.AccountId = conta.id;
        casoFilho.Area__c ='COMERCIAL';
        casoFilho.Tipo_do_Chamado__c = 'Novo POP';
        casoFilho.Contrato__c = contrato.id;
        insert casoFilho;
        
        
        List<case> lstCaso = CasosRelacionadosCTRL.getCasosRelacionados(caso.id);
        System.assertNotEquals(0, lstCaso.size());
        
    }
}