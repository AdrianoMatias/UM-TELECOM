({
	doInit : function(component, event, helper) {
        helper.ValidarAnexo(component, event, helper);
		//helper.populaMotivo(component, event, helper);
		helper.getLocation(component, event, helper);
	},

	confirmar: function(component, event, helper) {
		console.log('>>> '+component.get("v.indMapaRend"));
		if(component.get("v.indMapaRend")==true){
			helper.confirmarHLP(component, event, helper);
		}else{
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title"     : "Informe",
				"message"   : "Aguarde a renderização do mapa",
				"duration"  : 5000,
				"type"      : "info"
			});
			toastEvent.fire();
		}
	},

	recarregar: function(component, event, helper) {
		helper.getLocation(component, event, helper);
	},

	justificar: function(component, event, helper) {
		component.set("v.indMotiv",true);
	},

	cancelarModal: function(component, event, helper) {
		component.set("v.indMotiv",false);
		component.set("v.motivo",null);
		component.set("v.justificativa",null);
	},

	exibirJustificativa: function(component, event, helper) {
		var nome = event.getSource().get("v.value");
		console.log('nome'+nome);
		if(nome=='Outro'){
			component.set("v.indjustif",true);
		}else{
			component.set("v.indjustif",false);
			component.set("v.justificativa",null);
		}
	}
})