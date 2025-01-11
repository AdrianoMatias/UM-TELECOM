({
	doInit : function(component, event, helper) {
		helper.loadAccountConfigs( component, event );
		helper.loadAccountFields( component, event );
		helper.loadTokenSintegra( component, event );
	},

	onChangeAccountField : function( component, event, helper ) {
		helper.onChangeAccountField( component, event );
	},

	doSaveAccountConfigs : function( component, event, helper ) {
		helper.doSaveAccountConfigs( component, event );
	},

	doSaveCustomSettings : function( component, event, helper ) {
		helper.doSaveCustomSettingsHLP( component, event );
	}
})