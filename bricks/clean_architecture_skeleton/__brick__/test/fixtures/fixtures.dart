import 'dart:convert';
import 'dart:io';

import 'package:{{name.snakeCase()}}/core/constants/json_constant.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> jsonFromFixture(String name) {
  var jsonString = fixture(name);
  var data = jsonDecode(jsonString)[JsonConstant.data] as Map<String, dynamic>;

  if (data.containsKey(JsonConstant.attributes)) {
    return {
      JsonConstant.id: data[JsonConstant.id],
      ...data[JsonConstant.attributes],
    };
  }

  return data;
}
