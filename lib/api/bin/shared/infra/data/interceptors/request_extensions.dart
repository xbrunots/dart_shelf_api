import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../../extensions/json_extensions.dart';
import '../../../logs/logger.dart';

extension requestExt on Request {
  Future<Map<String, dynamic>> toMap() async {
    try {
      Map<String, dynamic> req = json.decode(await this.readAsString());
      return req;
    } catch (e) {
      AppLogger.instance.info(e.toString(), tag: 'Error ${this.url.path}');
      return {};
    }
  }
}
