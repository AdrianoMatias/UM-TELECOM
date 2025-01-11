/**
* @author 1telecom@dreamm.com.br.dev
* @description Setup de dados para classes de testes da UmTelecom
*/ 
@isTest 
public class TestUtils {
	/**
	* @author 1telecom@dreamm.com.br.dev
	* @description 
	*/ 
	public static void dadosLead() {
		//Instanciação de lead;
		Lead l = new Lead();
		l.FirstName = 'TesteLEAD';
		l.LastName = 'SegundoNomeLEAD';
		l.MobilePhone = '999999999';
		l.Email = 'teste@teste.com';
		l.Company = 'Teste companhia LEAD';
		Insert l;

		/*Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(l.Id);

		Database.LeadConvertResult lcr = Database.convertLead(lc);*/
	}

	/**
	* @author 1telecom@dreamm.com.br.dev
	* @description: Conta para teste da accountTriggerHandler
	*/ 
	public static void dadosConta(){

		Logradouro__c logradouroTestUtil = new Logradouro__c();
		logradouroTestUtil.Name = 'AVENIDA';
		logradouroTestUtil.Abreviatura__c = 'AV';
		logradouroTestUtil.Codigo__c = '114';
		insert logradouroTestUtil;

		Account contaTestUtil = new Account();
		contaTestUtil.Name = 'Teste 1 - Recife';
		contaTestUtil.Razao_Social__c = 'Teste';
		contaTestUtil.Nome_Fantasia__c = 'Dreamm teste';
		contaTestUtil.CNPJ__c = '94.632.416/0001-76';
		contaTestUtil.Natureza_Juridica__c = 'natureza teste';
		contaTestUtil.Tipo_RFB__c = 'MATRIZ';
		contaTestUtil.Situacao_RFB__c = 'ATIVA';
		contaTestUtil.Grupo__c = '150';
		contaTestUtil.Data_de_Abertura__c = Date.newInstance(2010,12,30);
		contaTestUtil.Capital_Social__c = 100000;

		insert contaTestUtil;

		Opportunity oportunidadeTestUtil = new Opportunity();
		oportunidadeTestUtil.Name = 'Oportunidade teste';
		oportunidadeTestUtil.StageName = 'Mapeamento';
		oportunidadeTestUtil.CloseDate = Date.today().addDays(30);
		oportunidadeTestUtil.Meses__c = 12;
		oportunidadeTestUtil.type = 'Novo Negócio';
		oportunidadeTestUtil.AccountId = contaTestUtil.Id;
		insert oportunidadeTestUtil;

		contaTestUtil.BillingStreet = 'AV Marques de Olinda, Nº 266, Recife';
		contaTestUtil.BillingPostalCode = '50.030-000';
		contaTestUtil.BillingState = 'PE';
		contaTestUtil.BillingCity = 'Recife';
		contaTestUtil.Bairro_de_cobranca__c = 'Recife';
		contaTestUtil.Numero_de_cobranca__c = '126';
		update contaTestUtil;
	}
	
	/**
	* @author 1telecom@dreamm.com.br.dev
	* @description: Conta com oportunidade
	*/ 
	public static void dadosContaOportunidade(){

		Account conta1TestUtil = new Account();
		conta1TestUtil.Name = 'Teste 1 - Recife';
		conta1TestUtil.Razao_Social__c = 'Teste';
		conta1TestUtil.Nome_Fantasia__c = 'Dreamm teste';
		conta1TestUtil.CNPJ__c = '94.632.416/0001-76';
		conta1TestUtil.Natureza_Juridica__c = 'natureza teste';
		conta1TestUtil.Tipo_RFB__c = 'MATRIZ';
		conta1TestUtil.Situacao_RFB__c = 'ATIVA';
		conta1TestUtil.Data_de_Abertura__c = Date.newInstance(2010,12,30);
		conta1TestUtil.Capital_Social__c = 100000;
		conta1TestUtil.BillingStreet = 'Av Marques de Olinda, Nº 266, Recife';
		conta1TestUtil.BillingPostalCode = '50.030-000';
		conta1TestUtil.BillingState = 'PE';
		conta1TestUtil.BillingCity = 'Recife';
		conta1TestUtil.Bairro_de_cobranca__c = 'Recife';
		conta1TestUtil.Numero_de_cobranca__c = '126';
		conta1TestUtil.Grupo__c = '150';
        conta1TestUtil.Codigo_SAP_cliente__c = '454545';
		insert conta1TestUtil;

		Contact contatoTestUtil = new Contact();
		contatoTestUtil.FirstName = 'teste contact';
		contatoTestUtil.LastName = 'Dreamm teste';
		contatoTestUtil.Email = 'dreammContato@teste.com';
		contatoTestUtil.Phone = '99999-9991';
		contatoTestUtil.MobilePhone = '99999-9991';
		contatoTestUtil.AccountId = conta1TestUtil.Id;
		insert contatoTestUtil;

		Opportunity oportunidadeTestUtil = new Opportunity();
		oportunidadeTestUtil.Name = 'Oportunidade teste Utils';
		oportunidadeTestUtil.StageName = 'Mapeamento';
		oportunidadeTestUtil.CloseDate = Date.today().addDays(30);
		oportunidadeTestUtil.Meses__c = 12;
		oportunidadeTestUtil.type = 'Novo Negócio';
		oportunidadeTestUtil.AccountId = conta1TestUtil.Id;
		oportunidadeTestUtil.By_pass__c = false;
		insert oportunidadeTestUtil;
	}
	
