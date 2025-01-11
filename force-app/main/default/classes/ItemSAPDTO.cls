public class ItemSAPDTO extends GenericApiDTO{

    public List<Response> value = new List<Response>();

    public class Response {
        public String ItemCode;
        public String ItemName;
        public String InventoryUOM;
        public String Valid;
        public String UpdateDate;
        public String U_Vertical;
        public String U_UtilizacaoSalesforce;        
    }
}