import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sado_ecommerce/data/repository/room_list_repo.dart';
import 'package:flutter_sado_ecommerce/data/model/response/room_model.dart';
import 'package:flutter_sado_ecommerce/helper/api_checker.dart';
import 'dart:convert';

class RoomListProvider extends ChangeNotifier {
  final RoomListRepo? roomListRepo;

  RoomListProvider({required this.roomListRepo});

  int? roomItem;
  List<Room>? _roomProductList;
  List<Room>? get roomProductList => _roomProductList;
  int? get roomSelectedIndex => roomItem;

  Future<void> getRoomList(bool reload) async {
    _roomProductList = [];
    ApiResponse apiResponse = await roomListRepo!.getRoomList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data.toString() != '{}') {
      _roomProductList = [];

      apiResponse.response!.data["products"]
          .forEach((fDeal) => _roomProductList?.add(Room.fromJson(fDeal)));
      roomItem = 0;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex) {
    roomItem = selectedIndex;
    notifyListeners();
  }
}