	/**
	* @author 1telecom@dreamm.com.br.dev
	* @description: Criando Catalogo
	*/ 
	public static void dadosProdutoCatalogo(){
		
		Pricebook2 catalogoTestUtil = new Pricebook2();
		catalogoTestUtil.Regiao__c = 'Nordeste';
		catalogoTestUtil.UF__c = 'PE';
		catalogoTestUtil.Name = 'Catalogo teste Nordeste - PE';
		catalogoTestUtil.IsActive = true;
		catalogoTestUtil.Tipo_do_catalogo__c = 'CARRIER';
		insert catalogoTestUtil;

		List<Product2> listProdutosTestUtils = new List<Product2>();
		
		Product2 prodTestUtils = new Product2();
        prodTestUtils.Name = 'Lan 1 - 10MB';
        prodTestUtils.ProductCode = 'C000001';
        prodTestUtils.IsActive = true;
        prodTestUtils.Family = 'Cabos'; 
        prodTestUtils.Instalacao__c = true;
        prodTestUtils.Viabilidade__c = true;
        prodTestUtils.Taxa_de_instalacao__c = true;
		prodTestUtils.Instalacao__c = true;
		prodTestUtils.De__c = 1;
		prodTestUtils.Ate__c = 10;
        listProdutosTestUtils.add(prodTestUtils);

		Product2 prodTestUtils2 = new Product2();
        prodTestUtils2.Name = 'Lan 10 - 25MB';
        prodTestUtils2.ProductCode = 'C000002';
        prodTestUtils2.IsActive = true;
        prodTestUtils2.Family = 'Cabos'; 
        prodTestUtils2.Instalacao__c = true;
        prodTestUtils2.Viabilidade__c = true;
        prodTestUtils2.Taxa_de_instalacao__c = true;
		prodTestUtils2.Instalacao__c = true;
		prodTestUtils2.De__c = 10;
		prodTestUtils2.Ate__c = 25;
        listProdutosTestUtils.add(prodTestUtils2);
	
		Product2 prodTestUtils3 = new Product2();
        prodTestUtils3.Name = 'Link ponto a ponto 100MB';
        prodTestUtils3.ProductCode = 'C000003';
        prodTestUtils3.IsActive = true;
        prodTestUtils3.Family = 'Link'; 
        prodTestUtils3.Instalacao__c = true;
        prodTestUtils3.Viabilidade__c = true;
        prodTestUtils3.Taxa_de_instalacao__c = true;
		prodTestUtils3.Instalacao__c = true;
		prodTestUtils3.De__c = 1;
		prodTestUtils3.Ate__c = 100;
        listProdutosTestUtils.add(prodTestUtils3);
		insert listProdutosTestUtils;

		List<PricebookEntry> pbeListTestUtilsPadrao = new List<PricebookEntry>();
		PricebookEntry pbeTestUtilsPadrao = new PricebookEntry();
		pbeTestUtilsPadrao.Preco_do_Diretor__c = 30;
		pbeTestUtilsPadrao.Preco_Minimo_do_Executivo__c = 50;
		pbeTestUtilsPadrao.Preco_Minimo_do_Gerente__c = 40;
		pbeTestUtilsPadrao.UnitPrice = 70;
		pbeTestUtilsPadrao.IsActive = true;
		pbeTestUtilsPadrao.Pricebook2Id = Test.getStandardPricebookId();
		Product2 ProdutoTU1 = [Select Id FROM Product2 WHERE ProductCode = 'C000001'];
		pbeTestUtilsPadrao.Product2Id = ProdutoTU1.Id;
		pbeListTestUtilsPadrao.add(pbeTestUtilsPadrao);

		PricebookEntry pbeTestUtilsPadrao2 = new PricebookEntry();
		pbeTestUtilsPadrao2.Preco_do_Diretor__c = 30;
		pbeTestUtilsPadrao2.Preco_Minimo_do_Executivo__c = 50;
		pbeTestUtilsPadrao2.Preco_Minimo_do_Gerente__c = 40;
		pbeTestUtilsPadrao2.UnitPrice = 70;
		pbeTestUtilsPadrao2.IsActive = true;
		pbeTestUtilsPadrao2.Pricebook2Id = Test.getStandardPricebookId();
		Product2 ProdutoTU2 = [Select Id FROM Product2 WHERE ProductCode = 'C000002'];
		pbeTestUtilsPadrao2.Product2Id = ProdutoTU2.Id;
		pbeListTestUtilsPadrao.add(pbeTestUtilsPadrao2);

		PricebookEntry pbeTestUtilsPadrao3 = new PricebookEntry();
		pbeTestUtilsPadrao3.Preco_do_Diretor__c = 30;
		pbeTestUtilsPadrao3.Preco_Minimo_do_Executivo__c = 50;
		pbeTestUtilsPadrao3.Preco_Minimo_do_Gerente__c = 40;
		pbeTestUtilsPadrao3.UnitPrice = 70;
		pbeTestUtilsPadrao3.IsActive = true;
		pbeTestUtilsPadrao3.Pricebook2Id = Test.getStandardPricebookId();
		Product2 ProdutoTU3 = [Select Id FROM Product2 WHERE ProductCode = 'C000003'];
		pbeTestUtilsPadrao3.Product2Id = ProdutoTU3.Id;
		pbeListTestUtilsPadrao.add(pbeTestUtilsPadrao3);

		insert pbeListTestUtilsPadrao;

		List<PricebookEntry> pbeListTestUtils = new List<PricebookEntry>();
		PricebookEntry pbeTestUtils1 = new PricebookEntry();
		pbeTestUtils1.Preco_do_Diretor__c = 30;
		pbeTestUtils1.Preco_Minimo_do_Executivo__c = 50;
		pbeTestUtils1.Preco_Minimo_do_Gerente__c = 40;
		pbeTestUtils1.UnitPrice = 70;
		pbeTestUtils1.IsActive = true;
		pbeTestUtils1.Pricebook2Id = catalogoTestUtil.Id;
		pbeTestUtils1.Product2Id = ProdutoTU1.Id;
		pbeListTestUtils.add(pbeTestUtils1);

		PricebookEntry pbeTestUtils2 = new PricebookEntry();
		pbeTestUtils2.Preco_do_Diretor__c = 30;
		pbeTestUtils2.Preco_Minimo_do_Executivo__c = 50;
		pbeTestUtils2.Preco_Minimo_do_Gerente__c = 40;
		pbeTestUtils2.UnitPrice = 70;
		pbeTestUtils2.IsActive = true;
		pbeTestUtils2.Pricebook2Id = catalogoTestUtil.Id;
		pbeTestUtils2.Product2Id = ProdutoTU2.Id;
		pbeListTestUtils.add(pbeTestUtils2);

		PricebookEntry pbeTestUtils3 = new PricebookEntry();
		pbeTestUtils3.Preco_do_Diretor__c = 30;
		pbeTestUtils3.Preco_Minimo_do_Executivo__c = 50;
		pbeTestUtils3.Preco_Minimo_do_Gerente__c = 40;
		pbeTestUtils3.UnitPrice = 70;
		pbeTestUtils3.IsActive = true;
		pbeTestUtils3.Pricebook2Id = catalogoTestUtil.Id;
		pbeTestUtils3.Product2Id = ProdutoTU3.Id;
		pbeListTestUtils.add(pbeTestUtils3);

		insert pbeListTestUtils;
	}

