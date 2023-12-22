# Requisitos
- Docker
- Docker Compose
- Curl

# MIGRATION

- 1 - Antes de iniciar crie a tabela de authenticação
 ` CREATE TABLE
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
                CONSTRAINT df_users_pkey PRIMARY KEY (id); `

# Preparar o ambiente
- 1 -  Clone esse repositório no servidor


- 2 - De permissão para execução ao script `./lib/build.sh` com o comando `chmod +x`


- 3 - Edite o arquivo `./api/bin/env.dart` com seus dados do postgress as keys de criptografia e jwt.


- 4 - Execute o comando SQL que está dentro de  `./api/bin/env.dart` (variavel migration) para criar a tabela de autorização para funcionamento dos tokens, login, cadastro, etc.


- 5 - Execute o comando `./lib/build.sh` para subir a API conteirnizada no docker

-------
# ACCESS/TOKEN


### CREATE USER
Crie um usuário para ter acesso ao recurso de criação de Token
![image](https://github.com/xbrunots/dart_shelf_api/assets/4499957/8f404056-8420-42bb-ac1d-552071357e61)



### TOKEN
![image](https://github.com/xbrunots/dart_shelf_api/assets/4499957/1ca6a784-1cfc-4ccc-9dda-44b6057fedda)


# CRUD

#### TODAS AS CHAMADAS PRECISAM DO AUTHORIZATION TOKEN NO HEADER!
![img_5.png](img_5.png)

### SELECT 
![img_1.png](img_1.png)


### INSERT
![img_2.png](img_2.png)

### UPDATE
![img_3.png](img_3.png)

### DELETE
![img_4.png](img_4.png)
