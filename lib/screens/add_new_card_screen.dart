import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String expDate = 'exp date';
  List<String> typeList = ['Master Card', 'Visa Card', 'Credit Card'];
  String? selectedCard;

  @override
  void initState() {
    super.initState();
    selectedCard = typeList[0].toString();
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
                name: Strings.addNewCard,
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
        child: addNewCardWidget(context),
      ),
    );
  }

  Widget addNewCardWidget(BuildContext context) {
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
          Text(
            Strings.cardType,
            style: CustomStyle.textStyle,
          ),
          const SizedBox(height: Dimensions.heightSize * 0.5),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: Container(
              height: 50.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.radius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.marginSize * 0.5,
                  right: Dimensions.marginSize * 0.5,
                ),
                child: DropdownButton(
                  isExpanded: true,
                  underline: Container(),
                  hint: Text(
                    selectedCard!,
                    style: CustomStyle.textStyle,
                  ),
                  value: selectedCard,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCard = newValue;
                    });
                  },
                  items: typeList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: CustomStyle.textStyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.heightSize),
          Text(
            Strings.cardNumber,
            style: CustomStyle.textStyle,
          ),
          const SizedBox(height: Dimensions.heightSize * 0.5),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: numberController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: Strings.demoCardNumber,
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
          const SizedBox(height: Dimensions.heightSize),
          Text(
            Strings.cardHolderName,
            style: CustomStyle.textStyle,
          ),
          const SizedBox(height: Dimensions.heightSize * 0.5),
          Material(
            elevation: 10.0,
            shadowColor: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius),
            child: TextFormField(
              style: CustomStyle.textStyle,
              controller: nameController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: Strings.demoHolderName,
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
          const SizedBox(height: Dimensions.heightSize),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.expirationDate,
                      style: CustomStyle.textStyle,
                    ),
                    const SizedBox(height: Dimensions.heightSize * 0.5),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Material(
                        elevation: 10.0,
                        shadowColor: CustomColor.secondaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius),
                        child: Container(
                          height: 48.0,
                          width: 200,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                expDate,
                                style: CustomStyle.textStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.heightSize),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.cvv,
                      style: CustomStyle.textStyle,
                    ),
                    const SizedBox(height: Dimensions.heightSize * 0.5),
                    Material(
                      elevation: 10.0,
                      shadowColor: CustomColor.secondaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius),
                      child: TextFormField(
                        style: CustomStyle.textStyle,
                        controller: cvvController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return Strings.pleaseFillOutTheField;
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: '123',
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
                    const SizedBox(height: Dimensions.heightSize),
                  ],
                ),
              ),
            ],
          )
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
              Strings.saveCard.toUpperCase(),
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(
        () {
          selectedDate = picked;
          expDate = "${selectedDate.toLocal()}".split(' ')[0];
        },
      );
    }
  }
}
