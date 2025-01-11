public class Utils  {
	public static List<Map<String, String>> getMapPicklistValues(String str_APIName_Object, String str_APIName_Field) {
		List<Map<String, String>> mapValuesPickList = new List<Map<String, String>> ();
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(str_APIName_Object);
		if (targetType != null) {
			sObject sobj = targetType.newSObject();
			Schema.DescribeSObjectResult describeSObjectResult = sobj.getSObjectType().getDescribe();
			Map<String, Schema.SObjectField> fields = describeSObjectResult.fields.getMap();
			Schema.SObjectField fld = fields.get(str_APIName_Field);
			if (fld != null) {
				if (fld.getDescribe().getType().equals(Schema.DisplayType.PICKLIST) || fld.getDescribe().getType().equals(Schema.DisplayType.MULTIPICKLIST)) {
					Schema.DescribeFieldResult fieldResult = fld.getDescribe();
					List<Schema.PicklistEntry> listPickListEntry = fieldResult.getPicklistValues();
					for (Schema.PicklistEntry pickListVal : listPickListEntry) {
						Map<String, String> lMap = new Map<String, String> ();
						lMap.put('label', picklistVal.getLabel());
						lMap.put('value', pickListVal.getValue());
						mapValuesPickList.add(lMap);
					}
					return mapValuesPickList;
				}
			}
		}
		//System.debug('PICKLISTVALUES ' + json.serializePretty(mapValuesPickList));
		return mapValuesPickList;
	}
}