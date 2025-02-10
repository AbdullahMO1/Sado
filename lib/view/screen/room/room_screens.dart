import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/main.dart';
import 'package:flutter_sado_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sado_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sado_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sado_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sado_ecommerce/provider/category_provider.dart';
import 'package:flutter_sado_ecommerce/provider/featured_deal_provider.dart';
import 'package:flutter_sado_ecommerce/provider/room_list_provider.dart';
import 'package:flutter_sado_ecommerce/provider/flash_deal_provider.dart';
import 'package:flutter_sado_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sado_ecommerce/provider/notification_provider.dart';
import 'package:flutter_sado_ecommerce/provider/product_provider.dart';
import 'package:flutter_sado_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sado_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sado_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sado_ecommerce/view/screen/brand/all_brand_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/category/all_category_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/featureddeal/featured_deal_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/shimmer/featured_product_shimmer.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/announcement.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/banners_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/brand_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/cart_widget_room_page.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/category_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/featured_deal_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/featured_product_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/room_list_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/room_list_card.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/shimmer/flash_deal_shimmer.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/flash_deals_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/footer_banner.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/room_category_product_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/latest_product_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/products_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/flashdeal/flash_deal_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/recommended_product_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/search_widget_room_page.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/top_seller_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/product/view_all_product_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/search/search_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/shop/all_shop_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/room_design_screen.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  final bool isBacButtonExist;

  const RoomPage({Key? key, this.isBacButtonExist = true}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final ScrollController _scrollController = ScrollController();

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
    await Provider.of<RoomListProvider>(Get.context!, listen: false)
        .getRoomList(reload);
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

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";
    Provider.of<FlashDealProvider>(context, listen: false)
        .getMegaDealList(true, true);
    _loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    List<String?> types = [
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context),
    ];
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('3d_designs', context),
          isBackButtonExist: widget.isBacButtonExist),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(true);
            await Provider.of<FlashDealProvider>(Get.context!, listen: false)
                .getMegaDealList(true, false);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SearchScreen())),
                          child: const SearchWidgetRoomPage()))),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Landing Image
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraExtraSmall,
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            Images.roomDesign,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 200, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated('Bannerـcontent', context)
                                      .toString(),
                                  style: textRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                RoomDesignScreen()));
                                  },
                                  child: Text(
                                    getTranslated('Start_Designing', context)
                                        .toString(),
                                    style: textRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Consumer<RoomListProvider>(
                      builder: (context, roomListProvider, child) {
                        return roomListProvider.roomProductList != null
                            ? roomListProvider.roomProductList!.isNotEmpty
                                ? Stack(children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        color: Provider.of<ThemeProvider>(
                                                    context,
                                                    listen: false)
                                                .darkTheme
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.20)
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.125)),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: Dimensions.homePagePadding),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeDefault),
                                              child: TitleRow(
                                                title:
                                                    '${getTranslated('featured_rooms', context)}',
                                                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeaturedDealScreen())),
                                              ),
                                            ),
                                            const RoomListView(),
                                          ],
                                        )),
                                  ])
                                : const SizedBox.shrink()
                            : const FindWhatYouNeedShimmer();
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraExtraSmall,
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(Images.best),
                        ],
                      ),
                    ),

                    Consumer<RoomListProvider>(
                      builder: (context, roomListProvider, child) {
                        return roomListProvider.roomProductList != null
                            ? roomListProvider.roomProductList!.isNotEmpty
                                ? Stack(children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        color: Provider.of<ThemeProvider>(
                                                    context,
                                                    listen: false)
                                                .darkTheme
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.20)
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.125)),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: Dimensions.homePagePadding),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeDefault),
                                              child: TitleRow(
                                                title:
                                                    '${getTranslated('top_room', context)}',
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const FeaturedDealScreen())),
                                              ),
                                            ),
                                            const RoomListView(),
                                          ],
                                        )),
                                  ])
                                : const SizedBox.shrink()
                            : const FindWhatYouNeedShimmer();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
