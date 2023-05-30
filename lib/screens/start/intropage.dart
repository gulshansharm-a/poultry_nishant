import 'package:flutter/material.dart';
import 'package:poultry_app/screens/auth/login.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/navigation.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    int logIndex = 2;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height(context),
            child: PageView(
              controller: pageController,
              onPageChanged: (i) {
                setState(() {
                  if (logIndex == i) {
                    NextScreen(context, LogIn());
                  }
                });
              },
              children: const [
                PageViewItemWidget(
                  assetUrl: 'assets/images/intro1.png',
                ),
                PageViewItemWidget(
                  assetUrl: 'assets/images/intro2.png',
                ),
                LogIn()
              ],
            ),
          ),
          Positioned(
              right: 35,
              bottom: height(context) * 0.025,
              child: Row(
                children: [
                  addHorizontalySpace(30),
                  InkWell(
                    onTap: () {
                      setState(() {});

                      pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: yellow,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: white,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundColor: yellow,
                          child: Icon(
                            Icons.arrow_forward,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class PageViewItemWidget extends StatelessWidget {
  final String assetUrl;

  const PageViewItemWidget({
    Key? key,
    required this.assetUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: height(context) * 0.6,
            width: width(context),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                assetUrl,
              ),
              fit: BoxFit.fill,
            ))), 
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 90,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    height: 7,
                    width: 102,
                    color: yellow,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lorem Ipsum",
                      style: bodyText24w400(color: black),
                    ),
                    addVerticalSpace(6),
                    Text(
                      "is Simply dummy text",
                      style: bodyText24w600(color: black),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
