import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String? title;
  final String? url;
  const WebViewScreen({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  WebViewController? controllerGlobal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controllerGlobal = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (kDebugMode) {
              print('Page started loading: $url');
            }
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            if (kDebugMode) {
              print('Page finished loading: $url');
            }
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (kDebugMode) {
              print('Navigation request: ${request.url}');
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            CustomAppBar(title: widget.title),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(
                    controller: controllerGlobal!,
                  ),
                  _isLoading
                      ? CustomLoader(color: Theme.of(context).primaryColor)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    if (controllerGlobal != null) {
      if (await controllerGlobal!.canGoBack()) {
        controllerGlobal!.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      return Future.value(true);
    }
  }
}
