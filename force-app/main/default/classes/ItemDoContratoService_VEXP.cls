public with sharing class ItemDoContratoService_VEXP implements ServiceInterface {
	
	private Set<String> camposObrigatoriosPost = new Set<String> {
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

    public ItemDoContratoService_VEXP() {}

    public void doPost(){
        String requestJSON = RestContext.request.requestBody.toString();
        IntegrationModels.ItensContrato itemDoContrato;
        if(String.isBlank(requestJSON)){
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                itemDoContrato = (IntegrationModels.ItensContrato) JSON.deserializeStrict(requestJSON, IntegrationModels.ItensContrato.class);
                System.debug('itemDoContrato>>'+itemDoContrato);
				
				if(itemDoContrato.enderecos.size() == 0) {
					ServiceError.throwServiceError( 400, 'Bad Request', 'Endereço não informado.');
				}else{
					/*for(Integer i=0; i<itemDoContrato.enderecos.size(); i++){
						campoNaoPreenchido = ServiceUtils.validarCamposObrigatorios(JSON.serialize(itemDoContrato.enderecos[i]), camposObrigatoriosPostEnderecos);
					}*/
					String campoNaoPreenchido = ServiceUtils.validarCamposObrigatorios( requestJSON, camposObrigatoriosPost );

					campoNaoPreenchido = ServiceUtils.validarCamposObrigatorios(JSON.serialize(itemDoContrato.enderecos[0]), camposObrigatoriosPostEnderecos);
					if(itemDoContrato.enderecos.size()==2) campoNaoPreenchido = ServiceUtils.validarCamposObrigatorios(JSON.serialize(itemDoContrato.enderecos[1]), camposObrigatoriosPostEnderecos);
				

					if(campoNaoPreenchido != null) {
						ServiceError.throwServiceError( 400, 'Bad Request', 'O campo ' + campoNaoPreenchido + ' é obrigatório.' );
					} else {
                    
						String codigoContrato = RestContext.request.requestURI.substringAfter('/itemcontrato/');
						if(String.isBlank(codigoContrato)) {
							ServiceError.throwServiceError( 400, 'Bad Request', 'Código do item do contrato não informado.');
						} else {

							List<Contract> contrato = [Select Id FROM Contract WHERE Codigo_do_contrato__c =: codigoContrato];
						
							if(contrato.size()==0){
								ServiceError.throwServiceError( 400, 'Bad Request', 'Contrato não informado.');
							}else{
								Integer bandaProduto = Integer.valueOf(itemDoContrato.banda)/1024;
								List<Product2> lProduto = [Select Id, Name FROM Product2 WHERE ProductCode =: itemDoContrato.numero_item AND (De__c <=: bandaProduto AND Ate__c>=:bandaProduto)];
								System.debug('>>>> '+lProduto.size());
								if(lProduto.size()==0){
									ServiceError.throwServiceError( 400, 'Bad Request', 'Produto não disponivel no salesforce.');
								}else{

									List<Item_do_Contrato__c> itemContratoInfo = [Select Id, Oportunidade__c, Dia_de_Vencimento__c FROM Item_do_Contrato__c WHERE Contrato__c =: contrato.get(0).Id];

									Item_do_Contrato__c item = new Item_do_Contrato__c();
									item.Name =  lProduto.get(0).Name;
									item.Oportunidade__c = itemContratoInfo.get(0).Oportunidade__c;
									item.Produto__c = lProduto.get(0).Id;
									item.Contrato__c = contrato.get(0).Id;
									item.Banda__c = bandaProduto;
									item.Valor__c = itemDoContrato.valor;
									item.Numero_do_circuito__c = itemDoContrato.circuito;
									item.Ultima_acao_contratual__c = itemDoContrato.controle_alteracao;
									item.Dia_de_Vencimento__c = itemContratoInfo.get(0).Dia_de_Vencimento__c;
									item.Status__c = (itemDoContrato.status != null ? itemDoContrato.status : 'AGUARDANDO');
                                    item.Data_de_Inicio__c = (itemDoContrato.dataInicio != null) ? date.valueOf(itemDoContrato.dataInicio) : null;
                                    item.Data_de_Termino__c = (itemDoContrato.dataTermino != null) ? date.valueOf(itemDoContrato.dataTermino) : null;
									if(itemDoContrato.enderecos != null && itemDoContrato.enderecos.size()>0){

										item.Tipo_de_logradouro_de_origem__c = itemDoContrato.enderecos[0].tipo_logradouro;
										item.numero_de_origem__c	= itemDoContrato.enderecos[0].numero;
										item.Rua_de_origem__c	= itemDoContrato.enderecos[0].logradouro;
										item.Estado_de_origem__c = itemDoContrato.enderecos[0].estado;
										item.Complemento_de_origem__c = itemDoContrato.enderecos[0].complemento;
										item.Cidade_de_origem__c = itemDoContrato.enderecos[0].cidade;
										item.CEP_de_origem__c = itemDoContrato.enderecos[0].cep;
										item.Bairro_de_origem__c = itemDoContrato.enderecos[0].bairro;

										if(itemDoContrato.enderecos.size()==2){
								
											item.Tipo_de_logradouro_de_destino__c = itemDoContrato.enderecos[1].tipo_logradouro;
											item.numero_de_destino__c	= itemDoContrato.enderecos[1].numero;
											item.Rua_de_destino__c	= itemDoContrato.enderecos[1].logradouro;
											item.Estado_de_destino__c = itemDoContrato.enderecos[1].estado;
											item.Complemento_de_destino__c = itemDoContrato.enderecos[1].complemento;
											item.Cidade_de_destino__c = itemDoContrato.enderecos[1].cidade;
											item.CEP_de_destino__c = itemDoContrato.enderecos[1].cep;
											item.Bairro_de_destino__c = itemDoContrato.enderecos[1].bairro;

										}
									}

									try {
										//Validar se existe o Item do Contrato - iSmartblue
										List<Item_do_Contrato__c> itemContratoExistente = [SELECT Id FROM Item_do_Contrato__c WHERE Numero_do_circuito__c =: itemDoContrato.circuito];
                                       
                                        if(itemContratoExistente.size() == 0){
                                        
                                        insert item;    
                                            
                                        IntegrationModels.ProdutoResponse response = new IntegrationModels.ProdutoResponse();
										response.id = item.Id;
										RestContext.response = new RestResponse();
										RestContext.response.statusCode = 201;
										RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                                        } else {
                                            ServiceError.throwServiceError( 400, 'Bad Request', 'Item do Contrato já existe.');
                                         }
                                        
									} catch( Exception dmlEX ) {
										ServiceError.throwServiceError( 500, 'Internal Server Error', 'Erro: ' + dmlEX.getMessage() + '. Detalhes' + dmlEX.getStackTraceString() );
									}
								}
							}
						}
					}
				}
            } catch( Exception ex ) {
                System.debug(ex.getStackTraceString());
                ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo inválido. Detalhes: ' + ex.getMessage() );
            }
        }
	}

    public void doGet() {}

    public void doPatch() {
        String requestJSON = RestContext.request.requestBody.toString();
        IntegrationModels.ItensContrato itemDoContrato;
        
        if(String.isBlank(requestJSON)) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo em branco' );
        } else {
            try {
                itemDoContrato = (IntegrationModels.ItensContrato) JSON.deserializeStrict(requestJSON, IntegrationModels.ItensContrato.class);
            } catch( Exception ex ) {               
                ServiceError.throwServiceError( 400, 'Bad Request', 'Conteúdo inválido. Detalhes: ' + ex.getMessage() );
            }
			
            if(itemDoContrato!=null){
                String codigoItem = RestContext.request.requestURI.substringAfter('/itemcontrato/');
                if(String.isBlank(codigoItem)) {
                    ServiceError.throwServiceError( 400, 'Bad Request', 'Código do item do contrato não informado.');
                } else {

					if(String.isBlank(itemDoContrato.status)){
						ServiceError.throwServiceError( 400, 'Bad Request', 'Status tem que está preenchido.');
					}else{
						List<Item_do_Contrato__c> atuzalizarItem = new List<Item_do_Contrato__c>();
						List<Item_do_Contrato__c> itens = [SELECT Id, Valor__c, Banda__c, Numero_do_circuito__c, Status__c, Analise_de_Viabilidade__c, Rua_de_origem__c, Rua_de_destino__c, CEP_de_origem__c, Tipo_de_logradouro_de_origem__c,
													Complemento_de_origem__c, Numero_de_origem__c, Cidade_de_origem__c, Cidade_de_destino__c, Estado_de_origem__c, Estado_de_destino__c, CEP_de_destino__c, Numero_de_destino__c, 
													Bairro_de_origem__c, Bairro_de_destino__c, Complemento_de_destino__c, Tipo_de_logradouro_de_destino__c, Data_de_Inicio__c, Data_de_Termino__c, Item_Antigo__c
													FROM Item_do_Contrato__c WHERE Numero_do_circuito__c = :codigoItem];
						if(itens.size()==0) {
							ServiceError.throwServiceError( 404, 'Not Found', 'Código do item do contrato não encontrado.' );
						} else {
                            for(Item_do_Contrato__c itemAtualizado : itens){
                                if(itemAtualizado.Item_antigo__c){
                                    itemAtualizado.Status__c = 'FECHADO';
                                    atuzalizarItem.add(itemAtualizado);
                                } else{  
                                    if(itemDoContrato.valor != null)							itemAtualizado.Valor__c = itemDoContrato.valor;
                                    if(String.isNotBlank(itemDoContrato.banda))					itemAtualizado.Banda__c = Integer.valueOf(itemDoContrato.banda)/1024;
                                    if(String.isNotBlank(itemDoContrato.controle_alteracao))	itemAtualizado.Ultima_acao_contratual__c = itemDoContrato.controle_alteracao;
                                    if(String.isNotBlank(itemDoContrato.dataInicio))			itemAtualizado.Data_de_Inicio__c = date.valueOf(itemDoContrato.dataInicio);
                                    if(String.isNotBlank(itemDoContrato.dataTermino))			itemAtualizado.Data_de_Termino__c = date.valueOf(itemDoContrato.dataTermino);
                                    itemAtualizado.Status__c = 'INICIADO';
                                    
                                    if(itemDoContrato.enderecos != null && itemDoContrato.enderecos.size()>0){
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].tipo_logradouro))	itemAtualizado.Tipo_de_logradouro_de_origem__c = itemDoContrato.enderecos[0].tipo_logradouro;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].numero))			itemAtualizado.numero_de_origem__c	= itemDoContrato.enderecos[0].numero;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].logradouro))		itemAtualizado.Rua_de_origem__c	= itemDoContrato.enderecos[0].logradouro;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].estado))			itemAtualizado.Estado_de_origem__c = itemDoContrato.enderecos[0].estado;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].complemento))		itemAtualizado.Complemento_de_origem__c = itemDoContrato.enderecos[0].complemento;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].cidade))			itemAtualizado.Cidade_de_origem__c = itemDoContrato.enderecos[0].cidade;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].cep))				itemAtualizado.CEP_de_origem__c = itemDoContrato.enderecos[0].cep;
                                        if(String.isNotBlank(itemDoContrato.enderecos[0].bairro))			itemAtualizado.Bairro_de_origem__c = itemDoContrato.enderecos[0].bairro;
                                        
                                        if(itemDoContrato.enderecos.size()==2){
                                            
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].tipo_logradouro))	itemAtualizado.Tipo_de_logradouro_de_destino__c = itemDoContrato.enderecos[1].tipo_logradouro;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].numero))			itemAtualizado.numero_de_destino__c	= itemDoContrato.enderecos[1].numero;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].logradouro))		itemAtualizado.Rua_de_destino__c	= itemDoContrato.enderecos[1].logradouro;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].estado))			itemAtualizado.Estado_de_destino__c = itemDoContrato.enderecos[1].estado;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].complemento))		itemAtualizado.Complemento_de_destino__c = itemDoContrato.enderecos[1].complemento;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].cidade))			itemAtualizado.Cidade_de_destino__c = itemDoContrato.enderecos[1].cidade;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].cep))				itemAtualizado.CEP_de_destino__c = itemDoContrato.enderecos[1].cep;
                                            if(String.isNotBlank(itemDoContrato.enderecos[1].bairro))			itemAtualizado.Bairro_de_destino__c = itemDoContrato.enderecos[1].bairro;
                                        }
                                    }
                                    atuzalizarItem.add(itemAtualizado);
                                }
                            }
                            try {
                                update atuzalizarItem;
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
    }

    public void doPut() {}
    public void doDelete() {}

    public String checkJSONSchema( String jsonSchema ) {
        String result;
        try {
            IntegrationModels.ItensContrato itensContrato = (IntegrationModels.ItensContrato) JSON.deserializeStrict( jsonSchema , IntegrationModels.ItensContrato.class );            
        } catch( Exception e ) {
            result = 'Conteúdo Inválido. Detalhes: ' + e.getMessage();
        }

        return result;
    }
}