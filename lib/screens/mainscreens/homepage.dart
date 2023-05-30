import 'package:flutter/material.dart';
import 'package:poultry_app/screens/mainscreens/sell.dart';
import 'package:poultry_app/screens/mainscreens/todayrate.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/otherwidgets.dart';
import 'package:poultry_app/widgets/recommendationwidget.dart';
import 'package:poultry_app/widgets/searchbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Happy Poultry Farm",
                        style: bodyText16w600(color: black),
                      ),
                      TextButton(
                        onPressed: () {
                          NextScreen(context, TodayRatePage());
                        },
                        child: Text(
                          "Today's Rate",
                          style: bodyText12w600(color: yellow),
                        ),
                      ),
                      CustomButton(
                        radius: 6,
                        text: "Sell",
                        onClick: () {
                          NextScreen(context, HomepageSell());
                        },
                        width: 78,
                        height: 30,
                        textStyle: bodyText16w600(color: white),
                      )
                    ],
                  ),
                  CustomSearchBox(),
                  addVerticalSpace(10),
                  Container(
                    height: 132,
                    width: width(context),
                    child: Image.asset(
                      "assets/images/happy.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  addVerticalSpace(10),
                  Text(
                    "Popular Category",
                    style: bodyText14w600(color: black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        popularCategory(
                          context,
                          "assets/images/birds.png",
                          "Birds",
                          width(context) * .2,
                          width(context) * .2,
                        ),
                        popularCategory(
                          context,
                          "assets/images/eggs.png",
                          "Eggs",
                          width(context) * .2,
                          width(context) * .2,
                        ),
                        popularCategory(
                          context,
                          "assets/images/chick.png",
                          "Chicks",
                          width(context) * .2,
                          width(context) * .2,
                        ),
                        popularCategory(
                          context,
                          "assets/images/duck.png",
                          "Ducks",
                          width(context) * .2,
                          width(context) * .2,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Recommendations",
                    style: bodyText14w600(color: black),
                  ),
                ],
              ),
            ),
            RecommendationWidget(),
          ],
        ),
      ),
    );
  }
}
