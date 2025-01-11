@isTest
global class HttpCalloutMockImpl implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"atividade_principal":[{"text":"Restaurantesesimilares","code":"56.11-2-01"}],"data_situacao":"21/11/2003","nome":"RESTAURANTETASANYUENLTDA","uf":"PE","qsa":[{"qual":"49-Sócio-Administrador","nome":"CHANYUKYING"},{"qual":"49-Sócio-Administrador","nome":"CHANSHUNMING"},{"qual":"22-Sócio","nome":"CHUIKWOKCHOI"}],"situacao":"ATIVA","bairro":"ESPINHEIRO","logradouro":"RQUARENTAEOITO","numero":"623","cep":"52.050-380","municipio":"RECIFE","abertura":"13/06/1984","natureza_juridica":"206-2-SociedadeEmpresáriaLimitada","cnpj":"01.002.003/0004-05","ultima_atualizacao":"2018-06-08T22:38:11.244Z","status":"OK","tipo":"MATRIZ","fantasia":"","complemento":"","email":"","telefone":"","efr":"","motivo_situacao":"","situacao_especial":"","data_situacao_especial":"","atividades_secundarias":[{"code":"00.00-0-00","text":"Nãoinformada"}],"capital_social":"151000.00","extra":{},"billing":{"free":true,"database":true}}');
        res.setStatusCode(200);
        return res;
    }
    
}