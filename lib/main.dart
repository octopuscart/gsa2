import 'package:flutter/material.dart';
import 'initPage.dart';
import 'screens/homepage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gospal Sharing App',
      // theme: ThemeData(

      //   primarySwatch: Colors.blue,
      // ),
      home: const InitPage(title: 'Flutter Demo Home Page'),
      initialRoute: 'initpage',
      routes: {
        'initpage': (context) => InitPage(title: 'GSA Init Page'),
        'home': (context) => MyHomePage(title: 'GSA Home Page'),
      },
    );
  }
}
