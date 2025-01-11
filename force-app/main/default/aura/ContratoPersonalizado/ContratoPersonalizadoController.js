({
	doInit : function(component, event, helper) {
		helper.getData(component, event);
	},

	handleUploadFinished : function(component, event, helper) {
		helper.updateContractHLP(component, event);
	},

	deleteFile : function(component, event, helper) {
		helper.removeFile(component, event);	
	},

	onMarcarEnviarContratosPadroes: function (component, event, helper) {
		helper.marcarEnviarContratosPadroes(component, event);
    }
})