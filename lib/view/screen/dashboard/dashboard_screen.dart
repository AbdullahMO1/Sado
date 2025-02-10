import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/helper/network_info.dart';
import 'package:flutter_sado_ecommerce/provider/category_provider.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_exit_card.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/screen/category/all_category_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/home/aster_theme_home_page.dart';
import 'package:flutter_sado_ecommerce/view/screen/home/fashion_theme_home_page.dart';
import 'package:flutter_sado_ecommerce/view/screen/home/home_screens.dart';
import 'package:flutter_sado_ecommerce/view/screen/home/widget/category_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/more/more_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/room_screens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;

  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";

    _screens = [
      NavigationModel(
          name: 'home_ad',
          icon: Images.homeImage1,
          screen: (Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .activeTheme ==
                  "default")
              ? const HomePage()
              : (Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .activeTheme ==
                      "theme_aster")
                  ? const AsterThemeHomePage()
                  : const FashionThemeHomePage()),
      NavigationModel(
          name: 'CATEGORY',
          icon: Images.shoppingImage,
          screen: const AllCategoryScreen()),
      if (!singleVendor)
        NavigationModel(
            name: '3d_designs',
            icon: Images.messageImage1,
            screen: const RoomPage(isBacButtonExist: false)),
      NavigationModel(
          name: 'more', icon: Images.moreImage, screen: const MoreScreen()),
    ];

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => const CustomExitCard());
        }
        return false;
      },
      child: Material(
        type: MaterialType.transparency, // الحفاظ على الشفافية
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent, // الخلفية الشفافة
              body: PageStorage(
                  bucket: bucket, child: _screens[_pageIndex].screen),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 35,
                    left: 18,
                    right: 18), // تعديل الحشو ليتناسب مع الأيقونة المركزية
                child: Container(
                  height: 70, // استخدام ارتفاع كافٍ لتجنب التجاوز
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _getBottomWidget(singleVendor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for (int index = 0; index < _screens.length; index++) {
      list.add(Expanded(
          child: CustomMenuItem(
        isSelected: _pageIndex == index,
        name: _screens[index].name,
        icon: _screens[index].icon,
        onTap: () => _setPage(index),
      )));
    }
    return list;
  }
}

class CustomMenuItem extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String icon;
  final VoidCallback onTap;

  const CustomMenuItem({
    Key? key,
    required this.isSelected,
    required this.name,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5), // تقليل المسافات
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).hintColor,
              width: 24, // حجم الأيقونة
              height: 24,
            ),
            const SizedBox(height: 4), // تقليل المسافة بين الأيقونة والنص
            Text(
              getTranslated(name, context)!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textRegular.copyWith(
                fontSize: 12, // حجم الخط
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationModel {
  String name;
  String icon;
  Widget screen;
  NavigationModel({
    required this.name,
    required this.icon,
    required this.screen,
  });
}
