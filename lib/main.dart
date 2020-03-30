import './pages/provider/printCommand.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/route.dart';
import 'package:flutter/services.dart';
import './pages/provider/printerParams.dart';
import './pages/provider/printTaskList.dart';
import './utils/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './generated/i18n.dart';
// import 'package:flutter_country_picker/flutter_country_picker.dart';
// import 'package:international_phone_input/international_phone_input.dart';

void main() {
  runApp(new MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => NozzleWarm()),
          ChangeNotifierProvider(builder: (_) => PrinterIdProvider()),
          ChangeNotifierProvider(builder: (_) => PrintTaskProvider()),
        ],
        child: OKToast(
            child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: Router.navigatorKey,
          title: "Lotmaxx3D",
          theme: ThemeData(
            primaryColor: Color(0xFFF79432),
            // highlightColor: Colors.transparent,
            // splashColor: Color(0xFFF79432),
          ),
              localizationsDelegates: [
                // 应用程序的翻译代理
                S.delegate,
                // Material组件的翻译代理
                GlobalMaterialLocalizations.delegate,
                // 普通Widget的翻译代理
                GlobalWidgetsLocalizations.delegate,
              ],
              // 支持的语言
              supportedLocales: S.delegate.supportedLocales,
              onGenerateTitle: (context) {
                return S.of(context).app_title;
              },
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
        )));
  }
}
