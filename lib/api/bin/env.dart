import 'shared/infra/drivers/drivers.dart';

class Env {
  static DriverEntity get appDriver => DriverEntity(
    host: 'localhost', //IP/HOST do postgres
    database: 'postgres',
    username: 'postgres',
    password: 'suaSenhaProstgres',
    port: 5432,
  );

  static String encryptKey = '212323250d66d2121212132323128007';
  static String jwtKey = '5ab621234231212123243233123058da77';

  static String migration = '''
                CREATE TABLE
                public.df_users (
                  id serial NOT NULL,
                  created_at timestamp without time zone NOT NULL DEFAULT now(),
                  email character varying(255) NOT NULL,
                  pwd character varying(255) NOT NULL,
                  status integer NULL DEFAULT 1,
                  uid text NULL DEFAULT uuid_in (
                    (
                      md5(((random())::text || (clock_timestamp())::text))
                    )::cstring
                  ),
                  name text NULL
                );
              
              ALTER TABLE
                public.df_users
              ADD
                CONSTRAINT df_users_pkey PRIMARY KEY (id);
  ''';

}