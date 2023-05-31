import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serenity/exceptions/client_exception.dart';
import 'package:serenity/exceptions/server_exception.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/utils/zegocloud/zego_cloud.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatefulWidget {
  final callId;

  const VideoCallScreen({
    super.key,
    required this.callId,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  ZegoUIKitPrebuiltCallController zegoController =
      ZegoUIKitPrebuiltCallController();

  var user;

  bool _isLoading = true;
  bool _isLoaded = false;
  bool _isBlurred = true;

  @override
  void initState() {
    _loadUserDataFromDevice();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _publishToTopic(isBlurred) async {
    try {
      // ..
      var data = {
        'video_id': widget.callId.toString(),
        'blurred': isBlurred,
      };

      var response = await CallApi().postDataWithToken(data, '/blur');
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Blurred successfully');
        }
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
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future _loadUserDataFromDevice() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      user = jsonDecode(localStorage.getString('user')!);
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
                name: Strings.videoWithDoctor,
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
            child: _buildVideoCallWidget(),
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

  Widget _buildVideoCallWidget() {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId,
      appSign: ZegoCloudConfig.appSign,
      callID: widget.callId.toString(),
      userID: user['id'].toString(),
      userName: user['name'].toString(),
      config: ZegoUIKitPrebuiltCallConfig(
        onOnlySelfInRoom: (context) {
          Navigator.pop(context);
        },
        bottomMenuBarConfig: ZegoBottomMenuBarConfig(
          maxCount: 5,
          extendButtons: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(60, 60),
                shape: const CircleBorder(),
                backgroundColor: controlBarButtonCheckedBackgroundColor,
              ),
              onPressed: () {
                setState(() {
                  _isBlurred = !_isBlurred;
                  _publishToTopic(_isBlurred);
                });
              },
              child: _isBlurred
                  ? const Icon(Icons.blur_off_rounded)
                  : const Icon(Icons.blur_on_rounded),
            ),
          ],
          buttons: [
            ZegoMenuBarButtonName.toggleMicrophoneButton,
            ZegoMenuBarButtonName.toggleCameraButton,
            ZegoMenuBarButtonName.hangUpButton,
            ZegoMenuBarButtonName.switchAudioOutputButton,
            ZegoMenuBarButtonName.switchCameraButton,
          ],
        ),
      ),
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
            'Error in setup the video call',
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
