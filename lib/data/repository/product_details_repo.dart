import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_sado_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sado_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sado_ecommerce/data/model/body/review_body.dart';
import 'package:flutter_sado_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sado_ecommerce/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProductDetailsRepo {
  final DioClient? dioClient;
  ProductDetailsRepo({required this.dioClient});

  Future<ApiResponse> getProduct(String productID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.productDetailsUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getReviews(String productID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.productReviewUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCount(String productID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.counterUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSharableLink(String productID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.socialLinkUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> submitReview(
      ReviewBody reviewBody, List<File> files, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.submitReviewUri}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    for (int index = 0; index < files.length; index++) {
      if (files[index].path.isNotEmpty) {
        request.files.add(http.MultipartFile(
          'fileUpload[$index]',
          files[index].readAsBytes().asStream(),
          files[index].lengthSync(),
          filename: files[index].path.split('/').last,
        ));
      }
    }
    request.fields.addAll(<String, String>{
      'product_id': reviewBody.productId!,
      'comment': reviewBody.comment!,
      'rating': reviewBody.rating!
    });
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponse> getComments(String productID, {String? token}) async {
    try {
      // إعداد headers فقط إذا كان التوكن متاحًا
      Map<String, String> headers = {};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // إرسال طلب GET لجلب التعليقات
      final response = await dioClient!.get(
        AppConstants.getCommentsUri + productID,
        options: Options(headers: headers),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addComment(String productId, String comment) async {
    try {
      final response = await dioClient!.post(
        AppConstants.addCommentUri,
        data: {
          'product_id': productId,
          'comment': comment,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // دالة لإضافة رد
  Future<ApiResponse> addReply(String commentId, String reply) async {
    try {
      final response = await dioClient!.post(
        AppConstants.addReplyUri,
        data: {"comment_id": commentId, "comment": reply},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // دالة للإعجاب بتعليق
  Future<ApiResponse> likeComment(String commentId) async {
    try {
      final response = await dioClient!.post(
        AppConstants.likeCommentUri,
        data: {"comment_id": commentId},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // دالة لحذف تعليق
  Future<ApiResponse> deleteComment(String commentId) async {
    try {
      final response = await dioClient!.delete(
        AppConstants.deleteCommentUri + commentId,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // دالة لحذف رد
  Future<ApiResponse> deleteReply(String replyId) async {
    try {
      final response = await dioClient!.delete(
        AppConstants.deleteReplyUri + replyId,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
