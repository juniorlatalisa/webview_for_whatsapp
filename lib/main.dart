import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

void main() {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    //for landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    const String userAgent =
        // 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0';
        'Mozilla/5.0 Gecko/20100101 Firefox/110.0';

    const Map<String, String> headers = <String, String>{
      'Host': 'web.whatsapp.com',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
      'Accept-Language': 'pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3',
      // 'Accept-Encoding': 'gzip, deflate, br',
      'Upgrade-Insecure-Requests': '1',
      'Sec-Fetch-Dest': 'document',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-Site': 'none',
      'Sec-Fetch-User': '?1',
      'Sec-CH-UA-Mobile': '?0',
      'Connection': 'keep-alive',
    };

    const baseUrl = 'https://web.whatsapp.com/';
    final uri = Uri.parse(baseUrl);

    controller
          ..clearCache()
          ..enableZoom(true)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(userAgent)
        // ..addJavaScriptChannel('console', onMessageReceived: onMessageReceived)
        // ..loadFlutterAsset('assets/www/index.html')
        // ..loadRequest(uri, headers: headers)
        ;

    http.read(uri, headers: headers).then((contents) {
      print('************** FOI ***************');
      controller.loadHtmlString(contents, baseUrl: baseUrl);
      print('contents: ${contents}');
    }).catchError((erro) {
      print('************** ERRO ***************');
      print('contents: ${erro}');
    });

    _controller = controller;
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}
