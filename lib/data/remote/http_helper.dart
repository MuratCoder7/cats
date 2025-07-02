import 'package:http_interceptor/http_interceptor.dart';

import '../../core/constants/api_key.dart';
import '../../core/services/log_service.dart';

class MyInterceptor implements InterceptorContract {
  // We need to intercept request
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers['x-api-key'] = API_KEY;
      data.headers['Content-Type'] = 'application/json';
      LogService.i("$data");
    } catch (e) {
      LogService.e("$e");
    }
    return data;
  }

  // Currently we do not have any need to intercept response
  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 200 || data.statusCode == 201) {
      LogService.i("$data");
    } else {
      LogService.e("$data");
    }
    return data;
  }
}

class MyRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      return true;
    }
    return false;
  }
}

class MyException implements Exception {
  final String? _message;
  final String? _prefix;

  MyException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends MyException {
  FetchDataException([String? message])
      : super(message, "Error During Communication");
}

class BadRequestException extends MyException {
  BadRequestException([String? message]) : super(message, "Invalid Request");
}

class UnauthorisedException extends MyException {
  UnauthorisedException([String? message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends MyException {
  InvalidInputException([String? message]) : super(message, "Invalid Input");
}
