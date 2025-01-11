({
	inicializaLista: function (component, event) {
		var action = component.get("c.listaProduto");

		action.setParams({
			'idOportunidade': component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.listaProdutos", response.getReturnValue());
				// component.set("v.possuiProdutos", true);
				component.set("v.isModalOpen", true);
			}
		});
		$A.enqueueAction(action);
	},

	criaContratoHelper: function (component, event) {
		var ids = new Array();
		component.set("v.showSpinner",true);
		var getAllId = component.find("boxPack");
		if (!Array.isArray(getAllId)) {
			if (component.find("boxPack").get("v.value") == true) {
				ids.push(component.find("boxPack").get("v.name"));
			}
		} else {
			for (var i = 0; i < getAllId.length; i++) {
				if (component.find("boxPack")[i].get("v.value") == true) {
					ids.push(component.find("boxPack")[i].get("v.name"));
				}
			}
		}
		var action = component.get('c.getEnvioSAPContrato');
		action.setParams({
			'oppId': component.get('v.recordId'),
			'IdOlis': JSON.stringify(ids)
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log(state);
			if (state === "SUCCESS") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Sucesso!",
					"message": "Contrato criado com sucesso!",
					"type": "success",
					"mode": "dismissible"
				});
				toastEvent.fire();
				this.inicializaLista(component, event);
				component.set("v.showSpinner", false);
				$A.get('e.force:refreshView').fire();
			} else {
				var errors = action.getError();

				if (errors) {
					if (errors[0] && errors[0].message) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"title": 'Houve um erro ao criar o contrato!',
							"message": errors[0].message,
							"type": "error"
						});
						toastEvent.fire();
						// $A.get('e.force:refreshView').fire();
						// $A.get("e.force:closeQuickAction").fire();
					}
				}
				component.set("v.showSpinner", false);
			}
		});
		
		$A.enqueueAction(action);
	}
})