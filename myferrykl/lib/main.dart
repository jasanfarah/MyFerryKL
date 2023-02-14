import 'package:flutter/material.dart';
import 'package:myferrykl/db/db.dart';

import 'home.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(),
    home: MyApp(),
  ));}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
// 2
    final DBService db = DBService();
    db.initDatabase();
    //db.testFerryTicket();
    //db.findUserInfo("1");
    //db.findBooking("1");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyFerryKL',

theme: ThemeData(
       primarySwatch: Colors.blue,
       scaffoldBackgroundColor: Colors.white),
          home: MyHomePage());
  }
}
