import '../constants/json_constant.dart';
import '../extension/typedef.dart';

typedef Parser<T> = T Function(dynamic json);

class ParserJson<T> {
  late String message;
  late T data;
  late bool status;

  ParserJson.fromJson(JSON json, Parser<T> parser) {
    message = json[JsonConstant.message];
    data = parser(json[JsonConstant.data]);
    status = json[JsonConstant.status];
  }

  ParserJson({
    required this.message,
    required this.data,
    required this.status,
  });
}
