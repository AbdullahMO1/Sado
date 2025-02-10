import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SearchWidgetHomePage extends StatelessWidget {
  const SearchWidgetHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.homePagePadding,
      ),
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        height: 45,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Color(0XFFFAFDFF),
          boxShadow: Provider.of<ThemeProvider>(context).darkTheme
              ? null
              : [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0))
                ],
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(getTranslated('search_hint', context) ?? '',
                style:
                    textRegular.copyWith(color: Theme.of(context).hintColor)),
          ),
          Container(
            width: 70,
            height: 47,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(Dimensions.paddingSizeSmall),
                    bottomEnd: Radius.circular(Dimensions.paddingSizeSmall))),
            child: Icon(Icons.search,
                color:
                    Provider.of<ThemeProvider>(context, listen: false).darkTheme
                        ? Colors.white
                        : Theme.of(context).cardColor,
                size: Dimensions.iconSizeSmall),
          ),
        ]),
      ),
    );
  }
}
