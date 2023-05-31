import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/utils/zegocloud/zego_cloud.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCallScreen extends StatefulWidget {
  final callId;

  const AudioCallScreen({
    super.key,
    required this.callId,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  var user;
  bool _isLoading = true;
  bool _isLoaded = false;

  @override
  void initState() {
    _loadUserDataFromDevice();
    super.initState();
  }

  Future _loadUserDataFromDevice() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      user = jsonDecode(localStorage.get('user').toString());
      setState(() {
        _isLoaded = true;
      });
    } catch (e) {
      // ...
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                name: Strings.audioWithDoctor,
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
    if (_isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ),
      );
    } else {
      if (_isLoaded) {
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
            child: _buildAudioCallWidget(),
          ),
        );
      } else {
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
            child: _buildErrorInLoadWidget(),
          ),
        );
      }
    }
  }

  Widget _buildAudioCallWidget() {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId,
      appSign: ZegoCloudConfig.appSign,
      callID: widget.callId.toString(),
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..onOnlySelfInRoom = (context) => Navigator.pop(context),
      userID: user['id'].toString(),
      userName: user['name'].toString(),
    );
  }

  Widget _buildErrorInLoadWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/images/error.png',
            height: 80,
            width: 80,
          ),
          Text(
            'Error in setup the audio call',
            style: TextStyle(
              fontSize: Dimensions.largeTextSize,
              color: CustomColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'You can try again by click the button below and join again.',
            style: TextStyle(
              fontSize: Dimensions.largeTextSize,
              color: CustomColor.primaryColor,
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
                  Radius.circular(Dimensions.radius),
                ),
              ),
              child: Center(
                child: Text(
                  'back'.toUpperCase(),
                  style: TextStyle(
                    fontSize: Dimensions.extraLargeTextSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
