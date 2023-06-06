import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addcustomer.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});
  CustomerListPageState createState() => CustomerListPageState();
}

class CustomerListPageState extends State<CustomerListPage> {
  List cat = [];
  bool isLoading = true;
  Future<void> getCustomerList() async {
    setState(() {
      cat.clear();
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Customer List")
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          cat = value["customerList"];
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddCustomer()))
            .then((value) {
          if (value == null) {
            return;
          } else {
            if (value) {
              getCustomerList();
            }
          }
        });
      }),
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Customer List",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            Divider(
              height: 0,
            ),
            isLoading
                ? CircularProgressIndicator()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cat.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          cat[index]['name'],
                          style: bodyText17w500(color: black),
                        ),
                        trailing: Text(
                          cat[index]['contact'],
                          style: bodyText12normal(color: black),
                        ),
                      );
                    }),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