	/**
	* @author 1telecom@dreamm.com.br.dev
	* @description: Criando Analise de Viabilidade
	*/ 
	public static void dadosAnaliseDeViabilidade(){

		Indicador_de_tempo__c indicador = new Indicador_de_tempo__c();
		indicador.Dias__c = 7;
		indicador.Name = 'Sinal';
		insert indicador;
		
		dadosContaOportunidade();
		dadosProdutoCatalogo();
		
		Opportunity opp = [SELECT Id, StageName, Pricebook2Id FROM Opportunity WHERE Name = 'Oportunidade teste Utils'];
		opp.Pricebook2Id = [SELECT Id FROM Pricebook2 WHERE Name = 'Catalogo teste Nordeste - PE'].Id;
		System.debug('>>>> '+opp.StageName);
		update opp;

		//Adição de produtos
		List<OpportunityLineItem> oliListTestUtils = new List<OpportunityLineItem>();
		OpportunityLineItem	oliTestUtils = new OpportunityLineItem();
		oliTestUtils.Product2Id = [Select Id FROM Product2 WHERE ProductCode = 'C000001'].Id;
		oliTestUtils.OpportunityId = opp.Id;
		oliTestUtils.Quantity = 9;
        oliTestUtils.Quantidade_de_produtos__c = 2;
		oliTestUtils.UnitPrice = 100;
		oliTestUtils.Numero_de_Circuito__c = '0000000000';
		oliListTestUtils.add(oliTestUtils);

		OpportunityLineItem	oliTestUtils1 = new OpportunityLineItem();
		oliTestUtils1.Product2Id = [Select Id FROM Product2 WHERE ProductCode = 'C000002'].Id;
		oliTestUtils1.OpportunityId = opp.Id;
		oliTestUtils1.Quantity = 15;
        oliTestUtils1.Quantidade_de_produtos__c = 2;
		oliTestUtils1.UnitPrice = 80;
		oliTestUtils1.Numero_de_Circuito__c = '0000000000';
		oliListTestUtils.add(oliTestUtils1);

		OpportunityLineItem	oliTestUtils2 = new OpportunityLineItem();
		oliTestUtils2.Product2Id = [Select Id FROM Product2 WHERE ProductCode = 'C000003'].Id;
		oliTestUtils2.OpportunityId = opp.Id;
		oliTestUtils2.Quantity = 20;
        oliTestUtils2.Quantidade_de_produtos__c = 2;
		oliTestUtils2.UnitPrice = 70;
		oliTestUtils2.Numero_de_Circuito__c = '0000000000';
		oliListTestUtils.add(oliTestUtils2);

		Insert oliListTestUtils;
		//Cria as analises
		opp.StageName = 'Viabilidade';
		Update opp;

		List<Produto_de_viabilidade__c> listProdViabilidadeTestUtils = new List<Produto_de_viabilidade__c>();
		Produto_de_viabilidade__c prodViabTestUtils1 = new Produto_de_viabilidade__c();
		prodViabTestUtils1.CAPEX__c = true;
		prodViabTestUtils1.Aprovacao_a_partir_de__c = 200;
		prodViabTestUtils1.Name = 'Produto 1 viabilidade';
		prodViabTestUtils1.Valor_unitario__c = 20;
		prodViabTestUtils1.Codigo__c = 'PV000001';
        prodViabTestUtils1.Status__c = 'Ativo';
		listProdViabilidadeTestUtils.add(prodViabTestUtils1);

		Produto_de_viabilidade__c prodViabTestUtils2 = new Produto_de_viabilidade__c();
		prodViabTestUtils2.CAPEX__c = true;
		prodViabTestUtils2.Aprovacao_a_partir_de__c = 100;
		prodViabTestUtils2.Name = 'Produto 2 viabilidade';
		prodViabTestUtils2.Valor_unitario__c = 40;
		prodViabTestUtils2.Codigo__c = 'PV000002';
		listProdViabilidadeTestUtils.add(prodViabTestUtils2);

		Produto_de_viabilidade__c prodViabTestUtils3 = new Produto_de_viabilidade__c();
		prodViabTestUtils3.CAPEX__c = true;
		prodViabTestUtils3.Aprovacao_a_partir_de__c = 150;
		prodViabTestUtils3.Name = 'Produto 3 viabilidade';
		prodViabTestUtils3.Valor_unitario__c = 30;
		prodViabTestUtils3.Codigo__c = 'PV000003';
		listProdViabilidadeTestUtils.add(prodViabTestUtils3);
		
		insert listProdViabilidadeTestUtils;

		List<Item_da_viabilidade__c> itemListaViabTestUtils = new List<Item_da_viabilidade__c>();
		Item_da_viabilidade__c itemViabTestUtils1 = new Item_da_viabilidade__c();
		itemViabTestUtils1.Analise_de_Viabilidade__c = [Select Id FROM Analise_de_viabilidade__c WHERE Tipo_de_link__c Like '%10MB' LIMIT 1].Id;
		itemViabTestUtils1.Produto_de_viabilidade__c = prodViabTestUtils1.Id;
		itemViabTestUtils1.Necessario_aprovacao__c = true;
		itemViabTestUtils1.Quantidade__c = 5;
		itemListaViabTestUtils.add(itemViabTestUtils1);

		Item_da_viabilidade__c itemViabTestUtils2 = new Item_da_viabilidade__c();
		itemViabTestUtils2.Analise_de_Viabilidade__c = [Select Id FROM Analise_de_viabilidade__c WHERE Tipo_de_link__c Like '%25MB' LIMIT 1].Id;
		itemViabTestUtils2.Produto_de_viabilidade__c = prodViabTestUtils1.Id;
		itemViabTestUtils2.Necessario_aprovacao__c = true;
		itemViabTestUtils2.Quantidade__c = 15;
		itemListaViabTestUtils.add(itemViabTestUtils2);

		Item_da_viabilidade__c itemViabTestUtils3 = new Item_da_viabilidade__c();
		itemViabTestUtils3.Analise_de_Viabilidade__c = [Select Id FROM Analise_de_viabilidade__c WHERE Tipo_de_link__c Like '%100MB' LIMIT 1].Id;
		itemViabTestUtils3.Produto_de_viabilidade__c = prodViabTestUtils1.Id;
		itemViabTestUtils3.Necessario_aprovacao__c = true;
		itemViabTestUtils3.Quantidade__c = 50;
		itemListaViabTestUtils.add(itemViabTestUtils3);
		
		insert itemListaViabTestUtils;

	}

