import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:serenity/dialog/loading_dialog.dart';
import 'package:serenity/dialog/message_dialog.dart';
import 'package:serenity/exceptions/client_exception.dart';
import 'package:serenity/exceptions/server_exception.dart';
import 'package:serenity/screens/auth/signin_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  Future _sendCodeRequest(BuildContext context) async {
    // Show Loading Dialog
    _showLoadingDialog(context);

    var response, body;
    try {
      var data = {
        'email': emailController.text,
        'app': 'patient',
      };

      response = await CallApi().postData(data, '/password/forgot');
      body = json.decode(response.body);

      if (response.statusCode == 200) {
        // Pop the Loading Dialog
        Navigator.of(context).pop();
        // Show the Success Dialog
        _showSuccessDialog(
          context,
          'The code has been sent successfully. Please check your email',
        );
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
      // Pop the Loading dialog
      Navigator.of(context).pop();
      // Show error message
      _showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackWidget(
              name: Strings.forgotPassword,
              active: true,
            ),
            bodyWidget(context)
          ],
        ),
      ),
    );
  }

  Widget bodyWidget(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.marginSize,
          right: Dimensions.marginSize,
        ),
        child: Container(
          height: height * 0.4,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              Dimensions.radius * 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.marginSize,
              right: Dimensions.marginSize,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                headingWidget(context),
                inputFieldWidget(context),
                const SizedBox(height: Dimensions.heightSize * 2),
                sendCodeButtonWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headingWidget(BuildContext context) {
    return Text(
      Strings.forgotPassword,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.extraLargeTextSize,
      ),
    );
  }

  Widget inputFieldWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleData(Strings.email),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: Strings.demoEmail,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                labelStyle: CustomStyle.textStyle,
                filled: true,
                fillColor: Colors.white,
                hintStyle: CustomStyle.textStyle,
                focusedBorder: CustomStyle.focusBorder,
                enabledBorder: CustomStyle.focusErrorBorder,
                focusedErrorBorder: CustomStyle.focusErrorBorder,
                errorBorder: CustomStyle.focusErrorBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendCodeButtonWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: Dimensions.buttonHeight,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.radius),
          ),
        ),
        child: Center(
          child: Text(
            Strings.sendCode.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.largeTextSize,
            ),
          ),
        ),
      ),
      onTap: () {
        if (formKey.currentState!.validate()) {
          _sendCodeRequest(context);
        }
      },
    );
  }

  _titleData(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Dimensions.heightSize * 0.5,
        top: Dimensions.heightSize,
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
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
            img: 'error.png',
            buttonName: Strings.ok,
          ),
        )) ??
        false;
  }

  Future<bool> _showSuccessDialog(BuildContext context, message) async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => MessageDialog(
            title: "Success",
            subTitle: message,
            action: true,
            moved: SignInScreen(),
            img: 'tik.png',
            buttonName: Strings.ok,
          ),
        )) ??
        false;
  }
}
