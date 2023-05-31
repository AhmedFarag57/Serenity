import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serenity/dialog/loading_dialog.dart';
import 'package:serenity/dialog/message_dialog.dart';
import 'package:serenity/exceptions/client_exception.dart';
import 'package:serenity/exceptions/server_exception.dart';
import 'package:serenity/screens/dashboard_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';

class AddPointsScreen extends StatefulWidget {
  const AddPointsScreen({super.key});

  @override
  State<AddPointsScreen> createState() => _AddPointsScreenState();
}

class _AddPointsScreenState extends State<AddPointsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController pointsController = TextEditingController();

  Future<void> _requestToAddPoints(BuildContext context) async {
    // Show the loading Dialog
    _showLoadingDialog(context);
    var response;
    try {
      var data = {
        'points': pointsController.text,
      };
      response = await CallApi().postDataWithToken(data, '/points');

      var body = json.decode(response.body);

      if (response.statusCode == 200) {
        // pop the Loading Diaolg
        Navigator.of(context).pop();
        // Show success message
        _showPaymentSuccessDialog();
      } else if (response.statusCode >= 400 && response.statusCode <= 499) {
        throw ClientException(
          '[${response.statusCode}] ' + body['message'].toString(),
        );
      } else if (response.statusCode >= 500 && response.statusCode <= 599) {
        throw ServerException(
          '[${response.statusCode}] ' + body['message'].toString(),
        );
      } else {
        throw Exception(
            'Please contact with the support team to fix this problem');
      }
    } catch (e) {
      // Pop the loading dialog
      Navigator.of(context).pop();
      // Show the error in Error dialog
      _showErrorDialog(context, e.toString());
    }
  }

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
              const BackWidget(
                name: 'Add Points',
                active: true,
              ),
              bodyWidget(context),
              buttonWidget(context),
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
        child: addPointsWidget(context),
      ),
    );
  }

  Widget addPointsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
        top: Dimensions.heightSize * 3,
      ),
      child: inputFieldWidget(context),
    );
  }

  Widget inputFieldWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.heightSize),
          Text(
            'The number of points',
            style: TextStyle(
              color: CustomColor.greyColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: Dimensions.heightSize * 0.5),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: pointsController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'points',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                labelStyle: CustomStyle.textStyle,
                focusedBorder: CustomStyle.focusBorder,
                enabledBorder: CustomStyle.focusErrorBorder,
                focusedErrorBorder: CustomStyle.focusErrorBorder,
                errorBorder: CustomStyle.focusErrorBorder,
                filled: true,
                fillColor: Colors.white,
                hintStyle: CustomStyle.textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(BuildContext context) {
    return Positioned(
      bottom: Dimensions.heightSize,
      left: Dimensions.marginSize * 2,
      right: Dimensions.marginSize * 2,
      child: GestureDetector(
        child: Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: CustomColor.primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(Dimensions.radius * 0.5),
            ),
          ),
          child: Center(
            child: Text(
              'request add points'.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.largeTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: () {
          if (formKey.currentState!.validate()) {
            _requestToAddPoints(context);
          }
        },
      ),
    );
  }

  Future<bool> _showLoadingDialog(BuildContext context) async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => LoadingDialog(),
        )) ??
        false;
  }

  Future<bool> _showErrorDialog(BuildContext context, message) async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => MessageDialog(
            title: "Error",
            subTitle: message,
            action: false,
            moved: DashboardScreen(),
            img: 'error.png',
            buttonName: Strings.ok,
          ),
        )) ??
        false;
  }

  Future<bool> _showPaymentSuccessDialog() async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/tik.png'),
                  Text(
                    Strings.successfullySendYourRequest,
                    style: TextStyle(
                      fontSize: Dimensions.extraLargeTextSize,
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Dimensions.radius,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          Strings.ok.toUpperCase(),
                          style: TextStyle(
                            fontSize: Dimensions.extraLargeTextSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        )) ??
        false;
  }
}
