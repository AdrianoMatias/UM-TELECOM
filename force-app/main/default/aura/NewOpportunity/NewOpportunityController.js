({
	button : function(cmp, event, helper) {
		if (event.getSource().getLocalId() === "cancelar") {
            helper.cancelar(cmp, event, helper);
        } else if (event.getSource().getLocalId() === "salvar") {
            helper.salvar(cmp, event, helper);
        }
	},
    
    waiting: function(component, event, helper) {
  		component.set("v.carregando", true);
 	},
    
 	doneWaiting: function(component, event, helper) {
  		component.set("v.carregando", false);
 	}
})