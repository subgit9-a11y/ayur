import 'package:doctro/constant/common_function.dart';
import 'package:dio/dio.dart' hide Headers;

class ServerError implements Exception {
  int? _errorCode;
  String _errorMessage = "";

  ServerError.withError({error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(dynamic error) {
    if (error is! DioException) {
      _errorMessage = error.toString();
      return CommonFunction.toastMessage("An unexpected error occurred.");
    }

    var data = error.response?.data;
    if (data is! Map) {
      return CommonFunction.toastMessage(
          "Server returned an invalid response.");
    }

    if (error.response?.statusCode == 401) {
      String msg = data['msg']?.toString() ??
          data['message']?.toString() ??
          "Unauthorized";
      if (msg.toLowerCase().contains("unauthorized")) {
        msg = "Session expired. Please log in again.";
      }
      return CommonFunction.toastMessage(msg);
    } else if (data['error'] != null) {
      return CommonFunction.toastMessage('${data['error']}');
    } else if (error.type == DioExceptionType.badResponse) {
      if (data['errors']?['email'] != null) {
        return CommonFunction.toastMessage(data['errors']['email'][0]);
      } else if (data['errors']?['password'] != null) {
        return CommonFunction.toastMessage(data['errors']['password'][0]);
      } else if (data['msg'] != null) {
        return CommonFunction.toastMessage('${data['msg']}');
      } else if (data['message'] != null) {
        return CommonFunction.toastMessage('${data['message']}');
      }
    } else if (error.type == DioExceptionType.unknown) {
      return CommonFunction.toastMessage('${data['msg'] ?? "Unknown error"}');
    } else if (error.type == DioExceptionType.cancel) {
      return CommonFunction.toastMessage('Request was cancelled');
    } else if (error.type == DioExceptionType.connectionError) {
      return CommonFunction.toastMessage(
          'Connection failed. Please check internet connection');
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return CommonFunction.toastMessage('Connection timeout');
    } else if (error.type == DioExceptionType.badCertificate) {
      return CommonFunction.toastMessage('${data['msg'] ?? "Bad Certificate"}');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return CommonFunction.toastMessage('Receive timeout in connection');
    } else if (error.type == DioExceptionType.sendTimeout) {
      return CommonFunction.toastMessage('Receive timeout in send request');
    } else if (data['errors'] != null) {
      // General fallback for any other validation errors
      var firstError = data['errors'].values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return CommonFunction.toastMessage(firstError[0]);
      }
    }
    return _errorMessage;
  }
}
