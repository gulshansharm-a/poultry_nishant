import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/edit_add_screen.dart';
import 'package:poultry_app/screens/mainscreens/myads.dart';
import 'package:poultry_app/screens/mainscreens/postad.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class MyAds extends StatelessWidget {
  const MyAds({super.key});

  @override
  Widget build(BuildContext context) {
    List list = [
      {"image": "assets/images/a1.png", "title": "Broiler", "btext": "Sold"},
      {"image": "assets/images/a2.png", "title": "Eggs", "btext": "Sold"},
      {"image": "assets/images/a1.png", "title": "Deshi", "btext": "Posted"},
    ];
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
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                  );
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => EditMyAds()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      height: 120,
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            list[index]['image'],
                            width: 95,
                            height: 95,
                            fit: BoxFit.cover,
                          ),
                        ),
                        addHorizontalySpace(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    list[index]['title'],
                                    style: bodyText16w600(color: black),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Sold",
                                          style: bodyText14w500(color: white),
                                        ),
                                      ),
                                      decoration: shadowDecoration(5, 0, green),
                                      width: 77,
                                      height: 25,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Qty.:",
                                style: bodyText14w500(color: black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  "Posted On: 22/11/22",
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
