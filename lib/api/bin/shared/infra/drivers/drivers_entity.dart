import 'drivers.dart';

class ConnectionEntity {
  String? id;
  String? createdAt;
  String? userId;
  String? projectId;
  String? name;
  String? host;
  String? port;
  String? databaseName;
  String? databasePwd;
  String? databaseUser;
  String? databaseSchema;
  String? type;
  bool? databaseUseSsl;

  ConnectionEntity({
    this.id,
    this.createdAt,
    this.userId,
    this.projectId,
    this.name,
    this.host,
    this.port,
    this.databaseName,
    this.databasePwd,
    this.databaseUser,
    this.databaseSchema,
    this.databaseUseSsl,
    this.type,
  });

  ConnectionEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    projectId = json['project_id'];
    name = json['name'];
    host = json['host'];
    port = json['port'];
    databaseName = json['database_name'];
    databasePwd = json['database_pwd'];
    databaseUser = json['database_user'];
    databaseSchema = json['database_schema'];
    databaseUseSsl = json['database_use_ssl'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['user_id'] = this.userId;
    data['project_id'] = this.projectId;
    data['name'] = this.name;
    data['host'] = this.host;
    data['port'] = this.port;
    data['database_name'] = this.databaseName;
    data['database_pwd'] = this.databasePwd;
    data['database_user'] = this.databaseUser;
    data['database_schema'] = this.databaseSchema;
    data['database_use_ssl'] = this.databaseUseSsl;
    data['type'] = this.type;
    return data;
  }

  DriverEntity  toDriverEntity() {
    return DriverEntity(
      host: this.host ?? '',
      database: this.databaseName ?? '',
      username: this.databaseUser ?? '',
      password: this.databasePwd ?? '',
      port: int.parse(
        this.port ?? '0',
      ),
      useSsl: this.databaseUseSsl ?? false,
    );
  }
}
