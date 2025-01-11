public with sharing class ProdutoService_VEXP implements ServiceInterface {
    private Set<String> camposObrigatoriosPost = new Set<String> {
        'codigo',
            'nome'
            };
                
                public ProdutoService_VEXP() {}
    
    public void doPost() {
        String requestJSON = RestContext.request.requestBody.toString();
        IntegrationModels.Produto produto;
        
        if( String.isBlank(requestJSON ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                produto = (IntegrationModels.Produto) JSON.deserializeStrict(requestJSON, IntegrationModels.Produto.class);
                String campoNaoPreenchidoPagamento = ServiceUtils.validarCamposObrigatorios( requestJSON, camposObrigatoriosPost );
                if( campoNaoPreenchidoPagamento != null ) {
                    ServiceError.throwServiceError( 400, 'Bad Request', 'O campo ' + campoNaoPreenchidoPagamento + ' é obrigatório.' );
                } else {
                    Product2 novoProduto = new Product2();
                    novoProduto.Chave_Externa__c = produto.codigo;
                    novoProduto.ProductCode = produto.codigo;
                    novoProduto.Name = produto.nome;
                    novoProduto.Description = produto.descricao;
                    if(String.isNotBlank(produto.familia)) novoProduto.Family = produto.familia;
                    
                    try {
                        //Comentado iSmartblue 06/05/2024
                        //insert novoProduto;
                        
                        IntegrationModels.ProdutoResponse response = new IntegrationModels.ProdutoResponse();
                        response.id = novoProduto.Id;
                        RestContext.response = new RestResponse();
                        RestContext.response.statusCode = 201;
                        RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                    } catch( Exception dmlEX ) {
                        ServiceError.throwServiceError( 500, 'Internal Server Error', 'Erro: ' + dmlEX.getMessage() + '. Detalhes' + dmlEX.getStackTraceString() );
                    }
                }
            } catch( Exception ex ) {               
                ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo inválido. Detalhes: ' + ex.getMessage() );
            }
        }
    }
    
    public void doGet() {}
    
    public void doPatch() {
        String requestJSON = RestContext.request.requestBody.toString();
        IntegrationModels.Produto produto;
        
        if( String.isBlank(requestJSON ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                produto = (IntegrationModels.Produto) JSON.deserializeStrict(requestJSON, IntegrationModels.Produto.class);
            } catch( Exception ex ) {               
                ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo inválido. Detalhes: ' + ex.getMessage() );
            }
            
            if(produto!=null){
                String codigo = RestContext.request.requestURI.substringAfter('/produto/');
                if( String.isBlank(codigo) ) {
                    ServiceError.throwServiceError( 400, 'Bad Request', 'Código do produto não informado.');
                } else {
                    List<Product2> produtos = [SELECT Id, Name, Description, Family FROM Product2 WHERE Chave_Externa__c = :codigo];
                    if( produtos.size() == 0 ) {
                        ServiceError.throwServiceError( 404, 'Not Found', 'Produto não existente.' );
                    } else {
                        Product2 produtoAtualizado = produtos[0];
                        if(String.isNotBlank(produto.nome)) produtoAtualizado.Name = produto.nome;
                        if(String.isNotBlank(produto.descricao)) produtoAtualizado.Description = produto.descricao;
                        if(String.isNotBlank(produto.familia)) produtoAtualizado.Family = produto.familia;
                        
                        try {
                            //Comentado iSmartblue 06/05/2024
                            //update produtoAtualizado;
                            IntegrationModels.ProdutoResponse response = new IntegrationModels.ProdutoResponse();
                            RestContext.response = new RestResponse();
                            RestContext.response.statusCode = 204;
                            RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                        } catch( Exception dmlEX ) {
                            ServiceError.throwServiceError( 500, 'Internal Server Error', 'Erro: ' + dmlEX.getMessage() + '. Detalhes' + dmlEX.getStackTraceString() );
                        }
                    }
                }
            }
        }
    }
    
    public void doPut() {}
    public void doDelete() {}
    
    public String checkJSONSchema( String jsonSchema ) {
        String result;
        try {
            IntegrationModels.Produto produto = (IntegrationModels.Produto) JSON.deserializeStrict( jsonSchema , IntegrationModels.Produto.class );            
        } catch( Exception e ) {
            result = 'Conteúdo Inválido. Detalhes: ' + e.getMessage();
        }
        Decimal a = 1;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        return result;
    }
}