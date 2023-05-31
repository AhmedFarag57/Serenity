import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:serenity/screens/audio_call_screen.dart';
import 'package:serenity/screens/video_call_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/laravel_echo/laravel_echo.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingScreen extends StatefulWidget {
  var appointmentId;
  var chatId;

  MessagingScreen({
    super.key,
    this.appointmentId,
    this.chatId,
  });

  @override
  State<MessagingScreen> createState() =>
      _MessagingScreenState(appointmentId, chatId);
}

class _MessagingScreenState extends State<MessagingScreen> {
  TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var appointmentId;
  var chatId;
  var messages;
  var user;
  var userId;
  var response;
  var body;

  bool _isLoading = true;
  bool _isSending = false;

  _MessagingScreenState(var id, var chatId) {
    this.appointmentId = id;
    this.chatId = chatId;
  }

  @override
  void initState() {
    // ..
    _listenChatChannel();

    // ...
    _loadData();

    super.initState();
  }

  Future _loadData() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      user = jsonDecode(localStorage.get('user').toString());
      userId = user['id'];

      /**
       * Load Messages of chat
       */
      response = await CallApi().getDataWithToken(
        '/appointments/chat/messages?appointment_id=' +
            appointmentId.toString() +
            '&page=1',
      );
      if (response.statusCode == 200) {
        body = jsonDecode(response.body);
        messages = body['data'];
        setState(() => _isLoading = false);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      // ..
      setState(() => _isLoading = false);
    }
  }

  Future _sendMessageRequest() async {
    try {
      setState(() {
        _isSending = true;
      });

      var data = {
        'chat_id': chatId,
        'message': messageController.text,
      };

      response = await CallApi().postDataWithToken(data, '/chat_message');

      if (response.statusCode == 200) {
        messageController.clear();
        body = jsonDecode(response.body);
        setState(() {
          messages.insert(0, body['data']);
          _isSending = false;
        });
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      // Handle the error
      print('error in send message');
    }
  }

  void _listenChatChannel() {
    LaravelEcho.instance.private('chat.$chatId').listen('.message.sent', (e) {
      if (e is PusherEvent) {
        if (e.data != null) {
          _handleNewMessage(jsonDecode(e.data!));
        }
      }
    }).error((err) {
      // ...
    });
  }

  void _leaveChatChannel() {
    try {
      LaravelEcho.instance.leave('chat.$chatId');
    } catch (err) {
      print(err);
    }
  }

  void _handleNewMessage(var data) {
    if (data['message']['user_id'].toString() != userId.toString()) {
      setState(() {
        messages.insert(0, data['message']);
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
                name: Strings.chatWithDoctor,
                active: true,
                onTap: () {
                  _leaveChatChannel();
                },
              ),
              bodyWidget(context),
              typeMessageWidget(context),
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
        child: ListView(
          children: [
            const SizedBox(height: Dimensions.heightSize),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 0.5,
                    ),
                  ),
                  child: GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AudioCallScreen(
                            callId: chatId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.widthSize),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 0.5,
                    ),
                  ),
                  child: GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.video_call,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoCallScreen(
                            callId: chatId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            detailsWidget(context),
          ],
        ),
      ),
    );
  }

  Widget detailsWidget(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: Dimensions.heightSize),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: Dimensions.heightSize),
        child: messagingWidget(context),
      );
    }
  }

  Widget messagingWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: messages.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: Dimensions.heightSize,
            ),
            child: messages[index]['user_id'] == userId
                ? _buildUserMessge(messages[index]['message'])
                : _buildOtherUserMessage(messages[index]['user']['name'],
                    messages[index]['message']),
          );
        },
      ),
    );
  }

  Column _buildUserMessge(message) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: Dimensions.marginSize,
            left: Dimensions.marginSize,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: CustomColor.greenLightColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.marginSize,
                  right: Dimensions.marginSize,
                  top: Dimensions.heightSize,
                  bottom: Dimensions.heightSize,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: CustomColor.greyColor,
                    fontSize: Dimensions.defaultTextSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: Dimensions.marginSize,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'seen message',
              style: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: Dimensions.extraSmallTextSize,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildOtherUserMessage(name, message) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/profile.png',
                  height: 20,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: CustomColor.redDarkColor,
                    fontSize: Dimensions.smallTextSize,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  '5:20pm',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.3),
                    fontSize: Dimensions.extraSmallTextSize,
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: Dimensions.marginSize,
            right: Dimensions.marginSize,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: CustomColor.yellowLightColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.marginSize,
                  right: Dimensions.marginSize,
                  top: Dimensions.heightSize,
                  bottom: Dimensions.heightSize,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: CustomColor.greyColor,
                    fontSize: Dimensions.defaultTextSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget typeMessageWidget(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.marginSize,
          right: Dimensions.marginSize,
        ),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimensions.marginSize),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: CustomColor.redDarkColor,
                      size: 20,
                    ),
                    Icon(
                      Icons.image,
                      color: CustomColor.redDarkColor,
                      size: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          style: CustomStyle.textStyle,
                          controller: messageController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Strings.typeSomething;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: Strings.typeMessage,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            labelStyle: CustomStyle.textStyle,
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: CustomStyle.textStyle,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (!_isSending) {
                      _sendMessageRequest();
                    }
                  }
                },
                child: _isSending
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 3,
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 21.0,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
