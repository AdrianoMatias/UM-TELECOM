({
	doInit : function(component, event, helper) {
        console.log("Starting doInit");
        
        component.set("v.showSpinner", true);
        helper.retrieveValor(component, event, helper);
        
        console.log("Exiting doInit");
    },
    
    selectValor : function(component, event, helper) {
        var valor = component.find("numberValor").get("v.value");
        component.set("v.valor", valor);
    }
})