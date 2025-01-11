({
    doInit : function(component, event, helper) {
        console.log("Starting doInit");
         
        helper.retrieveCnpjs(component, event, helper);
        
        console.log("Exiting doInit");
    },
    
    selecionarCtrl :  function(component, event, helper) {
        console.log("Starting selecionarCtrl");
        
        helper.selecionarHlp(component, event, helper);
        
        console.log("Exiting selecionarCtrl");
    },
    
    selectCNPJ : function(component, event, helper) {
        var cnpj = component.find("picklistCnpj").get("v.value");
        cnpj = cnpj.substring(0, 19);
        component.set("v.cnpj", cnpj);
    }
})