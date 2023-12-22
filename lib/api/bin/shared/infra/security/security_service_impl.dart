import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../../env.dart';
import '../../data/utils/headers.dart';
import '../data/interceptors/response_error.dart';
import 'security_service.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  @override
  Future<String> generateJWT(String userId,
      {Map<String, dynamic>? payload}) async {
    var jwt = JWT({
      'userId': userId,
      'payload': payload,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'roles': ['default'],
    });

    String token = jwt.sign(SecretKey(Env.jwtKey));

    return token;
  }

  @override
  Future<JWT?> validateJWT(String token) async {
    try {
      return JWT.verify(token, SecretKey(Env.jwtKey));
    } on JWTInvalidException {
      return null;
    } on JWTExpiredException {
      return null;
    } on JWTNotActiveException {
      return null;
    } on JWTUndefinedException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Middleware get authorization {
    return (Handler handler) {
      return (Request req) async {
        var authorizationHeader = req.headers['authorization'];

        JWT? jwt;

        if (authorizationHeader != null) {
          String token = authorizationHeader;
          if (authorizationHeader.startsWith('Bearer ')) {
            token = authorizationHeader.substring(7);
          }
          jwt = await validateJWT(token);
        }
        var request = req.change(context: {'jwt': jwt});
        return handler(request);
      };
    };
  }

  @override
  Middleware get verifyJWT => createMiddleware(
        requestHandler: (
          Request req,
        ) {
          if (req.url.path == 'auth/login') return null;
          if (req.url.path == 'auth/signup') return null;
          if (req.url.path.startsWith('public/')) return null;

          if (req.context['jwt'] == null) {
            return Response.forbidden(
              ResponseError.get(message: 'Token inválido ou expirado!'),
              headers: HeadersUtils.headersDefault,
            );
          }
          ;
        },
      );
}
