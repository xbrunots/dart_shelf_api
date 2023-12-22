import 'parse_usecase.dart';

class ResolverInsertUseCase {
  ResolverInsertUseCase._();

  static final instance = ResolverInsertUseCase._();

  String query(
    table, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? options,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? params,
  }) {
    print(body);
    String fields = '';
    String values = '';

    if (body != null) {
      fields = body.entries.map((e) => "${e.key}").toString();
      values = body.entries.map((e) => "'${e.value}'").toString();
    }

    final q = ''' 
                  INSERT INTO $table $fields
                  VALUES $values
                  RETURNING *;
    ''';

    print('--');
    print(q);
    print('--');
    return q;
  }
}
