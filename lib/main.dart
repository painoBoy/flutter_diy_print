import './pages/provider/counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/route.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_country_picker/flutter_country_picker.dart';
// import 'package:international_phone_input/international_phone_input.dart';

void main() {
 
  runApp(new MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        // providers: [
        //   ChangeNotifierProvider(builder: (_) => Counter()),
        // ],
        // child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,

      title: "Lotmaxx3D",
      theme: ThemeData(
          primaryColor: Color(0xFFF79432),
          highlightColor: Colors.transparent,
          splashColor: Color(0xFFF79432),
          brightness: Brightness.light),
      initialRoute: '/modelLib',
      onGenerateRoute: onGenerateRoute,
      // home: LoadingPage(),
      // ),
    );
  }
}
