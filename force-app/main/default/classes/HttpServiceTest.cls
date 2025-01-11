@isTest
public with sharing class HttpServiceTest {

    @isTest    
    static void testHttpServiceTest()
    {
        Test.startTest();
            
            Map<String,String> mapHeader = new Map<String,String>{ 'Content-Type'=> 'application/json'};
            
            OAuth2DTO oApiOAuthTO = new OAuth2DTO();

            HttpService oHttpService = new HttpService( oApiOAuthTO, HttpServiceTest.class );

            Test.setMock(HttpCalloutMock.class, new GenericResponse('get1', 200, mapHeader)); 
            HttpResponse oHttpResponseGet1 = oHttpService.executarGet('ApiAutenticacaoSAP', 'get1');

            Test.setMock(HttpCalloutMock.class, new GenericResponse('get2', 200, mapHeader)); 
            HttpResponse oHttpResponseGet2 = oHttpService.executarGet('ApiAutenticacaoSAP', 'get2', mapHeader);

            Test.setMock(HttpCalloutMock.class, new GenericResponse('post1', 200, mapHeader)); 
            HttpResponse oHttpResponsePost1 = oHttpService.executarPost('ApiAutenticacaoSAP', 'post1', 'post1');

            Test.setMock(HttpCalloutMock.class, new GenericResponse('post2', 200, mapHeader)); 
            HttpResponse oHttpResponsePost2 = oHttpService.executarPost('ApiAutenticacaoSAP', 'post2', 'post2', mapHeader);

            Test.setMock(HttpCalloutMock.class, new GenericResponse('put1', 200, mapHeader)); 
            HttpResponse oHttpResponsePut1 = oHttpService.executarPut('ApiAutenticacaoSAP', 'put1', 'put1');
            
            Test.setMock(HttpCalloutMock.class, new GenericResponse('put2', 200, mapHeader)); 
            HttpResponse oHttpResponsePut2 = oHttpService.executarPut('ApiAutenticacaoSAP', 'put2', 'put2', mapHeader);        
            
            Test.setMock(HttpCalloutMock.class, new GenericResponse('patch1', 200, mapHeader)); 
            HttpResponse oHttpResponsePatch1 = oHttpService.executarPatch('ApiAutenticacaoSAP', 'patch1', 'patch1');
            
            Test.setMock(HttpCalloutMock.class, new GenericResponse('patch2', 200, mapHeader)); 
            HttpResponse oHttpResponsePatch2 = oHttpService.executarPatch('ApiAutenticacaoSAP', 'patch2', 'patch2', mapHeader);             

            Test.setMock(HttpCalloutMock.class, new GenericResponse('delete1', 200, mapHeader)); 
            HttpResponse oHttpResponseDelete1 = oHttpService.executarDelete('ApiAutenticacaoSAP', 'delete1', 'delete1');
            
            Test.setMock(HttpCalloutMock.class, new GenericResponse('delete2', 200, mapHeader)); 
            HttpResponse oHttpResponseDelete2 = oHttpService.executarDelete('ApiAutenticacaoSAP', 'delete1', 'delete1', mapHeader);            

            // Error
            Test.setMock(HttpCalloutMock.class, new GenericResponse('deleteFailed', 200, mapHeader)); 
            HttpResponse oHttpResponseDeleteFailed = oHttpService.executarDelete(null, 'delete1', 'delete1', mapHeader);                 

        Test.stopTest();

        System.assertEquals('get1', oHttpResponseGet1.getBody(), 'Diferente de get1');
        System.assertEquals('get2', oHttpResponseGet2.getBody(), 'Diferente de get2.');
        System.assertEquals('post1', oHttpResponsePost1.getBody(), 'Diferente de post1.');
        System.assertEquals('post2', oHttpResponsePost2.getBody(), 'Diferente de post2.');
        System.assertEquals('put1', oHttpResponsePut1.getBody(), 'Diferente de put1.');
        System.assertEquals('put2', oHttpResponsePut2.getBody(), 'Diferente de put2.');
        System.assertEquals('patch1', oHttpResponsePatch1.getBody(), 'Diferente de patch1.');
        System.assertEquals('patch2', oHttpResponsePatch2.getBody(), 'Diferente de patch2.');
        System.assertEquals('delete1', oHttpResponseDelete1.getBody(), 'Diferente de delete1.');
        System.assertEquals('delete2', oHttpResponseDelete2.getBody(), 'Diferente de delete2.');        
        System.assertEquals(true, oHttpResponseDeleteFailed.getBody().contains(HttpService.NAMED_CREDENTIALS_NOT_FOUND), 'Deve conter: ' + HttpService.NAMED_CREDENTIALS_NOT_FOUND);    
        System.assertEquals(500, oHttpResponseDeleteFailed.getStatusCode(), 'Deve set 500');  
        System.assertEquals('Internal Server Error', oHttpResponseDeleteFailed.getStatus(), 'Deve ser Internal Server Error');  
    }
}