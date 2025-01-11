@isTest
public class FaturaSAPDTOTest {
	@isTest
    static void testMethod1(){
        FaturaSAPDTO dto = new FaturaSAPDTO();
        FaturaSAPDTO.Response resp = new FaturaSAPDTO.Response();

        resp.CodigoDoCliente = '1234';
        resp.ContratoSAP = 'Teste';
        resp.DataDeLancamentoNF = '01-01-1990';
        resp.DataDeRecebimento = '01-01-1990';
        resp.DataDeVencimentoNF = '01-02-1990';
        resp.MeioDePagamento = 'Boleto';
        resp.NumeroDaNota = 99;
        resp.PeriodoReferencialFinal = '01-01-1990';
        resp.PeriodoReferencialInicial = '01-02-1990';
        resp.SaldoEmAbertoNF = 1000;
        resp.StatusDaNF = 'Pago';
        resp.TipoDeNota = 'V';
        resp.ValorDaNF = 50000;
        resp.ValorRecebidoNF = 50000;
        
        dto.value.add(resp);

        System.assertEquals(dto.value[0].CodigoDoCliente, '1234');
        System.assertEquals(dto.value[0].ContratoSAP, 'Teste');
        System.assertEquals(dto.value[0].DataDeLancamentoNF, '01-01-1990');
        System.assertEquals(dto.value[0].DataDeRecebimento, '01-01-1990');
        System.assertEquals(dto.value[0].DataDeVencimentoNF, '01-02-1990');
        System.assertEquals(dto.value[0].MeioDePagamento, 'Boleto');
        System.assertEquals(dto.value[0].NumeroDaNota, 99);
        System.assertEquals(dto.value[0].PeriodoReferencialFinal, '01-01-1990');
        System.assertEquals(dto.value[0].PeriodoReferencialInicial, '01-02-1990');
        System.assertEquals(dto.value[0].SaldoEmAbertoNF, 1000);
        System.assertEquals(dto.value[0].StatusDaNF, 'Pago');
        System.assertEquals(dto.value[0].TipoDeNota, 'V');
        System.assertEquals(dto.value[0].ValorDaNF, 50000);
        System.assertEquals(dto.value[0].ValorRecebidoNF, 50000);
    }
}