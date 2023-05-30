import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/farmsettings/addfeedtype.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

int orderNo = 1;
int quantity = 0;
double price = 0.0;
double total = 0.0;

class _AddOrderPageState extends State<AddOrderPage> {
  List feedType = [];
  String type = "";
  final date = TextEditingController(
      text: DateFormat("dd/MMM/yyyy")
          .format(DateTime.now())
          .toString()
          .toLowerCase());
  TextEditingController companyController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getOrderNumber();
    getFeedType();
  }

  Future<void> getOrderNumber() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          //orders exist for the user
          int data = value.data()!.length + 1;
          setState(() {
            orderNo = data;
          });
        } else {
          setState(() {
            orderNo = 1;
          });
        }
      },
    );
    print(orderNo);
  }

  Future<void> getFeedType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('settings')
        .doc('Feed Type')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          feedType = value.data()?['feedType'];
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("settings")
            .doc("Feed Type")
            .set({
          "feedType": [
            "Pre Starter",
            "Starter",
            "Phase 1",
            "Phase 2",
          ]
        });
        setState(() {
          feedType = [
            "Pre Starter",
            "Starter",
            "Phase 1",
            "Phase 2",
          ];
        });
      }
    });
  }

  void dispose() {
    super.dispose();
    companyController.dispose();
    date.dispose();
    quantityController.dispose();
    priceController.dispose();
    totalController.dispose();
    weightController.dispose();
  }

  bool option = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Order",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 27,
                width: 93,
                decoration: shadowDecoration(6, 0, yellow),
                child: Center(
                  child: Text(
                    "Order No. $orderNo",
                    style: bodyText10w600(color: white),
                  ),
                ),
              ),
              CustomTextField(
                hintText: "Date",
                suffix: true,
                controller: date,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      list: feedType,
                      height: 58,
                      hint: "Feed Type",
                      onchanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                    ),
                  ),
                  addHorizontalySpace(15),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => AddFeedType()));
                    },
                    child: Container(
                      height: 58,
                      width: 58,
                      decoration: shadowDecoration(10, 0, yellow),
                      child: Icon(
                        Icons.add,
                        size: 28,
                        color: white,
                      ),
                    ),
                  )
                ],
              ),
              CustomTextField(
                hintText: "Feed Company",
                controller: companyController,
              ),
              CustomTextField(
                hintText: "Bag Quantity",
                controller: weightController,
                textType: TextInputType.number,
              ),
              CustomTextField(
                hintText: "Bag Quantity",
                controller: quantityController,
                textType: TextInputType.number,
                onchanged: (value) {
                  setState(() {
                    if (value.toString().isNotEmpty) {
                      quantity = int.tryParse(value.toString())!;
                      print(quantity);
                      total = price * quantity;
                    } else {
                      quantity = 0;
                      total = 0;
                      print(quantity);
                    }
                    totalController.text = total.toString();
                  });
                },
              ),
              CustomTextField(
                hintText: "Bag Price",
                controller: priceController,
                textType: TextInputType.number,
                onchanged: (value) {
                  setState(() {
                    if (value.toString().isNotEmpty) {
                      price = double.tryParse(value.toString())!;
                      total = price * quantity;
                    } else {
                      price = 0.0;
                      total = 0.0;
                    }
                    totalController.text = total.toString();
                  });
                },
              ),
              CustomTextField(
                hintText: "Total",
                enabled: false,
                controller: totalController,
              ),
              addVerticalSpace(10),
              Text(
                "Payment Method",
                style: bodyText15w500(color: darkGray),
              ),
              addVerticalSpace(20),
              Row(
                children: [
                  Text(
                    "Cash",
                    style: bodyText15w500(color: darkGray),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FlutterSwitch(
                      padding: 3,
                      value: option,
                      inactiveColor: yellow,
                      activeColor: yellow,
                      onToggle: (value) {
                        setState(() {
                          option = value;
                        });
                      },
                      width: 50,
                      height: 25,
                      toggleSize: 20,
                    ),
                  ),
                  Text(
                    "Online",
                    style: bodyText15w500(color: black),
                  ),
                ],
              ),
              addVerticalSpace(15),
              CustomButton(
                  text: "Place Order",
                  onClick: () async {
                    print(option);
                    if (date.text.isEmpty ||
                        type.length == 0 ||
                        companyController.text.isEmpty ||
                        weightController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please fill all the details!");
                    } else {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set(
                        {
                          "order$orderNo": {
                            "date": date.text,
                            "feedType": type,
                            "feedCompany": companyController.text,
                            "feedWeight":
                                double.tryParse(weightController.text),
                            "feedQuantity": quantity,
                            "originalQuantity": quantity,
                            "feedPrice": price,
                            "totalPrice": total,
                            "orderStatus": "Not Received",
                            "paymentMethod": option == true ? "Online" : "Cash",
                          }
                        },
                        SetOptions(merge: true),
                      );
                      print(type);
                      // print({
                      //   "date": date.text,
                      //   "feedType": _customDropdown.value,
                      //   "feedCompany": companyController.text,
                      //   "feedWeight": double.tryParse(weightController.text),
                      //   "feedQuantity": quantity,
                      //   "feedPrice": price,
                      //   "totalPrice": total,
                      //   "paymentMethod": option == true ? "Online" : "Cash",
                      // });
                      showDialog(
                          context: context,
                          builder: (context) => ShowDialogBox(
                                message: "Order Placed!!",
                                subMessage: '',
                              ));

                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
