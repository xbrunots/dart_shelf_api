import '../../logs/logger.dart';
import '../connection/database.dart';
import 'delete_usecase.dart';
import 'insert_usecase.dart';
import 'parse_usecase.dart';
import 'update_usecase.dart';

class ResolverSelectUseCase {
  ResolverSelectUseCase._();

  static final instance = ResolverSelectUseCase._();

  String query(
    table, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? options,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? params,
    List<Map<String, dynamic>>? cols,
    String? id,
    bool? isDelete,
    bool? isUpdate,
  }) {
    // if (body != null && body['query'] != null) {
    //   return body['query'];
    // }

    if (body != null) {
      if (isDelete == true) {
        return ResolverDeleteUseCase.instance.query(
          table,
          id,
          body: body,
          headers: headers,
          options: options,
          pathVariables: pathVariables,
          params: params,
        );
      }
      if (isUpdate == true) {
        return ResolverUpdateUseCase.instance.query(
          table,
          id,
          body: body,
          headers: headers,
          options: options,
          pathVariables: pathVariables,
          params: params,
        );
      }

      if (id == null) {
        return ResolverInsertUseCase.instance.query(
          table,
          body: body,
          options: options,
          pathVariables: pathVariables,
          params: params,
        );
      }

      return '';
    } else {
      String showList = options?['show'].toString().toLowerCase() ?? '';

      String hideList = options?['hide'].toString().toLowerCase() ?? '';

      String where =
          ParseUseCase.instance.resolver(options?['filter'], 'where');

      String orderBy =
          ParseUseCase.instance.resolver(options?['order_by'], 'order by');

      String groupBy =
          ParseUseCase.instance.resolver(options?['group_by'], 'group by');

      String limit = ParseUseCase.instance.resolver(options?['limit'], 'limit');

      String page = ParseUseCase.instance.resolver(options?['page'], 'OFFSET');

      String fieldsResult = "*";

      if (cols != null && cols.isNotEmpty) {
        if (options?['show'] == null) {
          showList = cols.map((e) => e['column_name'].toString()).toString();
        }

        //buscar fields na tabela
        final fieldsRaw = cols.where((c) =>
            showList.contains(c['column_name'].toString().toLowerCase()));

        //esconder fields da lista
        final fields = fieldsRaw.where((c) =>
            !hideList.contains(c['column_name'].toString().toLowerCase()));

        fieldsResult = fields
            .map((e) => e['column_name'])
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', '');
      }

      if (options?['show'] != null) {
        fieldsResult = showList;
      }

      final q =
          "SELECT $fieldsResult from $table $where $groupBy $orderBy $limit $page";
      print('--');
      print(q);
      print('--');
      return q;
    }
  }
}
