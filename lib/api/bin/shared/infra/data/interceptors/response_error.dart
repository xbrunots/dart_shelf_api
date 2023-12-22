import 'dart:convert';

class ResponseError {
  static get({String? message,String? details}) {
    return json.encode({
      'error': message ?? 'Erro interno, tente novamente mais tarde!',
    });
  }
}
