import 'dart:ffi';
import 'package:assingmnent0/add_product.dart';
import 'package:assingmnent0/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final firestore = FirebaseFirestore.instance.collection("Seller");
final _firestore = FirebaseFirestore.instance;

class SellerHome extends StatefulWidget {
  SellerHome({Key? key}) : super(key: key);

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  FirebaseAuth _user = FirebaseAuth.instance;
  double start = 0;
  double end = 1000;
  String _valueToString(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool filter = false;

    Widget BodyWidget = Stack(
      children: [
        Positioned(
          top: 0,
          left: 20,
          right: 20,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RangeSlider(
                  activeColor: Color.fromARGB(255, 38, 38, 38),
                  values: RangeValues(start, end),
                  labels: RangeLabels(start.toString(), end.toString()),
                  min: 0,
                  max: 1000,
                  divisions: 100,
                  onChanged: (RangeValues value) {
                    setState(() {
                      start = value.start;
                      end = value.end;
                    });
                  },
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: StreamBuilder(
            stream: firestore
                .doc(_user.currentUser!.email)
                .collection("Product")
                .where(
                  "Price",
                  isGreaterThan: start,
                )
                .where(
                  "Price",
                  isLessThan: end,
                )
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text("something went wrong");
              } else if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                final data = snapshot.requireData;
                return Container(
                    child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 20),
                  children: List.generate(data.size, (i) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color.fromARGB(255, 249, 201, 129))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.centers,
                                children: [
                                  Text(
                                    data.docs[i]["Brand"],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 40)),
                                  Text(
                                    data.docs[i]["Category"],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    data.docs[i]["Name"],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 40)),
                                  Text(
                                    data.docs[i]["Price"].toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ));
              }
            },
          ),
        ),
        Positioned(
            top: height * 0.7,
            bottom: 50,
            left: 100,
            right: 100,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: Card(
                elevation: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange)),
                        child: Icon(
                          Icons.add,
                          color: Colors.orange,
                          size: 36,
                        )),
                    Text(
                      "Add items",
                      style: TextStyle(color: Colors.orange, fontSize: 24),
                    )
                  ],
                ),
              ),
            )),
      ],
    );

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.transparent.withOpacity(0),
          elevation: 500,
          toolbarHeight: 100,
          actions: [
            Row(
              children: [
                Container(
                  child: Icon(
                    Icons.person,
                    size: 36,
                    color: Colors.black,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hey ${_user.currentUser!.email}!",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "Seller",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  width: 60,
                ),
              ],
            )
          ]),
      body: BodyWidget,
    );
  }
}
