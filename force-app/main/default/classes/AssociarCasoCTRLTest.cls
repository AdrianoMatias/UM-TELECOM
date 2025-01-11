@isTest 
public class AssociarCasoCTRLTest {

    @TestSetup
    static void makeData(){
        
        Account conta = new Account();
        conta.Name = 'umtelecom';
        insert conta;

        Contract contrato = new Contract();
        contrato.Accountid = conta.id;
        contrato.status = 'Esboço';
        contrato.StartDate = Date.today() - 2;
        contrato.ContractTerm = 12;
        insert contrato;

        Item_do_Contrato__c itemContrato = new Item_do_Contrato__c();
        itemContrato.Name = 'DREAMM TESTE';
        itemContrato.Contrato__c = contrato.id;
        itemContrato.Status__c = 'INICIADO';
        insert itemContrato;

        Case caso = new Case();
        caso.status = 'Novo';
        caso.origin = 'Email';
        caso.Accountid = conta.id;
        insert caso;

    }

    @isTest public static void getCasoTest(){

        list<Case> lstCaso = [SELECT id FROM Case];
        Case retorno = AssociarCasoCTRL.getCaso(lstCaso.get(0).id);
        System.assertNotEquals(null, retorno);
    }

    @isTest public static void buscarContratosTest(){

        list<Account> lstConta = [SELECT id FROM Account];
        List<Contract> retorno = AssociarCasoCTRL.buscarContratos(lstConta.get(0).id);
        System.assertNotEquals(null, retorno);
    }

    @isTest public static void buscarItensContratosTest(){

        list<Account> lstConta = [SELECT id FROM Account];
        List<Contract> lstContrato = [SELECT id FROM Contract];
        List<Item_do_Contrato__c> retorno = AssociarCasoCTRL.buscarItensContrato(lstConta.get(0).id, lstContrato.get(0).id);
        System.assertNotEquals(null, retorno);
    }

    @isTest public static void salvarCasoTest(){

        List<Contract> lstContrato = [SELECT id, status, ContractTerm FROM Contract WHERE ContractTerm = 12];
        Contract contrato = lstContrato.get(0);
        contrato.status = 'Autorizado';
        update contrato;

        list<Account> lstConta = [SELECT id FROM Account];
        List<Item_do_Contrato__c> lstItem = [SELECT id FROM Item_do_Contrato__c];
        list<Case> lstCaso = [SELECT id FROM Case];
        AssociarCasoCTRL.salvarCaso(lstConta.get(0).id, lstCaso.get(0).id, lstItem.get(0).id);
    }


    @isTest public static void salvarCasoTest2(){

        list<Account> lstConta = [SELECT id FROM Account];
        list<Case> lstCaso = [SELECT id FROM Case];
        AssociarCasoCTRL.salvarCaso(lstConta.get(0).id, lstCaso.get(0).id, null );
    }
}