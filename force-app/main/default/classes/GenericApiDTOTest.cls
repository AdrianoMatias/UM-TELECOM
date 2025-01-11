@isTest
public class GenericApiDTOTest {
	@isTest
    static void testMethod1(){
        GenericApiDTO dto = new GenericApiDTO();
        dto.message = 'Sucesso';
        dto.statusCode = 201;
        dto.status = 'Sucesso';
        
        System.assertEquals(dto.message, 'Sucesso');
        System.assertEquals(dto.statusCode, 201);
        System.assertEquals(dto.status, 'Sucesso');
    }
}