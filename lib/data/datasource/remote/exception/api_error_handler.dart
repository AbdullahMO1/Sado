import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/datasource/remote/exception/forbidden_page.dart';
import 'package:flutter_sado_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sado_ecommerce/main.dart';

import '../../../../localization/language_constrants.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    BuildContext? context = Get.context;
    dynamic errorDescription = "";

    if (error is Exception) {
      try {
        if (error is DioError) {
          bool isClientBlocked = false;
          bool isLoginError = false;

          isClientBlocked = true;
          isLoginError = true;
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              // errorDescription =
              //     "Connection to API server failed due to internet connection";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 403:
                  debugPrint(
                      '<==Here is error body==${error.response!.data.toString()}===>');
                  if (error.response!.data['errors'] != null) {
                    errorDescription = error.response!.data['errors'][0];
                  } else {
                    errorDescription = error.response!.data['message'];
                  }
                  break;

                case 404:
                case 500:
                case 503:
                case 429:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else if (error.response!.statusCode == 401) {
                    if (context != null) {
                      Navigator.of(context!).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ForbiddenPage(isGuestMode: true),
                        ),
                      );
                    }
                  } else {
                    errorDescription =
                        "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
          }
        }
        // else {
        //   // errorDescription = "Unexpected error occured";
        // }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
