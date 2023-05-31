import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:weekday_selector/weekday_selector.dart';

class SetPillReminderScreen extends StatefulWidget {
  const SetPillReminderScreen({super.key});

  @override
  State<SetPillReminderScreen> createState() => _SetPillReminderScreenState();
}

enum SingingCharacter { after, before }

class _SetPillReminderScreenState extends State<SetPillReminderScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final values = List.filled(7, false);
  SingingCharacter _character = SingingCharacter.after;

  int timeCount = 1;

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
                name: Strings.pillReminder,
                active: true,
              ),
              bodyWidget(context),
              buttonWidget(context)
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
        child: inputFiledWidget(context),
      ),
    );
  }

  Widget inputFiledWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Dimensions.heightSize * 2,
          left: Dimensions.marginSize,
          right: Dimensions.marginSize,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleData(Strings.nameOfPill),
            Material(
              elevation: 10.0,
              shadowColor: CustomColor.secondaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radius),
              child: TextFormField(
                style: CustomStyle.textStyle,
                controller: nameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Strings.pleaseFillOutTheField;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: Strings.name,
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
            _titleData(Strings.selectDay),
            selectWeekday(context),
            const SizedBox(
              height: Dimensions.heightSize,
            ),
            selectTimeWidget(context),
            setEatingTimeWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _titleData(String title) {
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

  Widget selectWeekday(BuildContext context) {
    return WeekdaySelector(
      selectedFillColor: CustomColor.primaryColor,
      fillColor: CustomColor.secondaryColor,
      onChanged: (v) {
        setState(() {
          values[v % 7] = !values[v % 7];
        });
      },
      values: values,
    );
  }

  Widget selectTimeWidget(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: timeCount,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Material(
                    elevation: 10.0,
                    shadowColor: CustomColor.secondaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                    child: Container(
                      height: Dimensions.buttonHeight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: Dimensions.marginSize,
                          right: Dimensions.marginSize,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('9:00am'),
                            Icon(Icons.watch_later_outlined),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Dimensions.widthSize,
                ),
                index == 0
                    ? Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            height: Dimensions.buttonHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius,
                              ),
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (timeCount < 3) {
                                timeCount++;
                              }
                            });
                          },
                        ),
                      )
                    : Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            height: Dimensions.buttonHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius,
                              ),
                              color: Colors.red,
                            ),
                            child: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            setState(
                              () {
                                if (timeCount > 1) {
                                  timeCount--;
                                }
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget setEatingTimeWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<SingingCharacter>(
          title: const Text('After Eat'),
          value: SingingCharacter.after,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value!;
            });
          },
        ),
        RadioListTile<SingingCharacter>(
          title: const Text('Before Eat'),
          value: SingingCharacter.before,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value!;
            });
          },
        ),
      ],
    );
  }

  Widget buttonWidget(BuildContext context) {
    return Positioned(
      bottom: Dimensions.heightSize * 2,
      left: Dimensions.marginSize * 2,
      right: Dimensions.marginSize * 2,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                height: Dimensions.buttonHeight,
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
                    Strings.done.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.largeTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          const SizedBox(
            width: Dimensions.widthSize,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                height: Dimensions.buttonHeight,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Dimensions.radius * 0.5,
                      ),
                    ),
                    border: Border.all(color: Colors.black.withOpacity(0.7))),
                child: Center(
                  child: Text(
                    Strings.close.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: Dimensions.largeTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
