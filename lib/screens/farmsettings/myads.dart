import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/edit_add_screen.dart';
import 'package:poultry_app/screens/mainscreens/myads.dart';
import 'package:poultry_app/screens/mainscreens/postad.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class MyAds extends StatefulWidget {
  const MyAds({super.key});
  MyAdsState createState() => MyAdsState();
}

class MyAdsState extends State<MyAds> {
  List adsList = [];
  bool isLoading = true;

  Future<void> getAds() async {
    setState(() {
      isLoading = true;
      adsList.clear();
    });
    await FirebaseFirestore.instance
        .collection("ads")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["advertisementDetails"].length; i++) {
          setState(() {
            adsList.add({
              "imageUrl":
                  value.data()!["advertisementDetails"][i]["imageUrl"] ?? "",
              "sold": value.data()!["advertisementDetails"][i]["sold"],
              "type":
                  value.data()!["advertisementDetails"][i]["type"].toString(),
              "quantity": value.data()!["advertisementDetails"][i]["quantity"],
              "date": value.data()!["advertisementDetails"][i]["date"],
            });
          });
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "My Ads",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(30),
            Divider(
              height: 0,
            ),
            isLoading
                ? CircularProgressIndicator()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: adsList.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      EditMyAds(index: index))).then((value) {
                            if (value == null || value == false) {
                              return;
                            } else {
                              if (value) {
                                getAds();
                              }
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          height: 120,
                          child: Row(children: [
                            Container(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: adsList[index]['imageUrl'] == ""
                                    ? Center(
                                        child: Text(
                                          "No Image",
                                          style: bodyText14normal(color: black),
                                        ),
                                      )
                                    : Image.network(
                                        adsList[index]["imageUrl"],
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            addHorizontalySpace(20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        adsList[index]['type'],
                                        style: bodyText16w600(color: black),
                                      ),
                                      adsList[index]["sold"] == true
                                          ? GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                child: Center(
                                                  child: Text(
                                                    "Sold",
                                                    style: bodyText14w500(
                                                        color: white),
                                                  ),
                                                ),
                                                decoration: shadowDecoration(
                                                    5, 0, green),
                                                width: 77,
                                                height: 25,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Text(
                                    "Qty.: ${adsList[index]["quantity"]}",
                                    style: bodyText14w500(color: black),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Posted On: ${adsList[index]["date"]}",
                                      style: bodyText12w500(color: black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
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
