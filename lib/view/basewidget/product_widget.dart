import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sado_ecommerce/helper/price_converter.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sado_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/product/widget/favourite_button.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  final double? height;
  const ProductWidget({Key? key, required this.productModel, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ratting =
        productModel.rating != null && productModel.rating!.isNotEmpty
            ? productModel.rating![0].average!
            : "0";

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (context, anim1, anim2) => ProductDetails(
                  productId: productModel.id, slug: productModel.slug),
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).highlightColor,
          boxShadow:
              Provider.of<ThemeProvider>(context, listen: false).darkTheme
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .darkTheme
                      ? Theme.of(context).primaryColor.withOpacity(.05)
                      : ColorResources.getIconBg(context),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                ),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                    child: CustomImage(
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                      height: MediaQuery.of(context).size.width / 2.45,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ))),

            // Product Details
            Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeExtraSmall,
                  bottom: 5,
                  left: 5,
                  right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(productModel.name ?? '',
                      textAlign: TextAlign.center,
                      style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (productModel.currentStock! <
                          productModel.minimumOrderQuantity! &&
                      productModel.productType == 'physical')
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                            getTranslated('out_of_stock', context) ?? '',
                            style: textRegular.copyWith(
                                color: const Color(0xFFF36A6A)))),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(children: [
                    Row(
                      children: List.generate(5, (index) {
                        if (index < double.parse(ratting).floor()) {
                          return const Icon(Icons.star,
                              color: Colors.orange, size: 16);
                        } else if (index < double.parse(ratting)) {
                          return const Icon(Icons.star_half,
                              color: Colors.orange, size: 16);
                        }
                        return const Icon(Icons.star_border,
                            color: Colors.orange, size: 16);
                      }),
                    ),
                    const SizedBox(width: 5),
                    Text('(${productModel.reviewCount.toString()})',
                        style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor)),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(
                    children: [
                      Text(
                          PriceConverter.convertPrice(
                              context, productModel.unitPrice,
                              discountType: productModel.discountType,
                              discount: productModel.discount),
                          style: titilliumSemiBold),
                      ...(productModel.discount != null &&
                              productModel.discount! > 0)
                          ? [
                              const Spacer(),
                              Text(
                                  PriceConverter.convertPrice(
                                      context, productModel.unitPrice),
                                  style: titleRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.fontSizeSmall))
                            ]
                          : [],
                    ],
                  ),
                ],
              ),
            ),
          ]),

          // Favourite Button

          Positioned(
            top: 12,
            left: 12,
            child: FavouriteButton(
              backgroundColor: ColorResources.getImageBg(context),
              productId: productModel.id,
            ),
          ),
        ]),
      ),
    );
  }
}
