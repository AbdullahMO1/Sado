import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sado_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/main.dart';
import 'package:flutter_sado_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sado_ecommerce/view/screen/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse) {
    if (apiResponse.response?.statusCode == 401) {
      Provider.of<AuthProvider>(Get.context!, listen: false).clearSharedData();
      Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false);
    } else if (apiResponse.response?.statusCode == 500) {
      showCustomSnackBar(
          getTranslated('internal_server_error', Get.context!), Get.context!);
    } else {
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      showCustomSnackBar(errorMessage, Get.context!);
    }
  }
}
