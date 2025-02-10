import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/main.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final bool showActionButton;
  final Function()? onBackPressed;
  final bool centerTitle;
  final double? fontSize;
  final bool showResetIcon;
  final Widget? reset;
  final bool showLogo;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.centerTitle = false,
      this.showActionButton = true,
      this.fontSize,
      this.showResetIcon = false,
      this.reset,
      this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
            actions: showResetIcon ? [reset!] : [],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 50,
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.bodyLarge?.color),
            automaticallyImplyLeading: false,
            title: Text(title ?? '',
                style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis),
            centerTitle: true,
            excludeHeaderSemantics: true,
            titleSpacing: 0,
            elevation: 0,
            clipBehavior: Clip.none,
            shadowColor: Colors.transparent,
            leadingWidth: isBackButtonExist ? 50 : 120,
            leading: isBackButtonExist
                ? CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.blue,
                  )
                : showLogo
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault),
                        child: SizedBox(
                            child: Image.asset(Images.logoWithNameImage)))
                    : const SizedBox()));
  }

  @override
  Size get preferredSize => Size(MediaQuery.of(Get.context!).size.width, 50);
}
