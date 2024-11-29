import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:ent_insight_app/widgets/widgets.g.dart';
import 'package:flutter/foundation.dart';

import '../configs/config.dart';

class CustomHttp with DioMixin implements Dio {
  static final Dio _dio = Dio();
  static DioCacheManager? _manager;

  CustomHttp() {
    init();
  }

  static init() async {
    // var token = await UserService.getUserToken();
    // await setInterceptor(token);
  }

  static setInterceptor(String? token) async {
    _dio.options = BaseOptions(
      baseUrl: GlobalData.baseUrl,
      contentType: 'application/json',
      //connectTimeout: 30000,
      //sendTimeout: 30000,
      //receiveTimeout: 30000,
    );
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        final headers = {
          'Content-Type': 'application/json; charset=utf-8',
          'accept': 'application/json;',
        };

        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        request.headers = headers;
        //options.validateStatus = (status) => status < 500;
        return handler.next(request);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        if (e.response?.data is Stream<List<int>>) {
          await for (var item in e.response?.data) {
            // Consume the stream to avoid memory leaks.
          }
        }
        if (e.response == null) {
          if (kDebugMode) {
            print("++===========================CUSTOM HTTP DIO: ON ERROR: ${e.message}");
          }
          //AppToastWidget("Please check your network connection");
          //throw Exception("Network Request Failed");
          handler.resolve(Response(requestOptions: e.requestOptions, statusCode: 503, statusMessage: "The request can't reach to the http server"));
          return;
        }

        handler.resolve(e.response!);
      },
    ));

    _dio.interceptors.add(getCacheManager().interceptor);

    // if (kDebugMode) {
    //   debugPrint("==================================== LogInterceptor Start ====================================");
    //   _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    // }
  }

  static Dio getDio() {
    return _dio;
  }

  static DioCacheManager getCacheManager() {
    _manager ??= DioCacheManager(CacheConfig(baseUrl: GlobalData.baseUrl));
    return _manager!;
  }

  static void showTimeoutDioErrors(DioError exception) {
    if (exception.type == DioErrorType.connectTimeout) {
      AppToastWidget("Connection timed out...");
    }
    if (exception.type == DioErrorType.receiveTimeout) {
      AppToastWidget("Receive timed out...");
    }
    if (CancelToken.isCancel(exception)) {
      AppToastWidget('Request canceled: ${exception.message}');
    }
  }

  static Future<void> clearCache() async {
    await getCacheManager().clearAll();
  }

  static Future<void> clearCacheByPath(String path) async {
    await getCacheManager().deleteByPrimaryKeyAndSubKey(path, requestMethod: "GET");
  }
}
