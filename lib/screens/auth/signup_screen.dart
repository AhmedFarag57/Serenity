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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _toggleVisibility = true;
  bool checkedValue = false;

  Future _signupRequest(BuildContext context) async {
    // Show Loading Dialog
    _showLoadingDialog(context);

    var response, body;
    try {
      var data = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'app': 'patient',
      };

      response = await CallApi().postData(data, '/register');
      body = json.decode(response.body);
      if (response.statusCode == 200) {
        // Pop the Loading Dialog
        Navigator.of(context).pop();
        // Show the Success Dialog
        _showSuccessDialog(context, 'User Created Successfully');
        // Go to Email verification screen
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => EmailVerificationScreen(
        //       emailAddress: emailController.text,
        //     ),
        //   ),
        // );
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
        backgroundColor: CustomColor.secondaryColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              BackWidget(
                name: Strings.createAnAccount,
                active: true,
              ),
              bodyWidget(context)
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
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
          height: height * 0.754,
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
                const SizedBox(height: Dimensions.heightSize * 2),
                inputFieldWidget(context),
                termsCheckBoxWidget(context),
                signUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headingWidget(BuildContext context) {
    return Text(
      Strings.createAnAccount,
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
          _titleData(Strings.name),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: nameController,
              keyboardType: TextInputType.name,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter your fake name',
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
          _titleData(Strings.password),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: passwordController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: Strings.typePassword,
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
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _toggleVisibility = !_toggleVisibility;
                    });
                  },
                  icon: _toggleVisibility
                      ? Icon(
                          Icons.visibility_off,
                          color: CustomColor.greyColor,
                        )
                      : Icon(
                          Icons.visibility,
                          color: CustomColor.greyColor,
                        ),
                ),
              ),
              obscureText: _toggleVisibility,
            ),
          ),
          _titleData(Strings.confirmPassword),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: confirmPasswordController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: Strings.typePassword,
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
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _toggleVisibility = !_toggleVisibility;
                    });
                  },
                  icon: _toggleVisibility
                      ? Icon(
                          Icons.visibility_off,
                          color: CustomColor.greyColor,
                        )
                      : Icon(
                          Icons.visibility,
                          color: CustomColor.greyColor,
                        ),
                ),
                hintStyle: CustomStyle.textStyle,
              ),
              obscureText: _toggleVisibility,
            ),
          ),
          const SizedBox(height: Dimensions.heightSize),
        ],
      ),
    );
  }

  Widget termsCheckBoxWidget(BuildContext context) {
    return CheckboxListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "I accept the ",
            style: TextStyle(
              color: Color(0xFF707070),
              fontSize: 12.0,
            ),
          ),
          GestureDetector(
            child: Text(
              "Terms and Conditions",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: CustomColor.blueColor,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              _showTermsConditions();
            },
          ),
        ],
      ),
      value: checkedValue,
      onChanged: (newValue) {
        setState(() {
          checkedValue = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget signUpButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: Dimensions.buttonHeight,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              Dimensions.radius,
            ),
          ),
        ),
        child: Center(
          child: Text(
            Strings.signUp.toUpperCase(),
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
          _signupRequest(context);
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

  Future<bool> _showTermsConditions() async {
    return (await showDialog(
          context: context,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: CustomColor.primaryColor,
            child: Stack(
              children: [
                Positioned(
                    top: -35.0,
                    left: -50.0,
                    child: Image.asset('assets/images/splash_logo.png')),
                Positioned(
                    right: -35.0,
                    bottom: -20.0,
                    child: Image.asset('assets/images/splash_logo.png')),
                Padding(
                  padding: const EdgeInsets.only(
                      top: Dimensions.defaultPaddingSize * 2,
                      bottom: Dimensions.defaultPaddingSize * 2),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: AlertDialog(
                        content: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 45,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Dimensions.heightSize * 2,
                                ),
                                Text(
                                  Strings.ourPolicyTerms,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: Dimensions.largeTextSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: Dimensions.heightSize),
                                Text(
                                  'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old',
                                  style: CustomStyle.textStyle,
                                ),
                                SizedBox(height: Dimensions.heightSize),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '•',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.accentColor,
                                          fontSize:
                                              Dimensions.extraLargeTextSize),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'simply random text. It has roots in a piece of classical Latin literature ',
                                        style: CustomStyle.textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.heightSize),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '•',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.accentColor,
                                          fontSize:
                                              Dimensions.extraLargeTextSize),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Distracted by the readable content of a page when looking at its layout.',
                                        style: CustomStyle.textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.heightSize),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '•',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.accentColor,
                                          fontSize:
                                              Dimensions.extraLargeTextSize),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Available, but the majority have suffered alteration',
                                        style: CustomStyle.textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.heightSize * 2,
                                ),
                                Text(
                                  'When do we contact information ?',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: Dimensions.largeTextSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: Dimensions.heightSize),
                                Text(
                                  'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old',
                                  style: CustomStyle.textStyle,
                                ),
                                SizedBox(
                                  height: Dimensions.heightSize * 2,
                                ),
                                Text(
                                  'Do we use cookies ?',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: Dimensions.largeTextSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: Dimensions.heightSize),
                                Text(
                                  'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old',
                                  style: CustomStyle.textStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 35.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                          color: CustomColor.secondaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Center(
                                        child: Text(
                                          Strings.decline,
                                          style: TextStyle(
                                              color: CustomColor.primaryColor,
                                              fontSize:
                                                  Dimensions.defaultTextSize,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 35.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                          color: CustomColor.primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Center(
                                        child: Text(
                                          Strings.agree,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  Dimensions.defaultTextSize,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        )) ??
        false;
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
            moved: SignUpScreen(),
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
