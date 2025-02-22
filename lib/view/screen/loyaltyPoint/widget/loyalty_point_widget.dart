import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/response/loyalty_point_model.dart';
import 'package:flutter_sado_ecommerce/helper/date_converter.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:intl/intl.dart';

class LoyaltyPointWidget extends StatelessWidget {
  final LoyaltyPointList? loyaltyPointModel;
  final int length;
  final int index;
  const LoyaltyPointWidget(
      {Key? key,
      this.loyaltyPointModel,
      required this.length,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;

    String formattedDate = DateFormat.yMMMMd(languageCode)
        .add_jm()
        .format(DateTime.parse(loyaltyPointModel!.createdAt!));

    String type = loyaltyPointModel!.transactionType!;
    String? reformatType;
    if (type.contains('_')) {
      reformatType = type.replaceAll('_', ' ');
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.homePagePadding,
          vertical: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage(loyaltyPointModel!.credit! > 0
                            ? Images.coinDebit
                            : Images.coinCredit),
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: Dimensions.paddingSizeEight,
                      ),
                      Text(
                        loyaltyPointModel!.credit! > 0 ? '+' : '-',
                        style: robotoBold.copyWith(
                            color: ColorResources.getTextTitle(context),
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      Text(
                        '${loyaltyPointModel!.credit! > 0 ? loyaltyPointModel!.credit : loyaltyPointModel!.debit}',
                        style: textRegular.copyWith(
                            color: ColorResources.getTextTitle(context),
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      Text(
                        '${getTranslated('points', context)}',
                        style: textRegular.copyWith(
                            color: ColorResources.getHint(context)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),
                  Text(
                    '$reformatType',
                    style: textRegular.copyWith(
                        color: ColorResources.getHint(context)),
                  ),
                ],
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedDate,
                    style: textRegular.copyWith(
                        color: ColorResources.getHint(context),
                        fontSize: Dimensions.fontSizeDefault),
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),
                  Text(
                    loyaltyPointModel!.credit! > 0
                        ? getTranslated('credit', context)!
                        : getTranslated('debit', context)!,
                    style: textRegular.copyWith(
                        color: loyaltyPointModel!.credit! > 0
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              ),
            ],
          ),
          index + 1 != length
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Divider(
                    thickness: .4,
                    color: Theme.of(context).hintColor.withOpacity(.8),
                  ),
                )
              : const SizedBox(height: 50),
        ],
      ),
    );
  }
}
