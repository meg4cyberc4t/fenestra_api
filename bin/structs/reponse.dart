class ApiResponse {
  const ApiResponse(this.response);
  final dynamic response;

  Map toMap() {
    return {"response": response};
  }
}
