import 'dart:convert';

extension jsonExt on Map<String, dynamic> {
  dynamic toResponseBody() {
    return json.encode(this);
  }

  dynamic toListResponseBody() {
    return json.decode(json.encode(this));
  }

  String toFriendlyJson() {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(jsonEncode(this));
    return prettyprint;
  }
}

extension jsonListExt on List<dynamic> {
  dynamic toResponseBody() {
    return json.encode(this);
  }
}
