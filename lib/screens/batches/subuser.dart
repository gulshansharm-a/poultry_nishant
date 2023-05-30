import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addsubuser.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class SubUserPage extends StatefulWidget {
  final int index;
  int accessLevel;
  String owner;
  SubUserPage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  SubUserPageState createState() => SubUserPageState();
}

class SubUserPageState extends State<SubUserPage> {
  bool subUsersPresent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(
              onTap: () {
                NextScreen(
                    context,
                    AddSubUserPage(
                      index: widget.index,
                      owner: widget.owner,
                    ));
              },
            )
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(20),
          Text(
            "Sub User",
            style: bodyText22w600(color: black),
          ),
          addVerticalSpace(20),
          Divider(
            height: 0,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('batches')
                .doc(batchDocIds[widget.index])
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                print(snapshot.data!.data());
                return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: transparent,
                          backgroundImage:
                              AssetImage("assets/images/adduser.png"),
                        ),
                        title: Text(
                          snapshot.data!.data()!["userIDs"][index]['name'],
                          style: bodyText16w500(color: black),
                        ),
                        subtitle: Text(
                            snapshot.data!.data()!["userIDs"][index]['type']),
                        trailing: Image.asset("assets/images/delete.png"),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemCount: snapshot.data!.data()!["userIDs"].length);
              }
            }),
          ),
          Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
