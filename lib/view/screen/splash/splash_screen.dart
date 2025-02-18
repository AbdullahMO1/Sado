import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/main.dart';
import 'package:flutter_sado_ecommerce/notification/model/notification_body.dart';
import 'package:flutter_sado_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sado_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sado_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sado_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sado_ecommerce/provider/category_provider.dart';
import 'package:flutter_sado_ecommerce/provider/featured_deal_provider.dart';
import 'package:flutter_sado_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sado_ecommerce/provider/notification_provider.dart';
import 'package:flutter_sado_ecommerce/provider/product_provider.dart';
import 'package:flutter_sado_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sado_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/auth/sign_in_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/maintenance/maintenance_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/onboarding/onboarding_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/order/order_details_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({Key? key, this.body}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<List<ConnectivityResult>> _onConnectivityChanged;

  Future<void> _loadData(bool reload) async {
    await Provider.of<BannerProvider>(Get.context!, listen: false)
        .getBannerList(reload);
    await Provider.of<CategoryProvider>(Get.context!, listen: false)
        .getCategoryList(reload);
    await Provider.of<HomeCategoryProductProvider>(Get.context!, listen: false)
        .getHomeCategoryProductList(reload);
    await Provider.of<TopSellerProvider>(Get.context!, listen: false)
        .getTopSellerList(reload);
    await Provider.of<BrandProvider>(Get.context!, listen: false)
        .getBrandList(reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getLatestProductList(1, reload: reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getFeaturedProductList('1', reload: reload);
    await Provider.of<FeaturedDealProvider>(Get.context!, listen: false)
        .getFeaturedDealList(reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getLProductList('1', reload: reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getRecommendedProduct();
    await Provider.of<CartProvider>(Get.context!, listen: false)
        .getCartDataAPI(Get.context!);
    await Provider.of<NotificationProvider>(Get.context!, listen: false)
        .getNotificationList(1);
    if (Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(Get.context!, listen: false)
          .getUserInfo(Get.context!);
      await Provider.of<WishListProvider>(Get.context!, listen: false)
          .getWishList();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(false);

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)!
                : getTranslated('connected', context)!,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initSharedPrefData();
        Timer(const Duration(seconds: 1), () {
          if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .maintenanceMode!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const MaintenanceScreen()));
          } else if (Provider.of<AuthProvider>(context, listen: false)
              .isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false)
                .updateToken(context);
            if (widget.body != null) {
              if (widget.body!.type == 'order') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OrderDetailsScreen(orderId: widget.body!.orderId)));
              } else if (widget.body!.type == 'notification') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NotificationScreen()));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const InboxScreen(
                          isBackButtonExist: true,
                        )));
              }
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            }
          } else if (Provider.of<SplashProvider>(context, listen: false)
              .showIntro()!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => OnBoardingScreen(
                    indicatorColor: ColorResources.grey,
                    selectedIndicatorColor: Theme.of(context).primaryColor)));
          } else {
            if (Provider.of<AuthProvider>(context, listen: false)
                        .getGuestToken() !=
                    null &&
                Provider.of<AuthProvider>(context, listen: false)
                        .getGuestToken() !=
                    '1') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const SignInScreen()));
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).highlightColor,
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Center(
              child: SizedBox(
                  width: 180, height: 180, child: Image.asset(Images.logo)),
            )
          : const NoInternetOrDataScreen(
              isNoInternet: true, child: SplashScreen()),
    );
  }
}
