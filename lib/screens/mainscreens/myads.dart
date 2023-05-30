import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          title: "Recommendations",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(10),
              Center(
                child: Text(
                  "Broiler",
                  style: bodyText20w600(color: black),
                ),
              ),
              addVerticalSpace(25),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "assets/images/broiler.png",
                  height: 127,
                  width: width(context),
                  fit: BoxFit.fill,
                ),
              ),
              addVerticalSpace(30),
              Text(
                "Category:",
                style: bodyText15w500(color: black),
              ),
              addVerticalSpace(30),
              Text(
                "Description:",
                style: bodyText15w500(color: black),
              ),
              Text(
                "Lorem ipsum dolor sit amet consectetur. Arcu vel dignissim suscipit nulla nibh lacus consectetur et et.",
                style: bodyText13normal(color: black),
              ),
              addVerticalSpace(25),
              Text(
                "Quantity:",
                style: bodyText15w500(color: black),
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Text(
                    "Contact Number: ",
                    style: bodyText15w500(color: black),
                  ),
                  Text(
                    "+91-9556781395",
                    style: bodyText15normal(color: black),
                  ),
                ],
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Text(
                    "State: ",
                    style: bodyText15w500(color: black),
                  ),
                  Text(
                    "Maharashtra",
                    style: bodyText15normal(color: black),
                  )
                ],
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Container(
                    width: width(context) * .45,
                    child: Row(
                      children: [
                        Text(
                          "City: ",
                          style: bodyText15w500(color: black),
                        ),
                        Text(
                          "Pune",
                          style: bodyText15normal(color: black),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Village: ",
                        style: bodyText15w500(color: black),
                      ),
                      Text(
                        "Akluj",
                        style: bodyText15normal(color: black),
                      )
                    ],
                  ),
                ],
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Text(
                    "Ad Posted On: ",
                    style: bodyText15w500(color: black),
                  ),
                  Text(
                    "15/12/2022",
                    style: bodyText15normal(color: black),
                  )
                ],
              ),
              addVerticalSpace(60),
              CustomButton(
                  text: "Call Seller",
                  onClick: () {},
                  width: width(context),
                  height: 58)
            ],
          ),
        ),
      ),
    );
  }
}
