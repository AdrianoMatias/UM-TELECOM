public class IntegrationMappings  {

	public static Map<String,String> mapMunicipios = new Map<String,String>();
	static {
		List<Municipios__c> listMuncipios = [SELECT Id, codigo_IBGE__c, Name FROM Municipios__c];
		for(Municipios__c mun : listMuncipios){
			mapMunicipios.put(mun.Name,mun.codigo_IBGE__c);	
		}
	}
	
	public static IntegrationModels.Cliente getClientes( Account conta, String Tipo) {
		IntegrationModels.Cliente result =	new IntegrationModels.Cliente();
		result.razao_social				=	(conta.Razao_Social__c != null ? conta.Razao_Social__c : '');
		result.tipo_parceiro			=	Tipo;
		result.nome_fantasia			=	(conta.Nome_Fantasia__c != null ? conta.Nome_Fantasia__c : '');
		result.cnpj						=	(conta.CNPJ__c != null ? conta.CNPJ__c.trim().replaceAll('[^0-9]','') : '');
		result.grupo					=	(conta.Grupo__c != null ? Integer.valueOf(conta.Grupo__c) : null);
		result.vendedor					=	(conta.Owner.Codigo_do_vendedor__c != null ? Integer.valueOf(conta.Owner.Codigo_do_vendedor__c) : 0);
		result.inscricao_estadual		=	(conta.Inscricao_Estadual__c != null ? conta.Inscricao_Estadual__c : 'ISENTO');
		result.inscricao_municipal		=	(conta.Inscricao_municipal__c != null ? conta.Inscricao_municipal__c : 'ISENTO');
		result.telefones				=	new List<String>();
		if(conta.Phone != null)			result.telefones.add(conta.Phone);
		result.email					=	(conta.Email__c != null ? conta.Email__c : '');

		return result;
	}

	public static IntegrationModels.Contato getContato( Contact contato) {
		IntegrationModels.Contato result = new IntegrationModels.Contato();
		result.primeiro_nome	=	(contato.FirstName != null ? contato.FirstName : '');
		result.ultimo_nome		=	(contato.LastName != null ? contato.LastName : '');
		result.email			=	(contato.Email != null ? contato.Email : '');
		result.telefones		=	new List<String>();
		if(contato.MobilePhone != null) result.telefones.add(contato.MobilePhone);
		if(contato.Phone != null) result.telefones.add(contato.Phone);

		return result;
	}

	public static IntegrationModels.Endereco getEndereco( Account conta, String tipo) {
		IntegrationModels.Endereco result = new IntegrationModels.Endereco();

		if(tipo=='ENVIO'){
			result.tipo_endereco	=	tipo;
			result.tipo_logradouro	=	(conta.Tipo_de_logradouro_entrega__c != null ? conta.Tipo_de_logradouro_entrega__c : '');
			result.logradouro		=	(conta.BillingStreet != null ? conta.BillingStreet : '');
			result.numero			=	(conta.Numero_de_entrega__c != null ? conta.Numero_de_entrega__c : '');
			result.complemento		=	(conta.Complemento_de_entrega__c != null ? conta.Complemento_de_entrega__c : '');
			result.bairro			=	(conta.Bairro_de_entrega__c != null ? conta.Bairro_de_entrega__c : '');
			result.cidade			=	(conta.BillingCity != null ? conta.BillingCity.normalizeSpace().trim() : '');
			result.estado			=	(conta.BillingState != null ? conta.BillingState : '');
			if(String.isNotBlank(result.cidade)){
				result.cidade = removerAcentos(result.cidade);
				List<Municipios__c> lm = [Select Id, codigo_IBGE__c FROM Municipios__c where Name =: result.cidade and Estado__c=: result.estado]; 
				if(lm.size()==0){
					throw new AuraHandledException('A cidade informada não possui código do IBGE. Contate o administrador');
				}else if(lm.size()==1){
					result.municipio = lm.get(0).Codigo_IBGE__c;
				}
			}
			result.cep				=	(conta.BillingPostalCode != null ? conta.BillingPostalCode : '');
			result.pais				=	(conta.BillingCountry != null ? conta.BillingCountry : '');
		}else if(tipo=='COBRANÇA'){
			result.tipo_endereco	=	tipo;
			result.tipo_logradouro	=	(conta.Tipo_de_logradouro_cobranca__c != null ? conta.Tipo_de_logradouro_cobranca__c : '');
			result.logradouro		=	(conta.ShippingStreet != null ? conta.ShippingStreet : '');
			result.numero			=	(conta.Numero_de_cobranca__c != null ? conta.Numero_de_cobranca__c : '');
			result.complemento		=	(conta.Complemento_de_cobranca__c != null ? conta.Complemento_de_cobranca__c : '');
			result.bairro			=	(conta.Bairro_de_cobranca__c != null ? conta.Bairro_de_cobranca__c : '');
			result.cidade			=	(conta.ShippingCity != null ? conta.ShippingCity.normalizeSpace().trim() : '');
			result.estado			=	(conta.ShippingState != null ? conta.ShippingState : '');
			if(String.isNotBlank(result.cidade)){
				result.cidade = removerAcentos(result.cidade);
				List<Municipios__c> lm = [Select Id, codigo_IBGE__c FROM Municipios__c where Name =: result.cidade and Estado__c=: result.estado]; 
				if(lm.size()==0){
					throw new AuraHandledException('A cidade informada não possui  código do IBGE. Contate o administrador');
				}else if(lm.size()==1){
					result.municipio = lm.get(0).Codigo_IBGE__c;
				}
			}
			result.cep				=	(conta.ShippingPostalCode != null ? conta.ShippingPostalCode : '');
			result.pais				=	(conta.ShippingCountry != null ? conta.ShippingCountry : '');
		}

		return result;
	}

	public static IntegrationModels.Contrato getContrato( Opportunity oportunidade, List<OpportunityLineItem> ListOli, Map<Id,Analise_de_viabilidade__c> analises) {
		IntegrationModels.Contrato result = new IntegrationModels.Contrato();
		System.debug('oportunidade' + oportunidade);
		result.codigo_cliente = (oportunidade.Account.Codigo_SAP_cliente__c != null ? oportunidade.Account.Codigo_SAP_cliente__c : '');
		result.data_inicio = (oportunidade.CloseDate != null ? Date.valueOf(oportunidade.CloseDate) : Date.today());
		result.valido_ate = (oportunidade.Meses__c != null ? Date.valueOf(oportunidade.CloseDate.addMonths(Integer.valueOf(oportunidade.Meses__c))) : Date.today());
		result.descricao = (oportunidade.Description != null ? oportunidade.Description : '');
		result.dia_vencimento = (oportunidade.Dia_do_vencimento__c != null ? Integer.valueOf(oportunidade.Dia_do_vencimento__c) : 5);
		result.permuta = (oportunidade.Permuta__c ? 'S' : 'N');
		result.cortesia = (oportunidade.Cortesia__c ? 'S' : 'N');
		result.condicao_pagamento = -1;
		result.codigo_contrato = (oportunidade.ContractId != null ? oportunidade.Contract.Codigo_do_contrato__c : '');

		result.itens = new List<IntegrationModels.ItensContrato>();
        //mapenado municipios
        List<Municipios__c> listMunicipios = [Select Id, Name, Estado__c, codigo_IBGE__c FROM Municipios__c];
        Map<String, String> mapMunicipioCodigoIBGE = new Map<String, String>();
        for(Municipios__c municipio : listMunicipios){
            String nomeMunicipio = String.isNotBlank(municipio.Name) ? municipio.Name.toLowerCase() : municipio.Name; 
            String nomeEstado = String.isNotBlank(municipio.Estado__c) ? municipio.Estado__c.toLowerCase() : municipio.Estado__c; 
            String chave = nomeMunicipio + '_' + nomeEstado;
            mapMunicipioCodigoIBGE.put(chave, municipio.codigo_IBGE__c);
        }
        
		system.debug('LIST >>>>'+ ListOli.size());
		system.debug('result.itens >>>>'+ result.itens.size());
		for(OpportunityLineItem	oli : ListOli){
			system.debug('analises>>>> '+analises.size());
			if(analises.containsKey(oli.Id)){
				IntegrationModels.ItensContrato item = new IntegrationModels.ItensContrato();
				
				item.numero_item = (oli.ProductCode != null ? oli.ProductCode : '');
				item.circuito = (oli.Numero_de_circuito__c == '0000000000' ? '' : oli.Numero_de_circuito__c);
				item.valor = (oli.TotalPrice > 0 ? Double.valueOf(oli.TotalPrice) : 0.0);
				item.banda = (oli.Quantity > 0 ? String.valueOf(Integer.valueOf(oli.Quantity)*1024) : '0');
				item.sales_item = analises.get(oli.Id).Name;
                item.status = 'INICIADO';
                item.controle_alteracao = '';
                item.dataInicio = '';
                item.dataTermino = '';
				item.redundancia = (analises.get(oli.Id).Redundancia__c != null ? analises.get(oli.Id).Redundancia__c : '');
				item.bloco_ip = (analises.get(oli.Id).Bloco_de_Ips__c != null ? analises.get(oli.Id).Bloco_de_Ips__c : '');
				item.tipo_tecnologia = (analises.get(oli.Id).Tipo_de_atendimento__c != null ? analises.get(oli.Id).Tipo_de_atendimento__c : '');
				item.burst = (analises.get(oli.Id).Burst__c != null ? analises.get(oli.Id).Burst__c : '');
				item.cliente_final = (analises.get(oli.Id).Cliente_final__c != null ? analises.get(oli.Id).Cliente_final__c : '');
				item.quantidade_ip = (analises.get(oli.Id).Quantidade_de_Ips__c != null ? Integer.valueof(analises.get(oli.Id).Quantidade_de_Ips__c) : 0);
				item.instalacao_valor = (oli.Taxa_de_instalacao__c != null ? oli.Taxa_de_instalacao__c : 0.0);
				item.instalacao_forma = (oli.Forma_de_pagamento_da_instalacao__c != null ? Integer.valueOf(oli.Forma_de_pagamento_da_instalacao__c) : 0);
				item.atendido_terceiro = (analises.get(oli.Id).Atendido_por_parceiro__c != null ? analises.get(oli.Id).Atendido_por_parceiro__r.Codigo_SAP_parceiro__c : '');
				item.burst_valor = (oli.Taxa_de_Burst__c != null ? oli.Taxa_de_Burst__c : 0);
				item.burst_banda = (oli.Banda_burst__c > 0 ? String.valueOf(Integer.valueOf(oli.Banda_burst__c)*1024) : '0');
				
				item.enderecos = new List<IntegrationModels.Endereco>();
				IntegrationModels.Endereco envio = new IntegrationModels.Endereco();
				envio.pais						= 'BR';
				envio.estado					= analises.get(oli.Id).Estado_de_origem__c;
				envio.bairro					= analises.get(oli.Id).Bairro_de_origem__c;
				envio.cidade					= (analises.get(oli.Id).Cidade_de_origem__c != null ? analises.get(oli.Id).Cidade_de_origem__c.normalizeSpace().trim() : '');
                envio.tipo_endereco = 'ENVIO';
				if(String.isNotBlank(envio.cidade)){
					envio.cidade = removerAcentos(envio.cidade);
					
                    String nomeMunicipio = String.isNotBlank(envio.cidade) ? envio.cidade.toLowerCase() : envio.cidade; 
                    System.debug('nomeMunicipio');
                    System.debug(nomeMunicipio);
                    String nomeEstado = String.isNotBlank(envio.estado) ? envio.estado.toLowerCase() : envio.estado; 
                    System.debug(nomeEstado);
					String chaveMunicipio = nomeMunicipio + '_' + nomeEstado;
					System.debug(chaveMunicipio);
					System.debug('mapMunicipioCodigoIBGE.get(chaveMunicipio)');
					System.debug(mapMunicipioCodigoIBGE.get(chaveMunicipio));
					if(mapMunicipioCodigoIBGE.get(chaveMunicipio) == null){
						throw new AuraHandledException('A cidade informada não possui código do IBGE. Contate o administrador');
					}else{
						envio.municipio = mapMunicipioCodigoIBGE.get(chaveMunicipio);
					}
				}
				envio.tipo_logradouro			= (analises.get(oli.Id).Tipo_de_logradouro_origem__c != null ? analises.get(oli.Id).Tipo_de_logradouro_origem__c : '');
				envio.logradouro				= analises.get(oli.Id).Rua_de_origem__c;
				envio.cep						= analises.get(oli.Id).CEP_de_origem__c;
				envio.numero					= analises.get(oli.Id).numero_de_origem__c;
				envio.complemento				= analises.get(oli.Id).Complemento_da_origem__c;
				item.enderecos.add(envio);
			
				if(analises.get(oli.Id).Rua_de_destino__c!= null){
					IntegrationModels.Endereco destino = new IntegrationModels.Endereco();
					destino.pais					= 'BR';
					destino.estado					= analises.get(oli.Id).Estado_de_destino__c;
					destino.bairro					= analises.get(oli.Id).Bairro_de_destino__c;
					destino.cidade					= (analises.get(oli.Id).Cidade_de_destino__c != null ? analises.get(oli.Id).Cidade_de_destino__c.normalizeSpace().trim() : '');
                    destino.tipo_endereco = 'COBRANCA';
					if(String.isNotBlank(destino.cidade)){
						destino.cidade = removerAcentos(destino.cidade);
						
						String nomeMunicipio = String.isNotBlank(destino.cidade) ? destino.cidade.toLowerCase() : destino.cidade;
						System.debug('nomeMunicipio');
                    	System.debug(nomeMunicipio);
                    	String nomeEstado = String.isNotBlank(destino.estado) ? destino.estado.toLowerCase() : destino.estado; 
                    	System.debug(nomeEstado);
						String chaveMunicipio = nomeMunicipio + '_' + nomeEstado;
						System.debug(chaveMunicipio);
						System.debug('mapMunicipioCodigoIBGE.get(chaveMunicipio)');
						System.debug(mapMunicipioCodigoIBGE.get(chaveMunicipio));
						if(mapMunicipioCodigoIBGE.get(chaveMunicipio) == null){
							throw new AuraHandledException('A cidade informada não possui código do IBGE. Contate o administrador');
						}else{
							destino.municipio = mapMunicipioCodigoIBGE.get(chaveMunicipio);
						}
					}
					destino.tipo_logradouro			= (analises.get(oli.Id).Tipo_de_logradouro_destino__c != null ? analises.get(oli.Id).Tipo_de_logradouro_destino__c : '');
					destino.logradouro				= analises.get(oli.Id).Rua_de_destino__c;
					destino.cep						= analises.get(oli.Id).CEP_de_destino__c;
					destino.numero					= analises.get(oli.Id).numero_de_destino__c;
					destino.complemento				= analises.get(oli.Id).Complemento_do_destino__c;
					item.enderecos.add(destino);
					system.debug('item.destino>>>'+destino);
				}

				system.debug('item.envio>>>'+envio);
				system.debug('item.enderecos>>>'+item.enderecos);
			
				system.debug('item everton>>>'+item);
				result.itens.add(item);
				system.debug('result.itens >>>>'+ result.itens.size());
			}
		}
			
		return result;
	}

	private static string removerAcentos(string texto){
		string comAcentos = 'ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç';
		string semAcentos = 'AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc';

		for (Integer i = 0; i < comAcentos.length(); i++)
		{
			texto = texto.Replace(comAcentos.substring(i,i+1), semAcentos.substring(i,i+1));
		}
		system.debug(texto);
		return texto;
	}
}