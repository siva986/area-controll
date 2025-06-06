class ApiHeaders {
  String auth = '';
  String cityId = '';

  Map<String, String> get apiheaders {
    var temp = {'Content-Type': 'application/json', 'Barrier': auth};
    temp.removeWhere((key, value) => value.isEmpty);
    return temp;
  }
}
