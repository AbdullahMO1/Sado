import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/view/screen/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../view/basewidget/custom_button.dart';

class ForbiddenPage extends StatelessWidget {
  final bool isGuestMode; // تم تمرير الحالة إلى الصفحة
  const ForbiddenPage({Key? key, required this.isGuestMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 40, top: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimensions.paddingSizeDefault))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.block,
                      color: Theme.of(context).primaryColor, size: 100),
                  Text(getTranslated('access_forbidden', context)!,
                      style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault),
                    child: SizedBox(
                        width: 60, child: Image.asset(Images.exitIcon)),
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),
                  // Text(
                  //   getTranslated('sign_out', context)!,
                  //   style:
                  //       textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeLarge),
                    child: Text(
                        '${getTranslated('blocked_to_sign_out', context)}'),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeOverLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                              width: 120,
                              child: CustomButton(
                                  buttonText:
                                      '${getTranslated('sign_out', context)}',
                                  onTap: () {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .logOut()
                                        .then((condition) {
                                      Navigator.pop(context);
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .clearSharedData();
                                      Provider.of<ProfileProvider>(context,
                                              listen: false)
                                          .initAddressList();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignInScreen()),
                                          (route) => false);
                                    });
                                  })),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
