import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/helper/date_converter.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/provider/notification_provider.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/paginated_list_view.dart';
import 'package:flutter_sado_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sado_ecommerce/view/screen/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: getTranslated('notification', context),
          onBackPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            }
          },
        ),
        body: Consumer<NotificationProvider>(
          builder: (context, notification, child) {
            return notification.notificationModel != null
                ? (notification.notificationModel!.notification != null &&
                        notification
                            .notificationModel!.notification!.isNotEmpty)
                    ? RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<NotificationProvider>(context,
                                  listen: false)
                              .getNotificationList(1);
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: PaginatedListView(
                            scrollController: scrollController,
                            onPaginate: (int? offset) {},
                            totalSize:
                                notification.notificationModel?.totalSize,
                            offset: notification.notificationModel?.offset,
                            itemView: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 10,
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeSmall),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    notification.seenNotification(notification
                                        .notificationModel!
                                        .notification![0]
                                        .id!);
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) =>
                                            NotificationDialog(
                                                notificationModel: notification
                                                    .notificationModel!
                                                    .notification![0]));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: Dimensions.paddingSizeSmall,
                                        right: Dimensions.paddingSizeSmall,
                                        bottom: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF6FBFF),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeDefault),
                                    ),
                                    child: ListTile(
                                      minVerticalPadding:
                                          Dimensions.paddingSizeSmall,
                                      title: Text(
                                          notification.notificationModel!
                                                  .notification![0].title ??
                                              '',
                                          style: titilliumRegular.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                          )),
                                      subtitle: Text(
                                        notification.notificationModel!
                                                .notification![0].description ??
                                            '',
                                        style: titilliumRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                                      trailing: Text(
                                        DateConverter.localDateToIsoStringAMPM(
                                            DateTime.parse(notification
                                                .notificationModel!
                                                .notification![0]
                                                .createdAt!)),
                                        style: titilliumRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: ColorResources.getHint(
                                                context)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : const NoInternetOrDataScreen(
                        isNoInternet: false,
                        message: 'no_notification',
                        icon: Images.noNotification,
                      )
                : const NotificationShimmer();
          },
        ));
  }
}

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          color: ColorResources.getGrey(context),
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled:
                Provider.of<NotificationProvider>(context).notificationModel ==
                    null,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.notifications)),
              title: Container(height: 20, color: ColorResources.white),
              subtitle:
                  Container(height: 10, width: 50, color: ColorResources.white),
            ),
          ),
        );
      },
    );
  }
}
