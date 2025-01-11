public class FaturaSAPService extends ServiceBase {

    public final String endpoint;

    public final String method;    

    public FaturaSAPService() {
        super(FaturaSAPService.class);
    }
    
    public FaturaSAPDTO executarGet() {
        
        FaturaSAPDTO faturaSAPDTO = new FaturaSAPDTO();
        
        try {
            API_Settings__mdt config = API_Settings__mdt.getInstance('ApiFaturasSAP');
            Integer days = config?.LastNDays__c != null ? Integer.valueOf(config.LastNDays__c) : 3;
            DateTime dt_execucao = DateTime.now();
            String date_from = dt_execucao.addDays(-days).format('yyyyMMdd');
            String date_to = dt_execucao.format('yyyyMMdd');
            
            String queryParameter = '/FATURAMENTOParameters%28dtInicial=%27'+ date_from +'%27%2CdtFinal=%27' + date_to + '%27%29/FATURAMENTO'; 
            HttpResponse oResponse = this.api.executarGet('ApiFaturasSAP', queryParameter);
            
            switch on oResponse.getStatusCode() {
                when 200 {
                    faturaSAPDTO = (FaturaSAPDTO) JSON.deserialize(oResponse.getBody(), FaturaSAPDTO.class);
                }
                when else {
                    faturaSAPDTO.message = 'Erro ao executar integração com SAP [' + oResponse.getStatusCode() + ']';
                }
            }
            
            setResponseData(faturaSAPDTO, oResponse);
        }
        catch (Exception ex) {
            faturaSAPDTO.message = 'Erro ao executar integração com SAP: ' + ex.getMessage();
        }
        
        insert ControleDeServicoBO.getInstance().gerarLogPai(faturaSAPDTO.statusCode == 200 ? 'Sucesso' : 'Erro', 'FaturaSAPService', 'GET', EncodingUtil.urlDecode(this.api?.endpoint, 'UTF-8'), JSON.serialize(faturaSAPDTO), faturaSAPDTO.message, faturaSAPDTO.statusCode, System.Now(), true);
        
        return faturaSAPDTO;
    }
}