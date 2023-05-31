import 'package:flutter/material.dart';
import 'package:serenity/screens/add_new_card_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.secondaryColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              BackWidget(
                name: Strings.myCard,
                active: true,
              ),
              bodyWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius * 2),
            topRight: Radius.circular(Dimensions.radius * 2),
          ),
        ),
        child: cardWidget(context),
      ),
    );
  }

  Widget cardWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
        top: Dimensions.heightSize * 3,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: CustomColor.primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      Dimensions.radius * 0.5,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${Strings.addNewCard.toUpperCase()} +',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.largeTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewCardScreen(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: Dimensions.heightSize * 3,
            ),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/credit_card.png',
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: Dimensions.heightSize * 2,
                    left: Dimensions.marginSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.demoCardNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.largeTextSize,
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.heightSize,
                        ),
                        Text(
                          Strings.demoHolderName.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.largeTextSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Dimensions.heightSize * 2,
                    right: Dimensions.marginSize,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.validForm.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                            Text(
                              '12/20',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: Dimensions.heightSize,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.validThru.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                            Text(
                              '11/25',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Dimensions.heightSize,
            ),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/visa.png',
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: Dimensions.heightSize * 2,
                    left: Dimensions.marginSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.demoCardNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.largeTextSize,
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.heightSize,
                        ),
                        Text(
                          Strings.demoHolderName.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.largeTextSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Dimensions.heightSize * 2,
                    right: Dimensions.marginSize,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.validForm.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                            Text(
                              '12/20',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: Dimensions.heightSize,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.validThru.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                            Text(
                              '11/25',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.defaultTextSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
