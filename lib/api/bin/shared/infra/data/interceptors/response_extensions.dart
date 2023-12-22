import 'dart:convert';

import 'package:postgres/messages.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import '../../../../modules/services/query/data/fly_response.dart';
import '../../../data/utils/headers.dart';
import '../../../extensions/json_extensions.dart';
import '../../domain/parse_usecase.dart';
import 'response_error.dart';

extension responseRecordsExt on (
  Result?,
  Exception?,
) {
  Response toResolveResponse(
      {Map<String, /* String | List<String> */ Object>? headers, }) {
    if (this.$1 != null && this.$2 == null) {
      return $1!.toSuccess(cols: []);
    } else {
      return Response.badRequest(
        body: ResponseError.get(message: $2.toString()),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    }
  }
}

extension responseRecordsSelectExt on (
  Result?,
  Exception?, {
  List<Map<String, dynamic>> cols
}) {
  Response toResolveResponse(
      {Map<String, /* String | List<String> */ Object>? headers}) {
    if ($1 != null) {
      return responseParsed(result: $1, exception: null, cols: cols);
    } else {
      return responseParsed(result: $1, exception: $2, cols: cols);
    }
  }
}

Response responseParsed(
    {Map<String, /* String | List<String> */ Object>? headers,
    Result? result,
    Exception? exception,
    required List<Map<String, dynamic>> cols}) {
  if (result != null && exception == null) {
    return result.toSuccess(cols: cols);
  } else {
    return Response.badRequest(
      body: ResponseError.get(message: exception.toString()),
      headers: headers ?? HeadersUtils.headersDefault,
    );
  }
}

extension responseExt on Result {
  String resultToString(List<Map<String, dynamic>> cols) {
    return json.encode({
      'count': length,
      'data': map((e) => e.toSafeResultRow(cols)).toList(),
    });
  }

  List<Map<String, dynamic>> resultToListMap(List<Map<String, dynamic>>? cols) {
    return map((e) => e.toSafeResultRow([])).toList();
  }

  Response toSuccess(
      {Map<String, /* String | List<String> */ Object>? headers,
      required List<Map<String, dynamic>> cols}) {
    try {
      return Response.ok(
        resultToString(cols),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    } catch (e) {
      return Response.badRequest(
        body: ResponseError.get(details: e.toString()),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    }
  }
}

extension mapExtRow on ResultRow {
  Map<String, dynamic> toSafeResultRow(List<Map<String, dynamic>> cols) {
    final map = <String, dynamic>{};
    for (final (i, col) in schema.columns.indexed) {
      if (col.columnName case final String name) {
        map[name] = ParseUseCase.instance.smartValue(name, this[i], cols);
      } else {
        map['[$i]'] = ParseUseCase.instance
            .smartValue(map.keys.elementAt(i), this[i], cols);
      }
    }
    return map;
  }
}

extension mapExtFly on FlyResponse {
  Response toResponseSuccess() {
    return this.toJson().toApiSuccess();
  }

  Response toResponseError(error) {
    return toApiBadRequest(error);
  }

  Response toResponseForbidden(error) {
    return toApiForbidden(error);
  }
}

extension mapExt on Map<String, dynamic> {
  Map<String, dynamic> toSafeMap() {
    final map = <String, dynamic>{};
    for (final (i, col) in this.entries.indexed) {
      map[col.key] = col.value.toString();
    }
    return map;
  }

  Response toSuccess(
      {Map<String, /* String | List<String> */ Object>? headers}) {
    try {
      return Response.ok(
        json.encode({
          'data': this,
        }),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    } catch (e) {
      return Response.badRequest(
        body: ResponseError.get(details: e.toString()),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    }
  }

  Response toApiSuccess(
      {Map<String, /* String | List<String> */ Object>? headers}) {
    try {
      return Response.ok(
        json.encode(
          this,
        ),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    } catch (e) {
      return Response.badRequest(
        body: ResponseError.get(details: e.toString()),
        headers: headers ?? HeadersUtils.headersDefault,
      );
    }
  }
}

Response toApiBadRequest(String error,
    {Map<String, /* String | List<String> */ Object>? headers}) {
  return Response.badRequest(
    body: ResponseError.get(message: error.toString()),
    headers: headers ?? HeadersUtils.headersDefault,
  );
}

Response toApiForbidden(String error,
    {Map<String, /* String | List<String> */ Object>? headers}) {
  return Response.forbidden(
    ResponseError.get(message: error.toString()),
    headers: headers ?? HeadersUtils.headersDefault,
  );
}
