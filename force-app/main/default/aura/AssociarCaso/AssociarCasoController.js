({
    doInit : function(component, event, helper) {
        helper.loadCaso( component, event );        
    },

    consultaContratos : function(component, event, helper) {
        helper.consultaContratos( component, event );
        helper.consultaItensContratoConta( component, event );
    },

    consultarItensContrato : function(component, event, helper) {
        helper.consultarItensContrato( component, event );
    },

    salvar : function(component, event, helper) {
        helper.salvar( component, event );
    },

    filtrarItens : function(component, event, helper) {
        helper.filtrarItens( component, event );
    }
})