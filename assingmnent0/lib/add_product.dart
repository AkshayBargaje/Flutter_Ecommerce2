import 'package:assingmnent0/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final firestore = FirebaseFirestore.instance;

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formkey_ = GlobalKey<FormState>();
  FirebaseAuth _user = FirebaseAuth.instance;

  String Brand = "";
  String Category = "";
  String Name = "";
  int Price = 0;

  submit() {
    final _validate = _formkey_.currentState!.validate();
    if (_validate) {
      firestore
          .collection("Seller")
          .doc(_user.currentUser!.email)
          .collection("Product")
          .add({
        'Name': Name,
        'Category': Category,
        'Brand': Brand,
        "Price": Price
      });
      firestore.collection("AllProducts").add(
          {'Name': Name, 'Category': Category, 'Brand': Brand, "Price": Price});
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey_,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return ("Enter valid Category");
                } else {
                  Category = value!;
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Name Of Category"),
            ),
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return ("Enter valid Brand Name");
                } else {
                  Brand = value!;
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Brand Name"),
            ),
            TextFormField(
              validator: (value) {
                if (value == '') {
                  return ("Enter valid Name");
                } else {
                  Name = value!;
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Name Of Product"),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                inputFormatters:
                [FilteringTextInputFormatter.digitsOnly];
                if (value == '') {
                  return ("Enter valid Price");
                } else {
                  Price = num.tryParse(value!)!.toInt();
                }
              },
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: "Price"),
            ),
            RaisedButton(onPressed: submit, child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
