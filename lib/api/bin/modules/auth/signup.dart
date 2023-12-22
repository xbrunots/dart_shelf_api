import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../shared/infra/data/interceptors/request_extensions.dart';
import '../../shared/infra/data/interceptors/response_extensions.dart';
import '../../shared/infra/drivers/drivers.dart';
import '../../shared/infra/security/encrypt/encrypt.dart';
import '../../shared/infra/security/security_service_impl.dart';
import '../services/query/fly_services.dart';

class SignupRoute {
  SignupRoute._();

  static final instance = SignupRoute._();

  call(
    Request request,
  ) async {
    try {
      Map<String, dynamic> body = await request.toMap();

      final user = body['email'];
      final pwd = body['pwd'];
      final name = body['name'];
      final confirmPwd = body['confirm_pwd'];

      final responseExist = await FlyServices.instance
          .query("select * from df_users where email ilike '$user' ");

      if ((responseExist.count ?? 0) > 0) {
        return toApiBadRequest('Usuário $user já existe!');
      }

      if (confirmPwd != pwd) {
        return toApiBadRequest('Senhas diferentes!');
      }

      if (pwd.toString().length < 6) {
        return toApiBadRequest('A senha deve ter ao menos 6 letras!');
      }

      final pwdCrypt = AppEncrypt.instance.digest(pwd);
      final newName = name != null ? "'$name'" : null;

      final q = ''' 
                  INSERT INTO df_users ("email", "pwd", "name")
                  VALUES ('$user', '$pwdCrypt', $newName);
    ''';

      final result = await FlyServices.instance.query(q);

      if (result.error == null) {
        final Map<String, dynamic> res = {
          'success': true,
        };

        return res.toApiSuccess();
      }

      return result.toResponseSuccess();
    } catch (e) {
      return toApiBadRequest(e.toString());
    }
  }
}
