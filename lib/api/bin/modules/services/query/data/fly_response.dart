import 'dart:convert';

class FlyResponse {
  int? count;
  dynamic data;
  String? error;

  FlyResponse({
    this.count,
    this.data,
    this.error,
  });

  FlyResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    data = json['data'];
    error= json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['count'] = this.count;
    json['data'] = this.data;
    json['error'] = this.error;
    return json;
  }
}

extension FlyResponseExt on (FlyResponse?, String?) {
  bool isSuccess() {
    return ($2 == null && $1 != null);
  }
}
