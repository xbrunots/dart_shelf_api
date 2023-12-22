import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../modules/auth/login.dart';
import '../modules/auth/signup.dart';
import '../modules/services/fly_router.dart';

class AppRouter {
  static shelf_router.Router routes() {
    const fly_route = '/api/<table>';
    const login = '/auth/login';
    const signup = '/auth/signup';

    final router = shelf_router.Router()
      ..post(
        '$login',
        LoginRoute.instance.call,
      )
      ..delete(
        '$fly_route',
        FlyRouter.instance.call,
      )
      ..get(
        fly_route,
        FlyRouter.instance.call,
      )
      ..put(
        fly_route,
        FlyRouter.instance.call,
      )
      ..post(
        '$fly_route',
        FlyRouter.instance.call,
      )
      ..post(
        '$signup',
        SignupRoute.instance.call,
      );
    return router;
  }
}
