public class FaturaSAPHelper {

    public class FaturaSAPHelperException extends Exception {}
    
    public static void validate(FaturaSAPDTO.Response obj, Map<String, Account> mapAccount, Map<String, Contract> mapContract){

        if(String.isBlank(obj.CodigoDoCliente)){
            throw new FaturaSAPHelperException('CodigoDoCliente não pode ser vazio');
        }

        if(String.isBlank(obj.ContratoSAP)){
            throw new FaturaSAPHelperException('ContratoSAP não pode ser vazio');
        }
        
        if(!mapAccount.containsKey(obj.CodigoDoCliente)){
            throw new FaturaSAPHelperException('CodigoDoCliente não encontrado - ' + obj.CodigoDoCliente);
        }
        
        if(!mapContract.containsKey(obj.ContratoSAP)){
            throw new FaturaSAPHelperException('ContratoSAP não encontrado - ' + obj.ContratoSAP);
        } 
    }

    public static Fatura__c createObject(FaturaSAPDTO.Response obj, Map<String, Account> mapAccount, Map<String, Contract> mapContract){
        Fatura__c fat = new Fatura__c();
        
        String periodo;
        
        if(!String.isBlank(obj.PeriodoReferencialInicial) && !String.isBlank(obj.PeriodoReferencialFinal)){
            String periodoInicial = Date.valueOf(obj.PeriodoReferencialInicial).format();
            String periodoFinal = Date.valueOf(obj.PeriodoReferencialFinal).format();
            
            periodo = periodoInicial + ' a ' + periodoFinal;
        }
        
        fat.Conta__c = mapAccount.get(obj.CodigoDoCliente).Id;
        fat.Contrato__c = mapContract.get(obj.ContratoSAP).Id;    
        fat.DataDeLancamento__c = !String.isBlank(obj.DataDeLancamentoNF) ? Date.valueOf(obj.DataDeLancamentoNF) : null;
        fat.DataDeRecebimento__c = !String.isBlank(obj.DataDeRecebimento) ? Date.valueOf(obj.DataDeRecebimento) : null;
        fat.DataDeVencimento__c = !String.isBlank(obj.DataDeVencimentoNF) ? Date.valueOf(obj.DataDeVencimentoNF) : null;
        fat.MeioDePagamento__c = obj.MeioDePagamento;
        fat.NumeroFaturaSAP__c = obj.NumeroDaNota;
        fat.PeriodoDeUtilizacao__c = periodo;
        //fat.SaldoEmAberto__c = obj.SaldoEmAbertoNF; //Field is not writeable
        fat.StatusDaFatura__c = obj.StatusDaNF;
        fat.TipoDeFatura__c = obj.TipoDeNota;
        fat.ValorDaFatura__c = obj.ValorDaNF;
        fat.ValorRecebido__c = obj.ValorRecebidoNF;            
        
        return fat;
    }
}