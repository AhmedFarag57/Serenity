import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';

class MessageDialog extends StatefulWidget {
  final String title, subTitle, buttonName, img;
  final bool action;
  final moved;
  const MessageDialog({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.buttonName,
    required this.action,
    this.moved,
  }) : super(key: key);

  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/' + widget.img,
              height: 80,
              width: 80,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: Dimensions.extraLargeTextSize,
                color: CustomColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.subTitle,
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
                    widget.buttonName.toUpperCase(),
                    style: TextStyle(
                      fontSize: Dimensions.extraLargeTextSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {
                if (widget.action) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => widget.moved,
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
