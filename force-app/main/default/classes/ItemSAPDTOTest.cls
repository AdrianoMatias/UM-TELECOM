@isTest
public class ItemSAPDTOTest {
	@isTest
    static void testMethod1(){
        ItemSAPDTO dto = new ItemSAPDTO();
        ItemSAPDTO.Response resp = new ItemSAPDTO.Response();

        resp.ItemCode = '1234';
        resp.ItemName = 'Teste';
        resp.InventoryUOM = 'UN';
        resp.Valid = 'true';
        resp.UpdateDate = '01-01-1990';
        resp.U_Vertical = 'V';
        resp.U_UtilizacaoSalesforce = 'C';
        
        dto.value.add(resp);
        
        System.assertEquals(dto.value[0].ItemCode, '1234');
        System.assertEquals(dto.value[0].ItemName, 'Teste');
        System.assertEquals(dto.value[0].InventoryUOM, 'UN');
        System.assertEquals(dto.value[0].Valid, 'true');
        System.assertEquals(dto.value[0].UpdateDate, '01-01-1990');
        System.assertEquals(dto.value[0].U_Vertical, 'V');
        System.assertEquals(dto.value[0].U_UtilizacaoSalesforce, 'C');       
    }
}