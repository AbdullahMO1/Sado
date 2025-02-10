import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_sado_ecommerce/utill/app_constants.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_app_bar.dart';

class RoomIndividualDesignScreen extends StatefulWidget {
  final String roomId;

  const RoomIndividualDesignScreen({Key? key, required this.roomId})
      : super(key: key);

  @override
  State<RoomIndividualDesignScreen> createState() =>
      _RoomIndividualDesignScreenState();
}

class _RoomIndividualDesignScreenState
    extends State<RoomIndividualDesignScreen> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController with the required attributes
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('${AppConstants.baseUrl}/room${widget.roomId}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('3d_room', context)),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
