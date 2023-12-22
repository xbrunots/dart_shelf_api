import 'package:postgres/postgres.dart';

import '../../../../shared/infra/connection/database.dart';
import '../../../../shared/infra/constants/infra_strings.dart';
import '../../../../shared/infra/data/interceptors/response_extensions.dart';
import '../../../../shared/infra/domain/select_usecase.dart';
import '../../../../shared/infra/drivers/drivers.dart';

class FlyDataSource {
  FlyDataSource._();

  static final instance = FlyDataSource._();

  Future<(Result?, String?)> executeQuery(query,
      {DriverEntity? driverEntity, Pool? pool}) async {
    try {
      final connection = pool ??
          await DataBaseFactory.instance.connection(driverEntity: driverEntity);
      final result = await connection.execute(query.toString());
      connection.close();
      return (result, null);
    } catch (Ex) {
      return (null, Ex.toString());
    }
  }

  Future<Result> test(query, {DriverEntity? driverEntity}) async {
    final connection =
        await DataBaseFactory.instance.connBuilder(driverEntity: driverEntity);
    final result = await connection.execute(query.toString());
    return result;
  }

  Future<(Result?, Exception?)> call(
    table, {
    Map<String, dynamic>? body,
        Map<String, dynamic>? options,
        Map<String, dynamic>? headers,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? params,
    DriverEntity? driverEntity,
        String? id,
        bool? isDelete,
        bool? isUpdate,
  }) async {
    try {
      final connection =
          await DataBaseFactory.instance.connection(driverEntity: driverEntity);

      List<Map<String, dynamic>> colsResult = [];

      if (headers?['hide'] != null) {
        final cols = await connection.execute(InfraStrings.selectCols(table));
        colsResult = cols.resultToListMap([]);
      }

      final queryResolve = ResolverSelectUseCase.instance.query(
        table,
        body: body,
        headers: headers,
        options: options,
        pathVariables: pathVariables,
        params: params,
        cols: colsResult,
        id: id,
        isDelete: isDelete,

        isUpdate: isUpdate,
      );



      final result = await executeQuery(
        queryResolve,
        driverEntity: driverEntity,
        pool: connection,
      );

      if (result.$1 != null) {
        return (result.$1, null);
      }

      return (
        null,
        Exception(
          result.$2,
        )
      );
    } on Exception catch (e) {
      return (null, e);
    }
  }
}
