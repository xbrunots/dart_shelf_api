import 'parse_usecase.dart';

class ResolverDeleteUseCase {
  ResolverDeleteUseCase._();

  static final instance = ResolverDeleteUseCase._();

  String query(
    table,
    id, {
    Map<String, dynamic>? body,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? options,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? params,
  }) {


    String where = " where id = '$id' ";
    if(headers?['filter']!=null){
      where = ParseUseCase.instance.resolver(headers?['filter'], 'where');
    }

    final q = ''' 
                 DELETE FROM  $table
                    $where 
                   RETURNING *;  
    ''';

    print('--');
    print(q);
    print('--');
    return q;
  }
}
