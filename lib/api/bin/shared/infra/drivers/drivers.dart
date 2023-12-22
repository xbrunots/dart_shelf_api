import '../../../env.dart';

class DriverEntity {
  final String host;
  final String database;
  final String username;
  final String password;
  final int port;
  final bool useSsl;

  DriverEntity({
    required this.host,
    required this.database,
    required this.username,
    required this.password,
    required this.port,
    this.useSsl = false,
  });
}

class Drivers {
  static DriverEntity current = Env.appDriver;
}
