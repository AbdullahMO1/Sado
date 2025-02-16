import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/response/product_details_model.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sado_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sado_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/room_individual_design_screen.dart';
import 'package:provider/provider.dart';

class BottomCartView extends StatefulWidget {
  final ProductDetailsModel? product;
  const BottomCartView({Key? key, required this.product}) : super(key: key);

  @override
  State<BottomCartView> createState() => _BottomCartViewState();
}

class _BottomCartViewState extends State<BottomCartView> {
  bool vacationIsOn = false;
  bool temporaryClose = false;

  @override
  void initState() {
    super.initState();
    print("-----here-------");
    print(widget.product!.roomId);
    if (widget.product != null &&
        widget.product!.seller != null &&
        widget.product!.seller!.shop!.vacationEndDate != null) {
      DateTime vacationDate =
          DateTime.parse(widget.product!.seller!.shop!.vacationEndDate!);
      DateTime vacationStartDate =
          DateTime.parse(widget.product!.seller!.shop!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if (difference >= 0 &&
          widget.product!.seller!.shop!.vacationStatus == 1 &&
          startDate <= 0) {
        vacationIsOn = true;
      } else {
        vacationIsOn = false;
      }
    }

    if (widget.product != null &&
        widget.product!.seller != null &&
        widget.product!.seller!.shop!.temporaryClose == 1) {
      temporaryClose = true;
    } else {
      temporaryClose = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF6FBFF),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          width: 55,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Stack(children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CartScreen()));
                  },
                  child: Image.asset(Images.cartArrowDownImage,
                      height: 30,
                      width: 30,
                      color: ColorResources.getPrimary(context))),
              Positioned(
                top: 0,
                right: 10,
                child: Consumer<CartProvider>(builder: (context, cart, child) {
                  return Container(
                    height: 17,
                    width: 17,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorResources.getPrimary(context),
                    ),
                    child: Text(
                      cart.cartList.length.toString(),
                      style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).highlightColor),
                    ),
                  );
                }),
              )
            ]),
          ),
        ),
        Expanded(
            flex: 11,
            child: InkWell(
              onTap: () {
                if (vacationIsOn || temporaryClose) {
                  showCustomSnackBar(
                      getTranslated('this_shop_is_close_now', context), context,
                      isToaster: true);
                } else {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0),
                      builder: (con) => CartBottomSheet(
                            product: widget.product,
                            callback: () {
                              showCustomSnackBar(
                                  getTranslated('added_to_cart', context),
                                  context,
                                  isError: false);
                            },
                          ));
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  getTranslated('add_to_cart', context)!,
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .darkTheme
                          ? Theme.of(context).hintColor
                          : Theme.of(context).highlightColor),
                ),
              ),
            )),
        widget.product!.roomId != 'null' && widget.product!.roomId != null
            ? Expanded(
                flex: 11,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (context, anim1, anim2) =>
                              RoomIndividualDesignScreen(
                                  roomId: widget.product!.roomId.toString()),
                        ));
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      getTranslated('view_3d_room', context)!,
                      style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .darkTheme
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).highlightColor),
                    ),
                  ),
                ))
            : SizedBox(),
      ]),
    );
  }
}
