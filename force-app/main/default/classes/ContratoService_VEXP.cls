public with sharing class ContratoService_VEXP implements ServiceInterface{

	private Set<String> camposObrigatoriosPost = new Set<String> {
		'dia_vencimento',
        'descricao',
        'data_inicio',
        'cortesia',
		'permuta',
        'valido_ate',
		'codigo_contrato',
        'itens'
	};

	private Set<String> camposObrigatoriosPostItem = new Set<String> {
		'numero_item',
        'circuito',
        'status',
        'valor',
        'banda',
        'enderecos'
	};

	private Set<String> camposObrigatoriosPostEnderecos = new Set<String> {
        'tipo_logradouro',
        'logradouro',
        'numero',
        'complemento',
		'bairro',
        'cidade',
        'estado',
		'cep'
	};

    public ContratoService_VEXP() {}

    public void doPost(){
        String requestJSON = RestContext.request.requestBody.toString();
        IntegrationModels.Contrato contrato;
        if(String.isBlank(requestJSON)){
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                contrato = (IntegrationModels.Contrato) JSON.deserializeStrict(requestJSON, IntegrationModels.Contrato.class);
                System.debug('Contrato>>'+contrato);

				if(contrato.itens.size() == 0) {
					ServiceError.throwServiceError( 400, 'Bad Request', 'Contrato não possui itens.');
				}else{
					String campoNaoPreenchido = ServiceUtils.validarCamposObrigatorios( requestJSON, camposObrigatoriosPost );
					if(campoNaoPreenchido != null) {
						ServiceError.throwServiceError( 400, 'Bad Request', 'O campo ' + campoNaoPreenchido + ' é obrigatório.' );
					} else {
						Boolean enderecoNull = false;
						String campoNaoPreenchidoItem;
						String campoNaoPreenchidoEndereco;
						for(Integer i=0; i<contrato.itens.size(); i++){
							campoNaoPreenchidoItem = ServiceUtils.validarCamposObrigatorios(JSON.serialize(contrato.itens[i]), camposObrigatoriosPostItem);
							if(contrato.itens[i].enderecos == null){
								enderecoNull=true;
							}else{
								for(Integer j=0; j<contrato.itens[i].enderecos.size(); j++){
									campoNaoPreenchidoEndereco = ServiceUtils.validarCamposObrigatorios(JSON.serialize(contrato.itens[i].enderecos[j]), camposObrigatoriosPostEnderecos);
								System.debug('>>>>>'+campoNaoPreenchidoEndereco);
								}
							}
							System.debug('>>>>>'+campoNaoPreenchidoItem);
						}
						if(campoNaoPreenchidoItem != null) {
							ServiceError.throwServiceError( 400, 'Bad Request', 'O campo ' + campoNaoPreenchidoItem + ' é obrigatório.' );
						}else{
						
							if(campoNaoPreenchidoEndereco != null) {
								ServiceError.throwServiceError( 400, 'Bad Request', 'O campo ' + campoNaoPreenchidoEndereco + ' é obrigatório.' );
							}else{ 
								if(enderecoNull) {
									ServiceError.throwServiceError( 400, 'Bad Request', 'O endereço é obrigatório.' );
								}else{ 

									String codigoCliente = RestContext.request.requestURI.substringAfter('/contrato/');
									if(String.isBlank(codigoCliente)) {
										ServiceError.throwServiceError( 400, 'Bad Request', 'Código do item do contrato não informado.');
									} else {

										List<Account> contaList = [Select Id FROM Account WHERE Codigo_SAP_cliente__c =: codigoCliente];
						
										if(contaList.isEmpty()){
											ServiceError.throwServiceError( 404, 'Not found', 'Código da conta não encontrado.');
										}else{
											Account conta = contaList.get(0); 
											List<Solicitacao_Diversa__c> SolDiversa = [Select Id, Name, Contrato__c, Contrato__r.ContractNumber FROM Solicitacao_Diversa__c WHERE Conta__c = :conta.Id AND Tipo_de_Solicitacao__c = : 'Troca de titularidade' AND (Status__c =: 'Aberto' OR Status__c =: 'Em andamento') ];
											System.debug('SolDiversa'+SolDiversa);
											if(SolDiversa.isEmpty()){
												ServiceError.throwServiceError( 404, 'Bad Request', 'Não foi encontrada uma solicitação diversa aberta.');
											}else{

												Date inicio = Date.valueOf(contrato.data_inicio);
												Date fim = Date.valueOf(contrato.valido_ate);
												Integer diferenca = inicio.monthsBetween(fim);
												if (fim.day() > inicio.day()) diferenca++;
											
												Contract contratoIns = new Contract();
												contratoIns.Description = contrato.descricao;
												contratoIns.StartDate = inicio;
												contratoIns.Codigo_do_contrato__c = contrato.codigo_contrato;
												contratoIns.Permuta__c = (contrato.permuta=='S' ? true : false);
												contratoIns.Cortesia__c = (contrato.cortesia=='S' ? true : false);
												contratoIns.ContractTerm = diferenca;
												contratoIns.AccountId = conta.Id;
											
												List<Item_do_Contrato__c> listItem = new List<Item_do_Contrato__c>();
												Boolean produtoNaoEncontrado = false;
												System.debug(contrato.itens.size());
												for(Integer i=0; i<contrato.itens.size(); i++){
												
													Integer bandaProduto = Integer.valueOf(contrato.itens[i].banda)/1024;
													List<Product2> lProduto = [Select Id, Name FROM Product2 WHERE ProductCode =:contrato.itens[i].numero_item AND (De__c <=: bandaProduto AND Ate__c>=:bandaProduto)];
													System.debug('Entrou aqui>>>> '+bandaProduto);
													if(lProduto.isEmpty()){
														produtoNaoEncontrado = true;
													}else{
														Item_do_Contrato__c item = new Item_do_Contrato__c();
														item.Name =  lProduto.get(0).Name;
														item.Produto__c = lProduto.get(0).Id;
														item.Banda__c = bandaProduto;
														item.Valor__c = contrato.itens[i].valor;
														item.Numero_do_circuito__c = contrato.itens[i].circuito;
														item.Ultima_acao_contratual__c = contrato.itens[i].controle_alteracao;
														item.Dia_de_Vencimento__c = String.valueOf(contrato.dia_vencimento);
														item.Status__c = contrato.itens[i].status;

														if(contrato.itens[i].enderecos != null && contrato.itens[i].enderecos.size()>0){
													
															item.Tipo_de_logradouro_de_origem__c = contrato.itens[i].enderecos[0].tipo_logradouro;
															item.numero_de_origem__c	= contrato.itens[i].enderecos[0].numero;
															item.Rua_de_origem__c	= contrato.itens[i].enderecos[0].logradouro;
															item.Estado_de_origem__c = contrato.itens[i].enderecos[0].estado;
															item.Complemento_de_origem__c = contrato.itens[i].enderecos[0].complemento;
															item.Cidade_de_origem__c = contrato.itens[i].enderecos[0].cidade;
															item.CEP_de_origem__c = contrato.itens[i].enderecos[0].cep;
															item.Bairro_de_origem__c = contrato.itens[i].enderecos[0].bairro;
												
															if(contrato.itens[i].enderecos.size()==2){
								
																item.Tipo_de_logradouro_de_destino__c = contrato.itens[i].enderecos[1].tipo_logradouro;
																item.numero_de_destino__c	= contrato.itens[i].enderecos[1].numero;
																item.Rua_de_destino__c	= contrato.itens[i].enderecos[1].logradouro;
																item.Estado_de_destino__c = contrato.itens[i].enderecos[1].estado;
																item.Complemento_de_destino__c = contrato.itens[i].enderecos[1].complemento;
																item.Cidade_de_destino__c = contrato.itens[i].enderecos[1].cidade;
																item.CEP_de_destino__c = contrato.itens[i].enderecos[1].cep;
																item.Bairro_de_destino__c = contrato.itens[i].enderecos[1].bairro;

															}
														}
														System.debug('Item >>>' +item);
														listItem.add(item);
														}
													}
													if(produtoNaoEncontrado){
														ServiceError.throwServiceError( 400, 'Bad Request', 'Produto não disponivel no salesforce.');
													}else{
														Savepoint sp = Database.setSavepoint();
														try {
															contratoIns.Contrato_anterior__c = SolDiversa.get(0).Contrato__r.ContractNumber;
															
                                                            //Verificar se existe o Contrato - iSmartblue
                                                            List<Contract> listContractExistente = [SELECT Id FROM Contract WHERE Codigo_do_contrato__c =: contrato.codigo_contrato];
                                                            
                                                            if(listContractExistente.size() == 0){
                                                            insert contratoIns;
															
															for(Integer k=0; k<listItem.size(); k++ ){
																listItem[k].Contrato__c = contratoIns.Id;
															}
															insert listItem;

															SolDiversa.get(0).Status__c = 'Concluída';
															if(SolDiversa.get(0) != null) update SolDiversa.get(0);

															IntegrationModels.ProdutoResponse response = new IntegrationModels.ProdutoResponse();
															response.id = contratoIns.Id;
															RestContext.response = new RestResponse();
															RestContext.response.statusCode = 201;
															RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                                                            } else {
                                                                ServiceError.throwServiceError( 400, 'Bad Request', 'Contrato enviado já existe.');
                                                            }
														} catch( Exception dmlEX ) {
															Database.rollback(sp);
															ServiceError.throwServiceError( 500, 'Internal Server Error', 'Erro: ' + dmlEX.getMessage() + '. Detalhes' + dmlEX.getStackTraceString() );
														}
												}
											}
										}
									}
								}
							}
						}
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
        IntegrationModels.Contrato contrato;
        
        if(String.isBlank(requestJSON)) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                contrato = (IntegrationModels.Contrato) JSON.deserializeStrict(requestJSON, IntegrationModels.Contrato.class);
            } catch( Exception ex ) {               
                ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo inválido. Detalhes: ' + ex.getMessage() );
            }
			
            if(contrato!=null){
                String codigoContrato = RestContext.request.requestURI.substringAfter('/contrato/');
                if(String.isBlank(codigoContrato)) {
                    ServiceError.throwServiceError( 400, 'Bad Request', 'Código do contrato do contrato não informado.');
                } else {
					List<Contract> contratoList = [SELECT Id, Description, Cortesia__c, Permuta__c
													FROM Contract WHERE Codigo_do_contrato__c = :codigoContrato];
					if(contratoList.isEmpty()) {
						ServiceError.throwServiceError( 404, 'Not Found', 'Contrato não encontrado.' );
					} else {
						Contract contratoAtualizar = contratoList[0];
						if(String.isNotBlank(contrato.descricao))		contratoAtualizar.Description = contrato.descricao;
						if(String.isNotBlank(contrato.cortesia))		contratoAtualizar.Cortesia__c = (contrato.cortesia=='S' ? true : false);
						if(String.isNotBlank(contrato.permuta))			contratoAtualizar.Permuta__c = (contrato.permuta=='S' ? true : false);
							
						try {
							update contratoAtualizar;
							IntegrationModels.ItensResponse response = new IntegrationModels.ItensResponse();
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
            IntegrationModels.Contrato contrato = (IntegrationModels.Contrato) JSON.deserializeStrict( jsonSchema , IntegrationModels.Contrato.class );            
        } catch( Exception e ) {
            result = 'Conteúdo Inválido. Detalhes: ' + e.getMessage();
        }

        return result;
    }
}