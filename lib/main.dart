import 'package:flutter/material.dart';
import 'package:webview_for_whatsapp/view/web_view.dart';

void main() {
  runApp(const WebViewForWhatsApp());
}

class WebViewForWhatsApp extends StatelessWidget {
  const WebViewForWhatsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WebViewForWhats(),
    );
  }
}
