import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LANGUAGE = 'langauge';

class DioFactory {
  final AppPrefrences _appPrefrences;

  DioFactory(this._appPrefrences);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    String language = await _appPrefrences.getAppLanguage();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constants.token,
      DEFAULT_LANGUAGE: language
    };
    dio.options = BaseOptions(
        baseUrl: Constants.baseUrl,
        sendTimeout: const Duration(
            milliseconds: Constants.API_TIME_OUT), // Convert to Duration
        receiveTimeout: const Duration(
            milliseconds: Constants.API_TIME_OUT), // Convert to Duration
        headers: headers);

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true));
    }

    return dio;
  }
}
