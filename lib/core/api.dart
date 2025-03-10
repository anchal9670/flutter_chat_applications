import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/utils/config.dart';
import 'package:chat_app/utils/string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'core.dart';

final apiProvider = StateProvider((ref) {
  return API(authToken: null);
});

class API {
  final String? _authToken;

  API({required String? authToken}) : _authToken = authToken;

  FutureEither<Response> getRequest({
    required String url,
    bool requireAuth = false,
    Map<String, String>? queryParams,
  }) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Cookie": "token=$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return Left(Failure(message: FailureMessage.authTokenEmpty));
      }
    }
    if (AppConfig.logHttp) {
      log('REQUEST TO : $url', name: LogLabel.httpGet);
      log('requireAuth : $requireAuth', name: LogLabel.httpGet);
      if (queryParams != null) {
        log('Query Parameters: $queryParams', name: LogLabel.httpGet);
      }
    }
    try {
      final response = await get(
          Uri.parse(url).replace(queryParameters: queryParams),
          headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: LogLabel.httpGet);
      return Right(response);
    } catch (e, stktrc) {
      return Left(
        Failure(message: FailureMessage.getRequestMessage, stackTrace: stktrc),
      );
    }
  }

  FutureEither<Response> postRequest(
      {required String url, dynamic body, bool requireAuth = false}) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Cookie": "token=$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return Left(Failure(message: FailureMessage.authTokenEmpty));
      }
    }
    if (AppConfig.logHttp) {
      log('REQUEST TO : $url', name: LogLabel.httpPost);
      log('requireAuth : $requireAuth', name: LogLabel.httpPost);
      log('BODY : $body', name: LogLabel.httpPost);
    }
    try {
      final response = await post(Uri.parse(url),
          body: jsonEncode(body), headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: LogLabel.httpPost);
      return Right(response);
    } catch (e, stktrc) {
      return Left(Failure(
          message: FailureMessage.postRequestMessage, stackTrace: stktrc));
    }
  }

  FutureEither<Response> putRequest(
      {required String url, dynamic body, bool requireAuth = false}) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Cookie": "token=$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return Left(Failure(message: FailureMessage.authTokenEmpty));
      }
    }
    if (AppConfig.logHttp) {
      log('REQUEST TO : $url', name: LogLabel.httpPut);
      log(
        'requireAuth : $requireAuth',
        name: LogLabel.httpPut,
      );
      log('BODY : $body', name: LogLabel.httpPut);
      log('Token : $_authToken', name: "TOKEN");
    }
    try {
      final response = await put(Uri.parse(url),
          body: jsonEncode(body), headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: LogLabel.httpPut);
      return Right(response);
    } catch (e, stktrc) {
      return Left(Failure(
          message: FailureMessage.putRequestMessage, stackTrace: stktrc));
    }
  }

  FutureEither<Response> patchRequest(
      {required String url, dynamic body, bool requireAuth = false}) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Cookie": "token=$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return Left(Failure(message: FailureMessage.authTokenEmpty));
      }
    }
    if (AppConfig.logHttp) {
      log('REQUEST TO : $url', name: LogLabel.httpPatch);
      log(
        'requireAuth : $requireAuth',
        name: LogLabel.httpPatch,
      );
      log('BODY : $body', name: LogLabel.httpPatch);
      log('Token : $_authToken', name: "TOKEN");
    }
    try {
      final response = await patch(Uri.parse(url),
          body: jsonEncode(body), headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: LogLabel.httpPatch);
      return Right(response);
    } catch (e, stktrc) {
      return Left(Failure(
          message: FailureMessage.putRequestMessage, stackTrace: stktrc));
    }
  }

  FutureEither<Response> deleteRequest(
      {required String url, dynamic body, bool requireAuth = false}) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Cookie": "token=$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return Left(Failure(message: FailureMessage.authTokenEmpty));
      }
    }
    if (AppConfig.logHttp) {
      log('REQUEST TO : $url', name: LogLabel.httpDelete);
      log('requireAuth : $requireAuth', name: LogLabel.httpDelete);
      log('BODY : $body', name: LogLabel.httpDelete);
    }
    try {
      final response = await delete(Uri.parse(url),
          body: jsonEncode(body), headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: LogLabel.httpDelete);
      return Right(response);
    } catch (e, stktrc) {
      return Left(Failure(
          message: FailureMessage.deleteRequestMessage, stackTrace: stktrc));
    }
  }
}
