import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addfeedtype.dart';
import 'package:poultry_app/screens/farmsettings/userinfo.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

import '../batches/addeggs.dart';

class FeedType extends StatefulWidget {
  FeedType({super.key});
  FeedTypeState createState() => FeedTypeState();
}

class FeedTypeState extends State<FeedType> {
  List feedTypeList = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection("settings")
        .doc("Feed Type")
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          feedTypeList = value.data()?['feedType'];
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddFeedType()))
            .then((value) {
          if (value == null) {
            return;
          } else {
            if (value) {
              fetchData();
            }
          }
        });
      }),
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Feed Type",
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
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: feedTypeList.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                          );
                        },
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              feedTypeList[index],
                              style: bodyText17w500(color: black),
                            ),
                          );
                        })),
            const Divider(
              height: 0,
            ),
            Column(
              children: [
                addVerticalSpace(20),
                Divider(
                  height: 0,
                ),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
