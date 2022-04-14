import 'dart:async';

import 'package:assingmnent0/add_product.dart';
import 'package:assingmnent0/customerhome.dart';
import 'package:assingmnent0/global.dart';
import 'package:assingmnent0/homepage.dart';
import 'package:assingmnent0/sellerhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _user = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = "";
  String _password = "";

  SignUp() async {
    print(_email);
    print(_password);
    // _user.signOut();

    final _validate = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      try {
        final new_user = await _user.createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      email: _email,
                      password: _password,
                      type: selected,
                    )));
      } catch (e) {
        print(e);
      }
    }
  }

  SignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        _user.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        final s = await _firestore
            .collection("Seller")
            .doc(_user.currentUser!.email)
            .get();
        final c = await _firestore
            .collection("Customer")
            .doc(_user.currentUser!.email)
            .get();
        print(s.exists);
        print(c.exists);
        if (c.exists) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Customerhome()));
        } else if (s.exists) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SellerHome()));
        } else {
          return Text("Something went wrong");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Logout() {
    _user.signOut();
  }

  String selected = "Customer";

  var option = ["Customer", "Seller"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return ("Enter valid email");
                } else {
                  _email = value!;
                }
              },
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: "Email"),
            ),
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return ("Enter valid password");
                } else {
                  _password = value!;
                }
              },
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Password"),
            ),
            DropdownButton(
                value: selected,
                items: option.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selected = newValue!;
                  });
                  print(selected);
                }),
            RaisedButton(onPressed: SignUp, child: Text("SignUp")),
            RaisedButton(onPressed: SignIn, child: Text("SignIn")),
            RaisedButton(onPressed: Logout, child: Text("Logout")),
          ],
        ),
      ),
    );
  }
}
