import 'dart:async';

import 'package:assingmnent0/customerhome.dart';
import 'package:assingmnent0/global.dart';
import 'package:assingmnent0/sellerhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key,
      required this.email,
      required this.password,
      required this.type})
      : super(key: key);
  final String email;
  final String password;
  final String type;

  @override
  State<HomePage> createState() =>
      _HomePageState(email: email, password: password, type: type);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(
      {required this.email, required this.password, required this.type});
  final String email;
  final String password;
  final String type;

  FirebaseAuth _user = FirebaseAuth.instance;
  late Timer timer;
  bool verified = false;
  String user = '';

  GlobalKey _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    _user.currentUser!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (verified == true) {
        timer.cancel();
      } else {
        checkEmailverfi();
      }
    });
    super.initState();
    // final aa = _user.currentUser;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  SignUpAsCustomer(String email, String password) {
    var docRef = _firebaseFirestore
        .collection('Customer')
        .doc(_user.currentUser!.email)
        .set({'email': email, 'password': password});
  }

  SignUpAsSeller(String email, String password) {
    _firebaseFirestore
        .collection('Seller')
        .doc(email)
        .set({'email': email, 'password': password});
  }

  @override
  Widget build(BuildContext context) {
    if (verified == false) {
      return Scaffold(
        body: Column(
          children: const [
            CircularProgressIndicator(),
            Text("check Your email and verify it to proceed")
          ],
        ),
      );
    } else if (type == "Seller") {
      userId = "Seller";
      return SellerHome();
    } else {
      userId = "Customer";
      return Customerhome();
    }
  }

  Future<void> checkEmailverfi() async {
    await _user.currentUser!.reload();
    bool ver = await _user.currentUser!.emailVerified;
    setState(() {
      verified = true;
      if (type == 'Customer') {
        SignUpAsCustomer(email, password);
      } else {
        SignUpAsSeller(email, password);
      }
    });
  }
}
