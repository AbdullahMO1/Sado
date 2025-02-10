import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_sado_ecommerce/utill/app_constants.dart';

class RoomDesignScreen extends StatefulWidget {
  const RoomDesignScreen({Key? key}) : super(key: key);

  @override
  State<RoomDesignScreen> createState() => _RoomDesignScreenState();
}

class _RoomDesignScreenState extends State<RoomDesignScreen> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController with the required attributes
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('${AppConstants.baseUrl}/room-design'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: getTranslated('3d_room', context)),
        body: WebViewWidget(
          controller: _webViewController,
        ));
  }
}
