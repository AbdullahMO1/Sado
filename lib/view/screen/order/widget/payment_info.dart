import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/order_provider.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/view/screen/checkout/widget/shipping_details_widget.dart';

class PaymentInfo extends StatelessWidget {
  final OrderProvider? order;
  const PaymentInfo({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getTranslatedPaymentStatus(String paymentStatus) {
      if (paymentStatus == 'unpaid') {
        return getTranslated('unpaid_payment', context)!;
      } else if (paymentStatus == 'paid') {
        return getTranslated('paid_payment', context)!;
      } else {
        return getTranslated('digital_payment', context)!;
      }
    }

    String _translatePaymentStatus(String paymentStatus) {
      switch (paymentStatus) {
        case 'in_process':
          return getTranslated('in_process_payment', context)!;
        case 'completed':
          return getTranslated('completed_payment', context)!;
        default:
          return getTranslated('unexpected_payment', context)!;
      }
    }

    String getPaymentStatusText(String? paymentStatus) {
      if (paymentStatus != null && paymentStatus.isNotEmpty) {
        return getTranslatedPaymentStatus(paymentStatus);
      } else {
        return getTranslated('digital_payment', context)!;
      }
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('PAYMENT_STATUS', context)!,
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall)),
            Text(
              (order!.orders!.paymentStatus != null &&
                      order!.orders!.paymentStatus!.isNotEmpty)
                  ? getTranslatedPaymentStatus(
                      order!.orders!.paymentStatus!) // ترجمة القيمة
                  : getTranslated('digital_payment', context)!,
              style:
                  titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          ]),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('PAYMENT_PLATFORM', context)!,
              style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall)),
          Text(order!.orders!.paymentMethod!.replaceAll('_', ' ').capitalize(),
              style: titilliumBold.copyWith(
                  color: Theme.of(context).primaryColor)),
        ]),
      ]),
    );
  }
}
