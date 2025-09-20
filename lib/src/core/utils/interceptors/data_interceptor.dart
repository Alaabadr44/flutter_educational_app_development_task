// Package imports:
import 'package:dio/dio.dart';

import '../app_logger.dart';
import '../constant.dart';

class DataInterceptor extends Interceptor {
  DataInterceptor();

  bool isBackEndDidHandelResSchema = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(apiHeader);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final Map<String, dynamic>? res = _asMap(response.data);
    if (res == null) {
      handler.next(response);
      return;
    }

    if (_isUnauthorized(response.statusCode)) {
      _normalizeUnauthorizedResponse(response, res);
    } else if (_isSuccess(response.statusCode)) {
      _normalizeSuccessResponse(response, res);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logDebug("onError status code: ${err.response?.statusCode}");

    // Normalize unauthorized errors
    _normalizeUnauthorizedError(err);
    handler.next(err);
  }

  // Helpers
  bool _isSuccess(int? code) => code == 200 || code == 201;
  bool _isUnauthorized(int? code) => code == 401;

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return null;
  }

  void _normalizeUnauthorizedResponse(
    Response response,
    Map<String, dynamic> res,
  ) {
    res.addAll({
      "data": null,
      "message": res['message'],
      "code": response.statusCode,
    });
    response.data = res;
  }

  void _normalizeSuccessResponse(Response response, Map<String, dynamic> res) {
    if (!res.containsKey("data")) {
      final Map<String, dynamic> data = <String, dynamic>{};
      for (final entry in res.entries) {
        if (entry.key != "data" &&
            entry.key != "message" &&
            entry.key != "code") {
          data[entry.key] = entry.value;
        }
      }
      res.addAll({
        "data": data,
        "message": "success",
        "code": 200,
        "status": "success",
      });
      response.data = res;
      return;
    }

    final dynamic data = res["data"];
    if (data is Map && data.isNotEmpty) {
      // Only transform if there's exactly one key and its value is a List
      if (data.length == 1) {
        final dynamic firstValue = data.entries.first.value;
        if (firstValue is List) {
          response.data.addAll({
            "data": firstValue,
            "message": "success",
            "code": 200,
            if ((data).containsKey("pagination")) ...{
              "meta": data["pagination"],
            },
          });
        }
      }
    }
  }

  void _normalizeUnauthorizedError(DioException err) {
    if (!_isUnauthorized(err.response?.statusCode) ||
        isBackEndDidHandelResSchema)
      return;
    final Map<String, dynamic>? res = _asMap(err.response?.data);
    if (res == null) return;

    err.response?.statusCode = 422;
    res.addAll({"data": null, "message": res['message'], "code": 422});
    err.response?.data = res;
  }
}
