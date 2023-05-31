import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CircularProgressIndicator(
              color: Colors.blue,
              backgroundColor: Colors.grey,
            ),
            Text(
              'Loading ...',
              style: TextStyle(
                  fontSize: Dimensions.extraLargeTextSize,
                  color: CustomColor.primaryColor,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
