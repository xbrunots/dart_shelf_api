import 'package:postgres/postgres.dart';

import '../drivers/drivers.dart';

class DataBaseFactoryLegacy {
  DataBaseFactoryLegacy._();

  static final instance = DataBaseFactory._();

  DriverEntity? internalDriver;
  Connection? conn;

  open({bool? isATest}) async {
    conn = await connBuilder(driverEntity: internalDriver);
  }

  connBuilder({DriverEntity? driverEntity}) async {
    return await Connection.open(
        Endpoint(
          host: driverEntity?.host ?? Drivers.current.host,
          database: driverEntity?.database ?? Drivers.current.database,
          username: driverEntity?.username ?? Drivers.current.username,
          password: driverEntity?.password ?? Drivers.current.password,
          port: driverEntity?.port ?? Drivers.current.port,
        ),
        settings: ConnectionSettings(
          sslMode: Drivers.current.useSsl ? SslMode.require : SslMode.disable,
        ));
  }

  Future<Connection> connection({DriverEntity? driverEntity}) async {
    if (driverEntity != internalDriver && driverEntity != null) {
      internalDriver = driverEntity;
      if (conn?.isOpen == true) {
        conn?.close();
      }
    }

    if (conn == null || conn?.isOpen != true) {
      await open();
    }
    return conn!;
  }

  close() {
    conn?.close();
  }
}

class DataBaseFactory {
  DataBaseFactory._();

  static final instance = DataBaseFactory._();

  DriverEntity? internalDriver;
  Pool? pool;

  open({bool? isATest}) {
    pool = connBuilder(driverEntity: internalDriver);
  }

  connBuilder({DriverEntity? driverEntity}) {
    //var uri = 'postgres://username:password@localhost:5432/database';
    return Pool.withEndpoints([
      Endpoint(
        host: driverEntity?.host ?? Drivers.current.host,
        database: driverEntity?.database ?? Drivers.current.database,
        username: driverEntity?.username ?? Drivers.current.username,
        password: driverEntity?.password ?? Drivers.current.password,
        port: driverEntity?.port ?? Drivers.current.port,
      ),
    ],
        settings: PoolSettings(
          sslMode: Drivers.current.useSsl ? SslMode.require : SslMode.disable,
        ));
  }

  Future<Pool> connection({DriverEntity? driverEntity}) async {
    if (driverEntity != internalDriver && driverEntity != null) {
      internalDriver = driverEntity;
      if (pool?.isOpen == true) {
        pool?.close();
      }
    }

    if (pool == null || pool?.isOpen != true) {
      await open();
    }
    return pool!;
  }

  close() {
    pool?.close();
  }
}
