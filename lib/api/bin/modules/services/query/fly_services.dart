import 'dart:convert';
import 'package:postgres/postgres.dart';

import '../../../env.dart';
import '../../../server.dart';
import '../../../shared/infra/data/interceptors/response_extensions.dart';
import '../../../shared/infra/drivers/drivers.dart';
import 'data/fly_response.dart';
import 'data/query_options_entity.dart';
import 'domain/fly_usecase.dart';

class FlyServices {
  FlyServices._();

  static final instance = FlyServices._();

  DriverEntity driver = Env.appDriver;

  factory FlyServices() {
    return instance;
  }

  Future<FlyResponse> apply(
    table, {
    FlyQueryOptions? options,
        Map<String, dynamic>? body,
        Map<String, dynamic>? headers,
    String? id,
        bool? isDelete,
        bool? isUpdate,
  }) async {
    Map<String, dynamic> opt = options?.toJson() ?? {};

    final result = await FlyUseCase.instance.call(
      table,
      body: body,
      options: opt,
      pathVariables: null,
      headers: headers,
      params: null,
      driverEntity: driver,
      id: id,
      isDelete: isDelete,
      isUpdate: isUpdate,
    );

    final raw = result.toResolveResponse();

    String response = await raw.readAsString();

    return FlyResponse.fromJson(json.decode(response));
  }

  Future<FlyResponse> query(query) async {
    (Result?, String?) result = await FlyUseCase.instance.executeQuery(
      query,
      driverEntity: driver,
    );

    if (result.$1 == null && result.$2 != null) {
      return FlyResponse(error: result.$2, data: null, count: 0);
    }

    final raw = result.$1?.resultToString([]);

    return FlyResponse.fromJson(json.decode(raw!));
  }
}
