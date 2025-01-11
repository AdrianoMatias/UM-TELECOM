public with sharing class AssociarCasoCTRL {

    @AuraEnabled
    public static Case getCaso( String idCaso ) {
        return [Select Id, Contrato__c, Item_do_Contrato__c, AccountId, Account.Grupo__c, Grupo__c from Case where Id = :idCaso];
    }

    @AuraEnabled
    public static List<Contract> buscarContratos( String idConta ) {
        return [Select Id, Name, ContractNumber, Status, Account.Grupo__c, Grupo__c  from Contract where AccountId = :idConta];
    }

    @AuraEnabled
    public static List<Item_do_Contrato__c> buscarItensContrato( String idConta, String idContrato ){

        // Campos: Número do Contrato - Número do Circuito - Produto - Banda - Endereço de Destino (logradouro, bairro, cidade, uf) - Status
        String query = 'Select Id, Name, Produto__r.Name, Numero_do_Circuito__c, Contrato__r.ContractNumber, Banda__c, Endereco_de_Destino__c, Status__c, Contrato__r.Grupo__c from Item_do_Contrato__c where Contrato__r.AccountId = :idConta';
        query += idContrato != null ? ' AND Contrato__c = :idContrato' : '';
        query += ' ORDER BY Contrato__r.ContractNumber, Name';
        return Database.query( query );
    }

    @AuraEnabled
    public static void salvarCaso(String idConta, String idCaso, String idItem){
        List<Account> contas = [Select Id, Name from Account where Id = :idConta];
        Account conta = contas.size() > 0 ? contas[0] : null;
        if( String.isBlank( idItem ) && ( conta != null && !conta.Name.containsIgnoreCase('umtelecom') && !conta.Name.containsIgnoreCase('1telecom') ) || (String.isBlank( idItem ) && conta == null) ) {
            throw new AuraHandledException('É necessário informar o Item do Contrato');
        } else {
            if( String.isNotBlank( idItem ) ) {
                Item_do_Contrato__c item = [Select Id, Contrato__r.Status, Status__c from Item_do_Contrato__c where Id =:idItem];        
                if( item.Contrato__r.Status != 'AUTORIZADO' ) {
                    throw new AuraHandledException('Apenas contratos com status AUTORIZADO podem abrir chamados');
                } else if( item.Status__c != 'INICIADO' ) {
                    throw new AuraHandledException('Apenas itens com status INICIADO podem abrir chamados');
                } else {                
                    Case caso = new Case();
                    caso.Id = idCaso;
                    caso.Item_do_Contrato__c = idItem;
                    update caso;
                }
            } else if( idConta != null ) {
                Case caso = new Case();
                caso.Id = idCaso;
                caso.AccountId = idConta;
                update caso;
            }
        }
    }

}