public interface ServiceInterface {

	void doPost();

	void doGet();

	void doPatch();

	void doPut();

	void doDelete();

	String checkJSONSchema(String jsonSchema);

}