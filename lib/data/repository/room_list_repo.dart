import 'package:flutter_sado_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sado_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sado_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sado_ecommerce/utill/app_constants.dart';

class RoomListRepo {
  final DioClient? dioClient;
  RoomListRepo({required this.dioClient});

  Future<ApiResponse> getRoomList() async {
    try {
      final response = await dioClient!.get(AppConstants.roomListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
