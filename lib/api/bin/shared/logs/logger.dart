import 'dart:developer';

class AppLogger {
  AppLogger._();

  static final instance = AppLogger._();

  info(String message, {String? tag}) {
    log("=======LOGGER=======");
    log('${tag != null ? '[' + tag + '] ' : ''}$message');
  }

  print(String message) {
    log(message);
  }
}
