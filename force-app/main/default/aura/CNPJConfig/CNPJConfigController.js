({
	doInit : function(component, event, helper) {
		helper.loadAccountConfigs( component, event );
		helper.loadAccountFields( component, event );
		helper.loadContactConfigs( component, event );
		helper.loadContactFields( component, event );
		helper.loadTokenReceita( component, event );
		helper.loadTokenMaps( component, event );
	},

	onChangeAccountField : function( component, event, helper ) {
		helper.onChangeAccountField( component, event );
	},

	onChangeContactField : function( component, event, helper ) {
		helper.onChangeContactField( component, event );
	},

	doSaveAccountConfigs : function( component, event, helper ) {
		helper.doSaveAccountConfigs( component, event );
	},

	doSaveContactsConfigs : function( component, event, helper ) {
		helper.doSaveContactsConfigs( component, event );
	},

	doSaveCustomSettings : function( component, event, helper ) {
		helper.doSaveCustomSettingsHLP( component, event );
	}
})