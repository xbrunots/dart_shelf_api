import '../shared/infra/security/encrypt/encrypt.dart';

main(){
 String? criptografado = AppEncrypt.instance.encrypt('BRUNO BRITO');

 String? decriptografado = AppEncrypt.instance.decrypt(criptografado ?? '');

 print('\n');
 print('Cripto:');
 print(criptografado);
 print('------');
 print('Decripto:');
 print(decriptografado);
}