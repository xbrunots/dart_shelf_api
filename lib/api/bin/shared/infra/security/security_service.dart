import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

abstract class SecurityService<T> {
  Future<String> generateJWT(String userId);

  Future<JWT?> validateJWT(String token);

  Middleware get verifyJWT;

  Middleware get authorization;
}
