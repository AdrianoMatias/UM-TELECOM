({
	doInit : function(component, event, helper) {
		helper.ListaProdutos(component, event);
	},

	abrirModal : function(component, event, helper) {
		helper.ListaProdutos(component, event);
		component.set("v.isModalOpen",true);
	},

	fecharModal : function(component, event, helper) {
		component.set("v.isModalOpen",false);
		window.location.reload(3000);
		
	},

	adicionarProdutos : function(component, event, helper) {
		console.log("Starting addSelectedProductsCtrl");

		var produtoAdicionado = [];
		var listaProdutos = component.get("v.catalogoProdutos");
		console.log('listaProdutos >>> '+ listaProdutos);
		var produto = event.getSource().get("v.name");
		for(var counter = 0; counter < listaProdutos.length; counter++) {
			console.log('listaProdutos[counter].Name '+ listaProdutos[counter].codigoProduto);
			console.log('produto '+ produto);
			if(listaProdutos[counter].codigoProduto == produto) {
				produtoAdicionado.push(listaProdutos[counter]);
			}
		}
		if(produtoAdicionado.length > 0) {
			helper.addSelectedProductsHlp(component, event, helper, produtoAdicionado);
		} else {
			var toastEvent = $A.get("e.force:showToast");
	        toastEvent.setParams({
	            "title"	   : "Atenção!",
	            "message"  : "Houve problemas na adição de novos itens repita a operação.",
	            "duration" : 7000,
	            "type"	   : "warning"
	        });
			toastEvent.fire();
		}
		console.log("Finishing addSelectedProductsCtrl");
	}
})