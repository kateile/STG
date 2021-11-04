import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import 'ui/home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().then((_) {}).catchError((e) {
          //print('performImmediateUpdate error: ${e.toString()}');
        });
      }
    }).catchError((e) {
      //print('checkForUpdate error: ${e.toString()}');
    });
  }

  @override
  void initState() {
    checkForUpdate().then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
