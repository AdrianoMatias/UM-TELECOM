public with sharing class Sintegra_IntegrationMapping {
    public static Map<String, String> getInformacoes(Sintegra_IntegrationModels.SintegraResponse sintegraResponse) {
        System.debug('Response >> ' + sintegraResponse);
        Map<String, String> resultado = new Map<String, String>();
  
        resultado.put('inscricao_estadual', sintegraResponse.inscricao_estadual != null ? sintegraResponse.inscricao_estadual : '');
        resultado.put('data_situacao_cadastral', sintegraResponse.data_situacao_cadastral != null ? sintegraResponse.data_situacao_cadastral : '');
        resultado.put('situacao_cnpj', sintegraResponse.situacao_cnpj != null ? sintegraResponse.situacao_cnpj : '');
        resultado.put('regime_tributacao', sintegraResponse.regime_tributacao != null ? sintegraResponse.regime_tributacao : '');
        resultado.put('uf', sintegraResponse.uf != null ? sintegraResponse.uf : '');
        resultado.put('municipio', sintegraResponse.municipio != null ? sintegraResponse.municipio : '');
        resultado.put('logradouro', sintegraResponse.logradouro != null ? sintegraResponse.logradouro : '');
        resultado.put('complemento', sintegraResponse.complemento != null ? sintegraResponse.complemento : '');
        resultado.put('cep', sintegraResponse.cep != null ? sintegraResponse.cep : '');
        resultado.put('numero', sintegraResponse.numero != null ? sintegraResponse.numero : '');
        resultado.put('bairro', sintegraResponse.bairro != null ? sintegraResponse.bairro : '');
		resultado.put('status', sintegraResponse.status != null ? sintegraResponse.status : '');
		resultado.put('message', sintegraResponse.message != null ? sintegraResponse.message : '');
        resultado.put('nome_empresarial', sintegraResponse.nome_empresarial != null ? sintegraResponse.nome_empresarial : '');
        resultado.put('cnpj', sintegraResponse.cnpj != null ? sintegraResponse.cnpj : '');
        resultado.put('tipo_inscricao', sintegraResponse.tipo_inscricao != null ? sintegraResponse.tipo_inscricao : '');
        resultado.put('situacao_ie', sintegraResponse.situacao_ie != null ? sintegraResponse.situacao_ie : '');
        resultado.put('nome_fantasia', sintegraResponse.nome_fantasia != null ? sintegraResponse.nome_fantasia : '');
        resultado.put('porte_empresa', sintegraResponse.porte_empresa != null ? sintegraResponse.porte_empresa : '');
        resultado.put('data_inicio_atividade', sintegraResponse.data_inicio_atividade != null ? sintegraResponse.data_inicio_atividade : '');
        resultado.put('informacao_ie_como_destinatario', sintegraResponse.informacao_ie_como_destinatario != null ? sintegraResponse.informacao_ie_como_destinatario : '');
        if(sintegraResponse.cnae_principal != null) {
            resultado.put('cnae_principal.codigo', sintegraResponse.cnae_principal.codigo != null ? sintegraResponse.cnae_principal.codigo : '');
            resultado.put('cnae_principal.descricao', sintegraResponse.cnae_principal.descricao != null ? sintegraResponse.cnae_principal.descricao : '');
        } else {
            resultado.put('cnae_principal.codigo', '');
            resultado.put('cnae_principal.descricao', '');
        }
        resultado.put('data_fim_atividade', sintegraResponse.data_fim_atividade != null ? sintegraResponse.data_fim_atividade : '');

        return resultado;
    }
}