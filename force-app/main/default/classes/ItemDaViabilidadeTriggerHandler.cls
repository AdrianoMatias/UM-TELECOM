public class ItemDaViabilidadeTriggerHandler  {

	public static void preencheCampos(){
		List<Item_da_viabilidade__c> listItensViab = (List<Item_da_viabilidade__c>) Trigger.new;
		Map<Id,Produto_de_viabilidade__c> mapItensProd = new Map<Id,Produto_de_viabilidade__c>([Select Id, Capex__c, UltimoPrecoDeCompra__c, TipoDeItem__c FROM Produto_de_viabilidade__c LIMIT 5000]);

		for(Item_da_viabilidade__c itemViab : listItensViab){
			if(itemViab.Produto_de_viabilidade__c != null){
				//itemViab.Valor__c = mapItensProd.get(itemViab.Produto_de_viabilidade__c).Valor_unitario__c;
				itemViab.Valor__c = itemViab.Valor__c != null ? itemViab.Valor__c : mapItensProd.get(itemViab.Produto_de_viabilidade__c).UltimoPrecoDeCompra__c;
                itemViab.Tipo_de_item__c = mapItensProd.get(itemViab.Produto_de_viabilidade__c).TipoDeItem__c;
                // itemViab.Valor__c = mapItensProd.get(itemViab.Produto_de_viabilidade__c).UltimoPrecoDeCompra__c;
				itemViab.Capex__c = mapItensProd.get(itemViab.Produto_de_viabilidade__c).Capex__c;
			}
            
			itemViab.Necessario_aprovacao__c = ((itemViab.Aprovacao_a_partir_de__c != null && itemViab.Aprovacao_a_partir_de__c>0) && (itemViab.Quantidade__c != null && itemViab.Quantidade__c>0) && itemViab.Aprovacao_a_partir_de__c<=itemViab.Quantidade__c ? true : false);
		}
	}
}