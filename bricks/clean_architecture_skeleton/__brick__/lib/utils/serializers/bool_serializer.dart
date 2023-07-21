import 'package:json_annotation/json_annotation.dart';

class BoolSerializer extends JsonConverter<bool, int> {
  const BoolSerializer();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool object) => object ? 1 : 0;
}