	/**
	* @author 1telecom@dreamm.com.br.dev
	* @description: Criando do contrato 
	*/ 
	public static void dadosContrato(){
		dadosAnaliseDeViabilidade();
		Opportunity opp = [Select Id, StageName, AccountId, By_pass__c, CloseDate, Cortesia__c, Meses__c, Permuta__c, Validado_financeiro__c, Validado_juridico__c  FROM Opportunity WHERE Name =: 'Oportunidade teste Utils'];
		List<Analise_de_viabilidade__c> listAnalise = new List<Analise_de_viabilidade__c>();
		for(Analise_de_viabilidade__c analise : [SELECT Id FROM Analise_de_viabilidade__c WHERE Oportunidade__c =:opp.Id]){
			analise.Bairro_de_destino__c = 'Recife';
			analise.Cidade_de_destino__c = 'Recife';
			analise.Tipo_de_logradouro_destino__c = 'AVENIDA';
			analise.Rua_de_destino__c = 'Avenida Marques de Olinda';
			analise.numero_de_destino__c = '126';
			analise.CEP_de_destino__c = '50.030-000';
			analise.Estado_de_destino__c = 'PE';
			analise.Bairro_de_origem__c = 'Recife';
			analise.Cidade_de_origem__c = 'Recife';
			analise.Tipo_de_logradouro_origem__c = 'AVENIDA';
			analise.Rua_de_origem__c = 'Avenida Marques de Olinda';
			analise.numero_de_origem__c = '126';
			analise.CEP_de_origem__c = '50.030-000';
			analise.Estado_de_origem__c = 'PE';
			analise.Status__c = 'Concluída';
			analise.Prazo_de_Instalacao__c = 15;
			listAnalise.add(analise);
		}

		update listAnalise;
		
		opp.By_pass__c = true;
		opp.Validado_juridico__c = true;
		opp.Validado_financeiro__c = true;
		opp.Description = 'Teste UMTelecom';
		opp.StageName = 'Negociação de valores';
        opp.Dia_do_vencimento__c = '1';
        opp.Meses__c = 12;
        opp.ContractTerm__c = 12;
        opp.StartDate__c = system.Today() + 10;
        update opp;

		opp.StageName = 'Fechado Ganho';
		update opp;

		List<OpportunityLineItem> listOli = [Select Id, quantity, Acao_contratual__c, Opportunity.Dia_do_vencimento__c, UnitPrice, Product2.Name, OpportunityId, Opportunity.AccountId, TotalPrice, ProductCode, Analise_de_viabilidade__c, Analise_de_viabilidade__r.RecordTypeId, Analise_de_viabilidade__r.Name, 
												Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_origem__c, Analise_de_viabilidade__r.CEP_de_destino__c, Analise_de_viabilidade__r.Numero_de_destino__c, 
												Analise_de_viabilidade__r.Data_da_conclusao__c, Analise_de_viabilidade__r.Qtd_Itens_Aprovacao__c, Analise_de_viabilidade__r.RecordType.Name, Analise_de_viabilidade__r.Complemento_da_origem__c, Analise_de_viabilidade__r.Numero_de_origem__c,
												Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Estado_de_destino__c, 
												Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, 
												Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Status__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c,
												Analise_de_viabilidade__r.Redundancia__c, Analise_de_viabilidade__r.Bloco_de_Ips__c, Analise_de_viabilidade__r.Tipo_de_atendimento__c, Analise_de_viabilidade__r.Burst__c, Analise_de_viabilidade__r.Cliente_final__c, 
												Analise_de_viabilidade__r.Quantidade_de_Ips__c, Analise_de_viabilidade__r.Atendido_por_parceiro__r.Codigo_SAP_cliente__c, Taxa_de_instalacao__c, Forma_de_pagamento_da_instalacao__c, Taxa_de_Burst__c, Banda_burst__c,
												Analise_de_viabilidade__r.Atendido_por_parceiro__c
												FROM OpportunityLineItem WHERE OpportunityId =: opp.Id];

		Contract contrato = new Contract();
		contrato.AccountId = opp.AccountId;
		contrato.ContractTerm = Integer.valueOf(opp.Meses__c);
		contrato.StartDate = opp.CloseDate;
		contrato.Status = 'Esboço';
		contrato.Oportunidade__C = opp.Id;
		contrato.Cortesia__c = opp.Cortesia__c;
		contrato.Permuta__c = opp.Permuta__c;
		contrato.Codigo_do_contrato__c = '4514';
		insert contrato;

		List<Item_do_Contrato__c> listItensContrato = new List<Item_do_Contrato__c>();
		for(OpportunityLineItem oli : listOli){
			Item_do_Contrato__c item = new Item_do_Contrato__c();
			item.Analise_de_Viabilidade__c = oli.Analise_de_viabilidade__c;
			item.Name =  oli.Product2.Name;
			item.Oportunidade__c = oli.OpportunityId;
			item.Produto__c = oli.Product2Id;
			// item.Numero_do_circuito__c = ;
			item.Conta__c = oli.Opportunity.AccountId;
			item.Contrato__c = contrato.Id;
			item.Banda__c = oli.Quantity;
			item.Valor__c = oli.TotalPrice;
			item.Ultima_acao_contratual__c = oli.Acao_contratual__c;
			item.Dia_de_Vencimento__c = String.valueOf(oli.Opportunity.Dia_do_vencimento__c);
			item.Status__c = 'AGUARDANDO';
			item.Tipo_de_logradouro_de_origem__c = oli.Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c;
			item.numero_de_origem__c = oli.Analise_de_viabilidade__r.numero_de_origem__c;
			item.Rua_de_origem__c = oli.Analise_de_viabilidade__r.Rua_de_origem__c;
			item.Estado_de_origem__c = oli.Analise_de_viabilidade__r.Estado_de_origem__c;
			item.Complemento_de_origem__c = oli.Analise_de_viabilidade__r.Complemento_da_origem__c;
			item.Cidade_de_origem__c = oli.Analise_de_viabilidade__r.Cidade_de_origem__c;
			item.CEP_de_origem__c = oli.Analise_de_viabilidade__r.CEP_de_origem__c;
			item.Bairro_de_origem__c = oli.Analise_de_viabilidade__r.Bairro_de_origem__c;
			item.Tipo_de_logradouro_de_destino__c = oli.Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c;
			item.numero_de_destino__c = oli.Analise_de_viabilidade__r.numero_de_destino__c;
			item.Rua_de_destino__c = oli.Analise_de_viabilidade__r.Rua_de_destino__c;
			item.Estado_de_destino__c = oli.Analise_de_viabilidade__r.Estado_de_destino__c;
			item.Complemento_de_destino__c = oli.Analise_de_viabilidade__r.Complemento_do_destino__c;
			item.Cidade_de_destino__c = oli.Analise_de_viabilidade__r.Cidade_de_destino__c;
			item.CEP_de_destino__c = oli.Analise_de_viabilidade__r.CEP_de_destino__c;
			item.Bairro_de_destino__c = oli.Analise_de_viabilidade__r.Bairro_de_destino__c;	
			item.Atendimento_por_parceiro__c = oli.Analise_de_viabilidade__r.Atendido_por_parceiro__c;	
			listItensContrato.add(item);
		}
		insert listItensContrato;
	}
}