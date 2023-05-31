import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
                name: Strings.helpSupport,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              settingsWidget(context),
              const SizedBox(
                height: Dimensions.heightSize * 3,
              ),
              faqWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
        top: Dimensions.heightSize,
      ),
      child: Column(
        children: [
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Dimensions.radius,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.marginSize, right: Dimensions.marginSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.myAccount,
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Dimensions.radius,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.marginSize, right: Dimensions.marginSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.address,
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Dimensions.radius,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.marginSize, right: Dimensions.marginSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.paymentMethod,
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Dimensions.radius,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.marginSize, right: Dimensions.marginSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.vouchers,
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Dimensions.radius,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.marginSize,
                  right: Dimensions.marginSize,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.supportRequest,
                      style: TextStyle(
                        fontSize: Dimensions.defaultTextSize,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
        ],
      ),
    );
  }

  Widget faqWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FAQ',
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.defaultTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: 4,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '0${(index + 1).toString()}. ',
                          style: CustomStyle.textStyle,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Rorem Ipsum is nosimplyrandom text',
                            style: CustomStyle.textStyle,
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: Dimensions.marginSize,
                          right: Dimensions.marginSize,
                          bottom: Dimensions.heightSize,
                        ),
                        child: ListTile(
                          title: Text(
                            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. ',
                            style: CustomStyle.textStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
