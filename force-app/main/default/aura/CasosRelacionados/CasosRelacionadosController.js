({
	doInit : function(component, event, helper) {
		helper.consultarCasosRelacionados(component, event);
        component.set('v.numeroCasos', '0');
	},
    
    redirect : function(component, event){
        var workspaceAPI = component.find("workspace");
        var index = event.currentTarget.id;
        var list = component.get('v.casosRelacionados');
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId":index,
                    "actionName":"view"
                },
                "state": {}
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
        }).then(function(tabInfo) {
            console.log("The recordId for this tab is: " + tabInfo.recordId);
        });
        }).catch(function(error) {
            console.log(error);
        });
        
    },
})