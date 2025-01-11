public class IntegrationModels {
    public class Produto {
		public String codigo;
		public String nome;
		public String descricao;
		public String familia;
	}
    
    public class ProdutoViabilidadeExtra {
        public String descricao;
        public String codigo;
        public Decimal preco;
    }
    
    public class ProdutoViabilidade{
        public Decimal ResultCode;
        public String ResultDescription;
        public String DatabaseID;
        public String Database;
        public List<ProdutoViabilidadeExtra> Extra;
    }

	public class ProdutoResponse {
		public String id;
	}

	public class TituloFinanceiro {
		public Integer contrato;
		public String codigoCliente;
		public String competencia;
		public Integer fatura;
		public Integer boletoID;
		public String emissao;
		public String vencimento;
		public Decimal valorFatura;
		public Decimal valorPago;
		public String status;
	}

	public class TituloFinanceiroResponse {
		public String codigoTitulo;
	}

	public class Cliente {
		public String razao_social;
		public String tipo_parceiro;
		public String nome_fantasia;
		public string cnpj;
		public Integer grupo;
		public Integer vendedor;
		public String inscricao_estadual;
		public String inscricao_municipal;
		public List<String> telefones;
		public String email;
	}

	public class Contato {
		public String primeiro_nome;
		public String ultimo_nome;
		public String email;	
		public List<String> telefones;
	}

	public class Endereco {
		public String tipo_endereco;
		public String tipo_logradouro;
		public String logradouro;	
		public String numero;
		public String complemento;
		public String bairro;
		public String cidade;	
		public String municipio;
		public String estado;
		public String cep;
		public String pais;
	}

	public class Contrato {
		public String codigo_cliente;
		public String codigo_contrato;
		public Date data_inicio;
		public Date valido_ate;	
		public String descricao;
		public Integer dia_vencimento;
		public String permuta;
		public String cortesia;
		public List<ItensContrato> itens;	
		public Integer condicao_pagamento;
	}

	public class ItensContrato {
		public String numero_item;
		public String circuito;
		public String status;
		public String sales_item;
		public Double valor;
		public String banda;
		public Double instalacao_valor;
		public Integer instalacao_forma;
		public String tipo_tecnologia;
		public String redundancia;
		public String burst;
		public String burst_banda;
		public Double burst_valor;
		public String cliente_final;
		public String atendido_terceiro;
		public Integer quantidade_ip;
		public String bloco_ip;
		public String controle_alteracao;
        public String dataInicio;
        public String dataTermino;
		public List<Endereco> enderecos;
	}

	public class ItensResponse {
		public String circuito;
		public String sales_item;
	}

	public class ClienteResponse {
		public Integer error;
		public String error_description;
		public Integer status_code;
		public String codigo;
		public String contrato;
		public List<ItensResponse> itens;
	}

	public class Desconto {
		public String circuito;
		public String data;
		public Decimal minutos;
		public String observacao;
	}
}