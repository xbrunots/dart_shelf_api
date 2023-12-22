import 'dart:convert';

class Response {
  String? status;
  String? echo;
  int? requests;

  Response({this.status, this.echo, this.requests});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    echo = json['echo'];
    requests = json['requests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['echo'] = echo;
    data['requests'] = requests;
    return data;
  }

  dynamic toResponseBody() {
    return json.encode(toJson());
  }
}
