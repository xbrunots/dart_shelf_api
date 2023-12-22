import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../server.dart';
import '../../shared/infra/data/interceptors/request_extensions.dart';
import '../../shared/infra/data/interceptors/response_extensions.dart';
import '../../shared/infra/drivers/drivers.dart';
import 'query/data/fly_response.dart';
import 'query/data/query_options_entity.dart';
import 'query/fly_services.dart';

class FlyRouter {
  FlyRouter._();

  static final instance = FlyRouter._();

  callById(Request request, String table, String id) async {
    if (request.method.toUpperCase().contains('GET')) {
      return read(request, table, id: id);
    } else if (request.method.toUpperCase().contains('PUT') ||
        request.method.toUpperCase().contains('POST') ||
        request.method.toUpperCase().contains('DELETE')) {
      return write(request, table, id: id);
    }
  }

  call(Request request, String table) async {
    if (request.method.toUpperCase().contains('GET')) {
      return read(request, table);
    } else if (request.method.toUpperCase().contains('PUT') ||
        request.method.toUpperCase().contains('POST') ||
        request.method.toUpperCase().contains('DELETE')) {
      return write(request, table);
    }
  }

  write(Request request, String table, {String? id}) async {
    try {
      Map<String, dynamic> body = await request.toMap();
      Map<String, dynamic> headers = request.headers;
      Map<String, dynamic> pathVariables = request.params;
      Map<String, dynamic> params = request.url.queryParameters;

      FlyResponse response = await FlyServices.instance.apply(
        table,
        body: body,
        id: id,
        headers: headers,
        isDelete: request.method.toUpperCase().contains('DELETE'),
        isUpdate: request.method.toUpperCase().contains('PUT'),
      );

      return response.toResponseSuccess();
    } on Exception catch (e) {
      return responseParsed(result: null, exception: e, cols: []);
    }
  }

  read(Request request, String table, {String? id}) async {
    try {
      Map<String, dynamic> body = await request.toMap();
      Map<String, dynamic> options = body;
      Map<String, dynamic> headers = request.headers;
      Map<String, dynamic> pathVariables = request.params;
      Map<String, dynamic> params = request.url.queryParameters;

      FlyQueryOptions? optJson;
      if (request.method.toUpperCase().contains('GET')) {
        optJson = FlyQueryOptions.fromJson(options);
      }

      FlyResponse response =
          await FlyServices.instance.apply(table, options: optJson);

      return response.toResponseSuccess();
    } on Exception catch (e) {
      return responseParsed(result: null, exception: e, cols: []);
    }
  }
}
