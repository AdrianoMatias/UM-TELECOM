public with sharing class ServiceUtils {

	public static String validarCamposObrigatorios( String requestJSON, Set<String> campos ) {
		String result;
		Map<String,Object> requestJSONMap = (Map<String,Object>) JSON.deserializeUntyped( requestJSON );

		for( String campo : campos ) {
			if( requestJSONMap.containsKey(campo) ) {
				if( requestJSONMap.get( campo  ) == null ) {
					result = campo;
					break;
				}
			} else {
				result = campo;
			}
		}

		return result;
	}
}