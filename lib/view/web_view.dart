import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_for_whatsapp/widget/alert_dialog.dart';

class WebViewForWhats extends StatefulWidget {
  const WebViewForWhats({super.key});

  @override
  State<WebViewForWhats> createState() => _WebViewForWhatsState();
}

class _WebViewForWhatsState extends State<WebViewForWhats> {
  late final WebViewController _controller;

  var _initializaed = false;
  var _success = false;

  Future<void> _showError(dynamic error) async {
    if (error is SocketException) {
      final SocketException se = error;
      return _onSuccess(se.message, false);
    }

    if (error is WebResourceError) {
      final WebResourceError wre = error;
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const CustomAlertDialog();
        },
      );
    }
  }

  _onSuccess(final String message, final bool success) {
    return _controller
        .runJavaScript('WebView4WhatsApp.onSuccess("$message", $success);');
  }

  _setStatus(final String message) {
    return _controller.runJavaScript('WebView4WhatsApp.setStatus("$message");');
  }

  void _onPageFinished(
      final String userAgent, final assetIndex, final String finishedUrl) {
    setState(() {
      if (finishedUrl.endsWith(assetIndex)) {
        _setStatus('Iniciando WhatsApp Web...');
        _loadWhatsAppWeb(userAgent);
      } else if (!_initializaed && _success) {
        _initializaed = true;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }
    });
  }

  void _loadWhatsAppWeb(final String userAgent) {
    const baseUrl = 'https://web.whatsapp.com/';
    final uri = Uri.parse(baseUrl);
    final Map<String, String> headers = <String, String>{
      'Host': 'web.whatsapp.com',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
      'Accept-Language': 'pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3',
      'Upgrade-Insecure-Requests': '1',
      'Sec-Fetch-Dest': 'document',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-Site': 'none',
      'Sec-Fetch-User': '?1',
      'Sec-CH-UA-Mobile': '?0',
      'Connection': 'keep-alive',
    };
    http.read(uri, headers: headers).then((contents) {
      _onSuccess('WhatsApp Web', true);
      _success = true;
      _controller.loadHtmlString(contents, baseUrl: baseUrl);
    }).catchError((error) {
      _showError(error);
    });
  }

  @override
  void initState() {
    super.initState();

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

    const assetIndex = 'assets/www/index.html';
    const String userAgent =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0';

    final NavigationDelegate delegate = NavigationDelegate(
      onPageFinished: (url) => _onPageFinished(userAgent, assetIndex, url),
      onWebResourceError: (error) => _showError(error),
    );

    controller
      ..clearCache()
      ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(userAgent)
      ..setNavigationDelegate(delegate)
      ..loadFlutterAsset(assetIndex);

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
    return WebViewWidget(controller: _controller);
  }
}
