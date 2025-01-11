public class Correios {

    public static CEPResponse getZIPCode( String zipCode ) {
        AtendeClientePort instance = new AtendeClientePort();
		System.debug('instance: ' + instance);
        try {
            enderecoERP zipCodeResponse = instance.consultaCEP(zipCode);
			System.debug('zipCodeResponse: ' + zipCodeResponse);
            System.debug( zipCodeResponse );
            CEPResponse result = new CEPResponse();
            result.bairro = zipCodeResponse.bairro;
            result.cep = zipCode;
            result.localidade = zipCodeResponse.cidade;
            result.logradouro = zipCodeResponse.end_x;
            result.uf = zipCodeResponse.uf;
            result.complemento = zipCodeResponse.complemento2;
            return result;
        } catch( Exception e ) {
            System.debug( e.getMessage() );
            return null;
        }
    }

    public class enderecoERP {
        public String bairro;
        public String cep;
        public String cidade;
        public String complemento2;
        public String end_x;
        public String uf;
        public Correios.unidadePostagemERP[] unidadesPostagem;
        private String[] bairro_type_info = new String[]{'bairro','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] cep_type_info = new String[]{'cep','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] cidade_type_info = new String[]{'cidade','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] complemento2_type_info = new String[]{'complemento2','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] end_x_type_info = new String[]{'end','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] uf_type_info = new String[]{'uf','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] unidadesPostagem_type_info = new String[]{'unidadesPostagem','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://cliente.bean.master.sigep.bsb.correios.com.br/','false','false'};
        private String[] field_order_type_info = new String[]{'bairro','cep','cidade','complemento2','end_x','uf','unidadesPostagem'};
    }

    public class consultaCEP {
        public String cep;
        private String[] cep_type_info = new String[]{'cep','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://cliente.bean.master.sigep.bsb.correios.com.br/','false','false'};
        private String[] field_order_type_info = new String[]{'cep'};
    }


    public class consultaCEPResponse {
        public Correios.enderecoERP return_x;
        private String[] return_x_type_info = new String[]{'return','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://cliente.bean.master.sigep.bsb.correios.com.br/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class unidadePostagemERP {
        public String diretoriaRegional;
        public Correios.enderecoERP endereco;
        public String id;
        public String nome;
        public String status;
        public String tipo;
        private String[] diretoriaRegional_type_info = new String[]{'diretoriaRegional','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] endereco_type_info = new String[]{'endereco','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] id_type_info = new String[]{'id','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] nome_type_info = new String[]{'nome','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] status_type_info = new String[]{'status','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] tipo_type_info = new String[]{'tipo','http://cliente.bean.master.sigep.bsb.correios.com.br/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://cliente.bean.master.sigep.bsb.correios.com.br/','false','false'};
        private String[] field_order_type_info = new String[]{'diretoriaRegional','endereco','id','nome','status','tipo'};
    }

    public class AtendeClientePort {
        public String endpoint_x = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://cliente.bean.master.sigep.bsb.correios.com.br/', 'Correios'};

        public Correios.enderecoERP consultaCEP(String cep) {
            Correios.consultaCEP request_x = new Correios.consultaCEP();
            request_x.cep = cep;
            Correios.consultaCEPResponse response_x;
            Map<String, Correios.consultaCEPResponse> response_map_x = new Map<String, Correios.consultaCEPResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://cliente.bean.master.sigep.bsb.correios.com.br/',
              'consultaCEP',
              'http://cliente.bean.master.sigep.bsb.correios.com.br/',
              'consultaCEPResponse',
              'Correios.consultaCEPResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }

    public class CEPResponse {
        public String cep { get; set; }
        public String logradouro { get; set; }
        public String complemento { get; set; }
        public String bairro { get; set; }
        public String localidade { get; set; }
        public String uf { get; set; }
        public String unidade { get; set; }
        public String ibge { get; set; }
        public String gia { get; set; }
    } 

}