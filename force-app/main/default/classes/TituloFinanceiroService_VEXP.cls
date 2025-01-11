public with sharing class TituloFinanceiroService_VEXP implements ServiceInterface {
    private Set<String> camposObrigatoriosPost = new Set<String> {
		'contrato',
        'codigoCliente',
        'competencia',
        'fatura',
        'boletoID',
        'emissao',
        'vencimento',
        'valorFatura',
        'status'
	};

    public TituloFinanceiroService_VEXP() {}

    public void doPost() {
        String requestJSON = RestContext.request.requestBody.toString();
        IntegrationModels.TituloFinanceiro tituloFinanceiro;
        
        if( String.isBlank(requestJSON ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                tituloFinanceiro = (IntegrationModels.TituloFinanceiro) JSON.deserializeStrict(requestJSON, IntegrationModels.TituloFinanceiro.class);
                String campoNaoPreenchido = ServiceUtils.validarCamposObrigatorios( requestJSON, camposObrigatoriosPost );
                if( campoNaoPreenchido != null ) {
                    ServiceError.throwServiceError( 400, 'Bad Request', 'O campo ' + campoNaoPreenchido + ' é obrigatório.' );
                } else {
                    String codigoContrato = String.valueOf(tituloFinanceiro.contrato);
                    String fatura = String.valueOf(tituloFinanceiro.fatura);
                    String codigoTitulo = codigoContrato+fatura;
                    Date emissao = Date.valueOf(tituloFinanceiro.emissao);
                    Date vencimento = Date.valueOf(tituloFinanceiro.vencimento);

                    Titulo_Financeiro__c novoTitulo = new Titulo_Financeiro__c();
                    novoTitulo.Name = codigoTitulo;
                    novoTitulo.Codigo_Cliente__c = tituloFinanceiro.codigoCliente;
                    novoTitulo.Codigo_Contrato__c = codigoContrato;
                    novoTitulo.Competencia__c = tituloFinanceiro.competencia;
                    novoTitulo.Fatura__c = tituloFinanceiro.fatura;
                    novoTitulo.BoletoID__c = tituloFinanceiro.boletoID;
                    novoTitulo.Emissao__c = emissao;
                    novoTitulo.Vencimento__c = vencimento;
                    novoTitulo.Valor_Fatura__c = tituloFinanceiro.valorFatura;
                    novoTitulo.Valor_Pago__c = tituloFinanceiro.valorPago;
                    novoTitulo.Status__c = tituloFinanceiro.status;

                    List<Account> listaConta = [SELECT Id FROM Account WHERE Codigo_SAP_cliente__c = :tituloFinanceiro.CodigoCliente];
                    if(listaConta.size()>0) novoTitulo.Conta__c = listaConta.get(0).Id;

                    List<Contract> listaContrato = [SELECT Id FROM Contract WHERE Codigo_do_contrato__c = :codigoContrato];
                    if(listaContrato.size()>0) novoTitulo.Contrato__c = listaContrato.get(0).Id;

                    try {
                        //Comentado iSmartblue 06/05/2024
                        //insert novoTitulo;

                        IntegrationModels.TituloFinanceiroResponse response = new IntegrationModels.TituloFinanceiroResponse();
                        response.codigoTitulo = novoTitulo.Name;
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
        IntegrationModels.TituloFinanceiro tituloFinanceiro;
        
        if( String.isBlank(requestJSON ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                tituloFinanceiro = (IntegrationModels.TituloFinanceiro) JSON.deserializeStrict(requestJSON, IntegrationModels.TituloFinanceiro.class);
            } catch( Exception ex ) {               
                ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo inválido. Detalhes: ' + ex.getMessage() );
            }

            if(tituloFinanceiro!=null){
                String codigoCliente = RestContext.request.requestURI.substringAfter('/titulo-financeiro/');
                if( String.isBlank(codigoCliente) ) {
                    ServiceError.throwServiceError( 400, 'Bad Request', 'Código do cliente não informado.');
                } else {
                    if(!(tituloFinanceiro.contrato>0) && !(tituloFinanceiro.fatura>0)) {
                        ServiceError.throwServiceError( 400, 'Bad Request', 'Contrato ou Fatura não informados.');
                    }else{
                        String codigoContrato = String.valueOf(tituloFinanceiro.contrato);
                        String fatura = String.valueOf(tituloFinanceiro.fatura);
                        String codigoTitulo = codigoContrato+fatura;
                        List<Titulo_Financeiro__c> titulos = [SELECT Id, Competencia__c, BoletoID__c, Emissao__c, Vencimento__c, Valor_Fatura__c, Valor_Pago__c, Status__c FROM Titulo_Financeiro__c WHERE Name = :codigoTitulo AND Codigo_Cliente__c = :codigoCliente];
						if( titulos.size() == 0 ) {
                            ServiceError.throwServiceError( 404, 'Not Found', 'Título Financeiro não encontrado.' );
                        } else {
                            Titulo_Financeiro__c tituloAtualizado = titulos[0];
                            if(String.isNotBlank(tituloFinanceiro.competencia)) tituloAtualizado.Competencia__c = tituloFinanceiro.competencia;
                            if(tituloFinanceiro.boletoID != null) tituloAtualizado.BoletoID__c = tituloFinanceiro.boletoID;
                            if(String.isNotBlank(tituloFinanceiro.emissao)) tituloAtualizado.Emissao__c = Date.valueOf(tituloFinanceiro.emissao);
                            if(String.isNotBlank(tituloFinanceiro.vencimento)) tituloAtualizado.Vencimento__c = Date.valueOf(tituloFinanceiro.vencimento);
                            if(tituloFinanceiro.valorFatura != null) tituloAtualizado.Valor_Fatura__c = tituloFinanceiro.valorFatura;
                            if(tituloFinanceiro.valorPago != null) tituloAtualizado.Valor_Pago__c = tituloFinanceiro.valorPago;
                            if(String.isNotBlank(tituloFinanceiro.status)) tituloAtualizado.Status__c = tituloFinanceiro.status;

                            try {
                                //Comentado iSmartblue 06/05/2024
                                //update tituloAtualizado;
                                IntegrationModels.TituloFinanceiroResponse response = new IntegrationModels.TituloFinanceiroResponse();
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
    }

    public void doPut() {}
    public void doDelete() {}

    public String checkJSONSchema( String jsonSchema ) {
        String result;
        try {
            IntegrationModels.TituloFinanceiro tituloFinanceiro = (IntegrationModels.TituloFinanceiro) JSON.deserializeStrict( jsonSchema , IntegrationModels.TituloFinanceiro.class );            
        } catch( Exception e ) {
            result = 'Conteúdo Inválido. Detalhes: ' + e.getMessage();
        }

        return result;
    }
}