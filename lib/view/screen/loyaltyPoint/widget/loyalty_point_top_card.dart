import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/screen/loyaltyPoint/widget/how_to_use_dialog.dart';
import 'package:provider/provider.dart';

class LoyaltyPointTopCard extends StatelessWidget {
  const LoyaltyPointTopCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profile, _) {
      return Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // تحديد توزيع العناصر في الاتجاه الرئيسي

            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  top: 40,
                ),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.back,
                      color: ColorResources.hintTextColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 35),
                child: IconButton(
                  icon: const Icon(Icons.info_outline,
                      color: ColorResources.white),
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => const HowToUseDialog());
                  },
                ),
              ),
            ],
          ),
          Positioned(
              top: 30,
              left: MediaQuery.of(context).size.width / 2 - 132 / 2,
              child: Image.asset(Images.loyaltyPointBgIcon,
                  height: 132, opacity: const AlwaysStoppedAnimation(0.3))),
          Positioned(
            bottom: 15,
            right: 0,
            left: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge),
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeSmall),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.loyaltyPointIcon,
                          height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                          '${(profile.userInfoModel != null && profile.userInfoModel!.loyaltyPoint != null) ? profile.userInfoModel!.loyaltyPoint?.toStringAsFixed(0) ?? 0 : 0}',
                          style: robotoBold.copyWith(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeOverLarge)),
                      const SizedBox(
                          height: Dimensions.paddingSizeExtraExtraSmall),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text('${getTranslated('your_points', context)}',
                      style: textRegular.copyWith(color: ColorResources.white)),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
