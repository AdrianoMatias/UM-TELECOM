public class ItemSAPService extends ServiceBase {

	public final String endpoint;

    public final String method;
    
    public ItemSAPService() {
        super(ItemSAPService.class);
    }
    
    public ItemSAPDTO executarGet() {
        
        ItemSAPDTO productSAPTO = new ItemSAPDTO();
        
        try {
            API_Settings__mdt config = API_Settings__mdt.getInstance('ApiItemsSAP');
            Integer days = config?.LastNDays__c != null ? Integer.valueOf(config.LastNDays__c) : 3;
            DateTime dt_execucao = DateTime.now();
            String date_from = dt_execucao.addDays(-days).format('yyyy-MM-dd');
            
            String queryParameter = '$select=ItemCode,ItemName,InventoryUOM,Valid,U_Vertical,U_UtilizacaoSalesforce,UpdateDate&$filter=U_UtilizacaoSalesforce ne \'NA\' and UpdateDate ge \'' + date_from + '\' '; 
            HttpResponse oResponse = this.api.executarGet('ApiItemsSAP', '?' + EncodingUtil.urlEncode(queryParameter, 'UTF-8'));
            
            switch on oResponse.getStatusCode() {
                when 200 {
                    productSAPTO = (ItemSAPDTO) JSON.deserialize(oResponse.getBody(), ItemSAPDTO.class);
                }
                when else {
                    productSAPTO.message = 'Erro ao executar integração com SAP [' + oResponse.getStatusCode() + ']';
                }
            }
            
            setResponseData(productSAPTO, oResponse);
        }
        catch (Exception ex) {
            productSAPTO.message = 'Erro ao executar integração com SAP: ' + ex.getMessage();
        }
        
		insert ControleDeServicoBO.getInstance().gerarLogPai(productSAPTO.statusCode == 200 ? 'Sucesso' : 'Erro', 'ItemSAPService', 'GET', EncodingUtil.urlDecode(this.api?.endpoint, 'UTF-8'), JSON.serialize(productSAPTO), productSAPTO.message, productSAPTO.statusCode, System.Now(), true);
        
        return productSAPTO;
    }
}