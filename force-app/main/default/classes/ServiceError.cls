public with sharing class ServiceError {
	private Integer code;
	private String status;
	private String description;

	public static void throwServiceError( Integer code, String error, String errorDescription ) {
		RestContext.response.statusCode = code;
		ErrorVO errorVO = new ErrorVO();
		errorVO.status_code = String.valueOf(code);
		errorVO.error = error;
		errorVO.error_description = errorDescription;
		RestContext.response.responseBody = Blob.valueOf( JSON.serialize( errorVO ) );
	}

	public class ErrorVO {
		public String error;
		public String error_description;
		public String status_code;
	}
}