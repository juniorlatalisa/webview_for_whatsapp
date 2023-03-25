import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_for_whatsapp/utils/whats_app_web_utils.dart';

class WebViewForWhats extends StatefulWidget {
  const WebViewForWhats({super.key});

  @override
  State<WebViewForWhats> createState() => _WebViewForWhatsState();
}

class _WebViewForWhatsState extends State<WebViewForWhats> {
  late final WebViewController _controller;
  bool _success = false;

  void _onSuccess() {
    setState(() {
      _success = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = WhastAppWebUtils.initState(_onSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final webview = WebViewWidget(controller: _controller);
    return _success ? SafeArea(child: webview) : webview;
  }
}
