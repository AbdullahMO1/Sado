import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/response/category.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/category_provider.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sado_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

class AllCategoryScreen extends StatelessWidget {
  const AllCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('CATEGORY', context),
        isBackButtonExist: false,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.categoryList.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisExtent: 150,
                  ),
                  itemCount: categoryProvider.categoryList.length,
                  itemBuilder: (context, index) {
                    Category category = categoryProvider.categoryList[index];
                    return InkWell(
                      onTap: () {
                        Provider.of<CategoryProvider>(context, listen: false)
                            .changeSelectedIndex(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrandAndCategoryProductScreen(
                              isBrand: false,
                              id: category.id.toString(),
                              name: category.name,
                            ),
                          ),
                        );
                      },
                      child: CategoryItem(
                        title: category.name,
                        icon: category.icon,
                        isSelected:
                            categoryProvider.categorySelectedIndex == index,
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder,
            height: 105,
            width: 105,
            fit: BoxFit.cover,
            image:
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/$icon',
            imageErrorBuilder: (c, o, s) =>
                Image.asset(Images.placeholder, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeExtraSmall),
          child: Text(
            title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ),
      ],
    );
  }
}
