import 'parse_usecase.dart';

class ResolverUpdateUseCase {
  ResolverUpdateUseCase._();

  static final instance = ResolverUpdateUseCase._();

  String query(
    table,
    id, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? options,
     Map<String, dynamic>? headers,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? params,
  }) {
    print(body);
    String updateValues = '';

    if (body != null) {
      updateValues = body.entries
          .map((e) => "${e.key} = '${e.value}'")
          .toString()
          .replaceAll('(', '')
          .replaceAll(')', '');
    }

    String where = " where id = '$id' ";
    if (headers?['filter'] != null) {
      where = ParseUseCase.instance.resolver(headers?['filter'], 'where');
    }

    final q = '''
                 UPDATE $table
                 SET $updateValues 
                    $where
                 RETURNING *;    
    ''';

    print('--');
    print(q);
    print('--');
    return q;
  }
}
