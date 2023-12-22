import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../shared/infra/security/encrypt/encrypt.dart';

main(){
 // String? criptografado = AppEncrypt.instance.encrypt('Ana010118');
 //
 // String? decriptografado = AppEncrypt.instance.decrypt('7ab7e9fdb77e9985ad274e57104d690d' );

 // print('\n');
 // print('Cripto:');
 // print(criptografado);
 // print('------');
 // print('Decripto:');
 // print(decriptografado);

 var bytes = utf8.encode("foo1bar");
 var digest = sha1.convert(bytes);

 print("digest.bytes: ${digest.bytes}");

 print("digest: $digest");

 //8843d7f92416211de9ebb963ff4ce28125932878


}