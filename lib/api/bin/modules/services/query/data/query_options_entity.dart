import 'dart:convert';

class FlyQueryOptions {
  String? showFields;
  String? hideFields;
  String? filter;
  String? orderBy;
  String? groupBy;
  int? limit;
  int? page;

  FlyQueryOptions(
      {this.showFields,
      this.hideFields,
      this.filter,
      this.orderBy,
      this.groupBy,
      this.limit,
      this.page});

  FlyQueryOptions.fromJson(Map<String, dynamic> json) {
    showFields = json['show'];
    hideFields = json['hide'];
    filter = json['filter'];
    orderBy = json['order_by'];
    groupBy = json['group_by'];
    limit = json['limit'] ?? 100;
    page = json['page'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show'] = this.showFields;
    data['hide'] = this.hideFields;
    data['filter'] = this.filter;
    data['order_by'] = this.orderBy;
    data['group_by'] = this.groupBy;
    data['limit'] = this.limit;
    data['page'] = this.page;
    return data;
  }
}
