import 'dart:convert';

class ParseUseCase {
  ParseUseCase._();

  static final instance = ParseUseCase._();

  String resolver(dynamic headerParam, String? clause) {
    String result = '';
    try {
      if ( headerParam != null && clause != null) {
        // String suffix = '';
        // if(headerParam.contains(ResolverQueryStrings.separator)){
        //   suffix = headerParam.splitMapJoin(ResolverQueryStrings.separator)[1] ?? '';
        // }

        String entity = headerParam.toString();

        if (entity.contains("'")) {
          result = ' $clause  ${entity} ';
        } else {
          result = ' $clause ${entity.replaceAll('"', "'")} ';
        }
        return result;
      } else {
        return result;
      }
    } catch (e) {
      return result;
    }
  }

  String removeDigits(final String s) {
    return s.replaceAll(new RegExp(r"[0-9]+"), "");
  }

  valueByType(dynamic value, String dataType) {
    try {
      if (((removeDigits(dataType.toLowerCase()).contains('bigint')) ||
              (removeDigits(dataType.toLowerCase()).contains('bit')) ||
              (removeDigits(dataType.toLowerCase()).contains('integer')) ||
              (removeDigits(dataType.toLowerCase()).contains('int')) ||
              (removeDigits(dataType.toLowerCase()).contains('serial')) ||
              (removeDigits(dataType.toLowerCase()).contains('smallint'))) &&
          (!removeDigits(dataType.toLowerCase()).contains('interval'))) {
        return num.parse(value.toString());
      }

      if (((removeDigits(dataType.toLowerCase()).contains('real')) ||
              (removeDigits(dataType.toLowerCase()).contains('decimal')) ||
              (removeDigits(dataType.toLowerCase()).contains('numeric')) ||
              (removeDigits(dataType.toLowerCase()).contains('float')) ||
              (removeDigits(dataType.toLowerCase()).contains('double')) ||
          (removeDigits(dataType.toLowerCase()).contains('money')))) {
        //
        //
        return double.parse(value.toString());
        //
        //
      }

      if (((removeDigits(dataType.toLowerCase()).contains('json')) ||
          (removeDigits(dataType.toLowerCase()).contains('jsonp')))) {
        //
        //
        return value;
        //
        //
      }

      if (removeDigits(dataType.toLowerCase()).contains('bool')) {
        //
        //
        return bool.parse(value.toString());
        //
        //
      }

      return value.toString();
    } catch (e) {
      return value.toString();
    }
  }

  dynamic smartValue(
      String key, dynamic value, List<Map<String, dynamic>>? cols) {
    try {
      if (cols == null) return value.toString();

      final dataType =
          cols.firstWhere((e) => e['column_name'] == key)['data_type'];

      return valueByType(value, dataType);
    } catch (e) {
      return value.toString();
    }
  }
}
