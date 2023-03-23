import 'package:flutter/material.dart';
import 'package:webview_for_whatsapp/view/web_view.dart';

void main() {
  runApp(const WebViewForWhatsApp());
}

class WebViewForWhatsApp extends StatelessWidget {
  const WebViewForWhatsApp({Key? key}) : super(key: key);

  static final _materialApp = MaterialApp(
    // title: RecyclingLocalizations.title,
    // localizationsDelegates: RecyclingLocalizations.localizationsDelegates,
    // supportedLocales: RecyclingLocalizations.supportedLocales,
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    // routes: RecyclingRoutes.routes,
    // initialRoute: RecyclingRoutes.home,
    home: const WebView(),
  );

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    return _materialApp;
    //   providers: RecyclingProviders.providers,
    //   child: _materialApp,
    // );
  }
}
