class ApiErrorStruct {
  const ApiErrorStruct({required this.error, required this.code});
  final int code;
  final String error;

  Map toMap() {
    return {"error": error, "code": code};
  }
}

class ApiError {
  static const ApiErrorStruct unauthorized =
      ApiErrorStruct(error: 'Unauthorized', code: 1101);
  static const ApiErrorStruct notFound =
      ApiErrorStruct(error: 'Not found', code: 1102);
  static const ApiErrorStruct accessDenied =
      ApiErrorStruct(error: 'Access Denied', code: 1104);
  static const ApiErrorStruct badArguments =
      ApiErrorStruct(error: 'Bad Arguments', code: 1105);
  static const ApiErrorStruct tokenExpired =
      ApiErrorStruct(error: "Token expired", code: 1106);
  static const ApiErrorStruct notUniqueValue =
      ApiErrorStruct(error: "Not unique value", code: 1201);
}
