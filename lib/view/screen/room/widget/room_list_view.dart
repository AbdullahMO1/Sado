import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/provider/room_list_provider.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_slider/carousel_options.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_slider/custom_slider.dart';
import 'package:flutter_sado_ecommerce/view/screen/home/widget/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_sado_ecommerce/view/screen/room/widget/room_list_card.dart';
import 'package:provider/provider.dart';

class RoomListView extends StatelessWidget {
  final bool isHomePage;
  const RoomListView({Key? key, this.isHomePage = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHomePage
        ? Consumer<RoomListProvider>(
            builder: (context, roomListProvider, child) {
              return roomListProvider.roomProductList != null
                  ? roomListProvider.roomProductList!.isNotEmpty
                      ? CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 2.5,
                            viewportFraction: 0.83,
                            autoPlay: true,
                            enlargeFactor: 0.2,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            disableCenter: true,
                            onPageChanged: (index, reason) {
                              Provider.of<RoomListProvider>(context,
                                      listen: false)
                                  .changeSelectedIndex(index);
                            },
                          ),
                          itemCount: roomListProvider.roomProductList?.length,
                          itemBuilder: (context, index, _) {
                            return RoomListCard(
                                isHomePage: isHomePage,
                                product:
                                    roomListProvider.roomProductList![index]);
                          },
                        )
                      : const SizedBox()
                  : const FindWhatYouNeedShimmer();
            },
          )
        : Consumer<RoomListProvider>(builder: (context, roomListProvider, _) {
            return ListView.builder(
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                itemCount: roomListProvider.roomProductList?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall),
                    child: RoomListCard(
                        isHomePage: isHomePage,
                        product: roomListProvider.roomProductList![index]),
                  );
                });
          });
  }
}
