import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../shared/infra/data/interceptors/request_extensions.dart';
import '../../shared/infra/data/interceptors/response_extensions.dart';
import '../../shared/infra/security/encrypt/encrypt.dart';
import '../../shared/infra/security/security_service_impl.dart';
import '../services/query/fly_services.dart';

class LoginRoute {
  LoginRoute._();

  static final instance = LoginRoute._();

  call(
    Request request,
  ) async {
    try {
      Map<String, dynamic> body = await request.toMap();

      final user = body['email'];
      final pwd = body['pwd'];

      final result = await FlyServices.instance
          .query("Select * from df_users where email = '$user' ");

      if ((result.count ?? 0) < 1 || result.error != null) {
        return toApiForbidden(result.error?.toString() ?? 'Acesso Negado!');
      }

      if (AppEncrypt.instance.digest(pwd).toString() != result.data.first['pwd']) {
        return toApiForbidden(result.error?.toString() ?? 'Acesso Negado!');
      }

      var _security = SecurityServiceImp();

      String token =
          await _security.generateJWT('${result.data.first['uid']}', payload: {
        'uid': result.data.first['uid'],
        'email': result.data.first['email'],
        'name': result.data.first['name'],
      });

      final Map<String, dynamic> res = {
        'token': token,
        'uid': result.data.first['uid'],
        'email': result.data.first['email'],
        'name': result.data.first['name'],
      };

      return res.toApiSuccess();
    } catch (e) {
      return toApiBadRequest(e.toString());
    }
  }
}
