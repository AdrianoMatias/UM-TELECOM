({
	ListaProdutos : function(component, event) {
		var action = component.get("c.getListaProduto");

		action.setParams({
			'idcatalogo' : component.get("v.recordId")
		})

		action.setCallback( this, function( response ) {
			var state = response.getState();
			if( state === "SUCCESS" ) {
				if(response.getReturnValue() != null && response.getReturnValue()!=''){
					component.set("v.catalogoProdutos", response.getReturnValue());
					component.set("v.PossuiProdutos", true);
				}else{
					component.set("v.PossuiProdutos", false);
				}
			}
		});

		$A.enqueueAction( action );		
	},


	addSelectedProductsHlp : function(component, event, helper, produtoAdicionado) {
		var action = component.get("c.adicaoProduto");
		console.log('teste' +JSON.stringify(produtoAdicionado));
		action.setParams({
			'produtoString' : JSON.stringify(produtoAdicionado),
			'idcatalogo' : component.get("v.recordId")
		})

		action.setCallback( this, function( response ) {
			var state = response.getState();
			if( state === "SUCCESS" ) {
				component.set("v.ListaProdutos", response.getReturnValue());
				var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"     : "Sucesso!",
                    "message"   : "Produtos adicionado com sucesso!",
                    "duration"  : 5000,
                    "type"      : "success"
                });
                toastEvent.fire();
				this.ListaProdutos(component, event);
			}else{
				var errors = action.getError();
				if( errors ) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title"     : "Erro",
						"message"   : "Houve um erro ao adicionar o produto: " + errors[0].message,
						"duration"  : 7000,
						"type"      : "error"
					});
					toastEvent.fire();
					
				}
			}

		});

		$A.enqueueAction( action );		
	}
})