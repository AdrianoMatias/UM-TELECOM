({
	doInit: function (component, event, helper) {
		helper.inicializaLista(component, event);
	},

	fecharModal: function (component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
		component.set("v.isModalOpen", false);
	},

	selecionarTodos: function (component, event, helper) {

		var selectedHeaderCheck = event.getSource().get("v.value");
		var getAllId = component.find("boxPack");

		if (!Array.isArray(getAllId)) {
			if (selectedHeaderCheck == true) {
				component.find("boxPack").set("v.value", true);
				component.set("v.contadorSelecionados", 1);
			} else {
				component.find("boxPack").set("v.value", false);
				component.set("v.contadorSelecionados", 0);
			}
		} else {
			if (selectedHeaderCheck == true) {
				for (var i = 0; i < getAllId.length; i++) {
					component.find("boxPack")[i].set("v.value", true);
					component.set("v.contadorSelecionados", getAllId.length);
				}
			} else {
				for (var i = 0; i < getAllId.length; i++) {
					component.find("boxPack")[i].set("v.value", false);
					component.set("v.contadorSelecionados", 0);
				}
			}
		}
	},

	criaContratoWebhookJS: function (component, event, helper) {
		helper.criaContratoWebhookHelper(component, event);
	}
})