import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeVideoWidget extends StatefulWidget {
  final String? url;
  const YoutubeVideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<YoutubeVideoWidget> createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    final htmlString = '''
    <html>
      <body style="margin: 0; padding: 0;">
        <iframe
          width="1920"
          height="1080"
          src="${widget.url ?? ''}"
          frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen>
        </iframe>
      </body>
    </html>
    ''';
    // Initialize the WebViewController
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    final htmlUri = Uri.dataFromString(
      htmlString,
      mimeType: 'text/html',
    ).toString();

    _webViewController.loadRequest(Uri.parse(htmlUri));
  }
  // Generate HTML and load it into the WebView

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return (widget.url!.isNotEmpty && Uri.parse(widget.url!).hasAbsolutePath)
        ? Container(
            height: width / 1.55,
            width: width,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: WebViewWidget(
              controller: _webViewController,
            ),
          )
        : const SizedBox.shrink();
  }
}
