public class FaturaSAPDTO extends GenericApiDTO{

    public List<Response> value = new List<Response>();

    public class Response {
        public String CodigoDoCliente;
        public String ContratoSAP;
        public String DataDeLancamentoNF;
        public String DataDeRecebimento;
        public String DataDeVencimentoNF;
        public String MeioDePagamento;
        public Integer NumeroDaNota;        
        public String PeriodoReferencialFinal;
        public String PeriodoReferencialInicial;
        public Decimal SaldoEmAbertoNF;
        public String StatusDaNF;
        public String TipoDeNota;
        public Decimal ValorDaNF;
        public Decimal ValorRecebidoNF;
    }
}