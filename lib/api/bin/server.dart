import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'routes/routes.dart';
import 'shared/infra/drivers/drivers.dart';
import 'shared/infra/security/security_service_impl.dart';


void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: 'localhost:8080',
    'Content-Type': 'application/json;charset=utf-8'
  };

  var _security = SecurityServiceImp();

  final handler = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addMiddleware(_security.authorization)
      .addMiddleware(_security.verifyJWT)
      .addHandler(
        AppRouter.routes(),
      );

  final port = int.parse(Platform.environment['PORT'] ?? '80');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
