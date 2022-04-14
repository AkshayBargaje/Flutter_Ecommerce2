import 'package:assingmnent0/customerhome.dart';
import 'package:assingmnent0/global.dart';
import 'package:assingmnent0/homepage.dart';
import 'package:assingmnent0/login_page.dart';
import 'package:assingmnent0/sellerhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _user = FirebaseAuth.instance;
    Widget _widget;
    if (userId.trim() == "") {
      _widget = Login_Page();
    } else if (userId == "Seller") {
      _widget = SellerHome();
    } else if (userId == 'Customer') {
      _widget = Customerhome();
    } else {
      _widget = Text('data');
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _widget,
    );
  }
}
