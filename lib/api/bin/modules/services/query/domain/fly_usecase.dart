import 'package:postgres/postgres.dart';

import '../../../../shared/base/base_usecase.dart';
import '../../../../shared/infra/connection/database.dart';
import '../../../../shared/infra/drivers/drivers.dart';
import '../data/fly_datasource.dart';

class FlyUseCase {
  FlyUseCase._();

  static final instance = FlyUseCase._();

  Future<(Result?, Exception?)> call(
    table, {
    Map<String, dynamic>? body,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? options,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? params,
    DriverEntity? driverEntity,
        String? id,
        bool? isDelete,
        bool? isUpdate,
  }) async {
    try {
      final result = await FlyDataSource.instance.call(
        table,
        body: body,
        headers: headers,
        pathVariables: pathVariables,
        options: options,
        params: params,
        driverEntity: driverEntity,
        id: id,
        isDelete : isDelete,
        isUpdate: isUpdate,
      );

      return result;
    } on Exception catch (e) {
      return (null, e);
    }
  }

  Future<(Result?, String?)> executeQuery(query,
      {DriverEntity? driverEntity}) async {
    try {
      print('Execute Query');
      print(query);
      print('----------');

      final connection =
          await DataBaseFactory.instance.connection(driverEntity: driverEntity);
      final result = await connection.execute(query.toString());
      connection.close();
      return (result, null);
    } catch (Ex) {
      return (null, Ex.toString());
    }
  }
}
