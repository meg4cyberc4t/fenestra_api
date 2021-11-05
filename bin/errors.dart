class ApiErrorStruct {
  const ApiErrorStruct({required this.name, required this.code});
  final int code;
  final String name;

  Map<String, dynamic> toJson() => {'name': name, 'code': code};
}

class ApiError {
  static const ApiErrorStruct notFound =
      ApiErrorStruct(name: 'Not found', code: 1104);
}
