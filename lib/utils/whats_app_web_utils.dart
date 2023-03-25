import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WhastAppWebUtils {
  static Future<void> _onSuccess(final WebViewController controller,
      final String message, final bool success) {
    return controller
        .runJavaScript('WebView4WhatsApp.onSuccess("$message", $success);');
  }

  static Future<void> _setStatus(
      final WebViewController controller, final String message) {
    return controller.runJavaScript('WebView4WhatsApp.setStatus("$message");');
  }

  static void _onPageFinished(final WebViewController controller,
      void Function() onSuccess, final String userAgent, final bool index) {
    if (index) {
      _setStatus(controller, 'Iniciando WhatsApp Web...');
      _loadWhatsAppWeb(controller, userAgent);
    } else {
      onSuccess();
    }
  }

  static Future<void> _showError(
      final WebViewController controller, dynamic error) async {
    if (error is SocketException) {
      final SocketException se = error;
      return _onSuccess(controller, se.message, false);
    }
  }

  static void _loadWhatsAppWeb(
      final WebViewController controller, final String userAgent) {
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
      _onSuccess(controller, 'WhatsApp Web Encontrado', true);
      controller.loadHtmlString(contents, baseUrl: baseUrl);
    }).catchError((error) {
      _showError(controller, error);
    });
  }

  static WebViewController initState(void Function() onSuccess) {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{
          PlaybackMediaTypes.audio,
          PlaybackMediaTypes.video,
        },
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
      onPageFinished: (url) => _onPageFinished(
          controller, onSuccess, userAgent, url.endsWith(assetIndex)),
      onWebResourceError: (error) => _showError(controller, error),
    );

    controller
      ..clearCache()
      ..enableZoom(true)
      ..setBackgroundColor(Colors.green)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(userAgent)
      ..setNavigationDelegate(delegate)
      ..loadFlutterAsset(assetIndex);

    return controller;
  }
}
