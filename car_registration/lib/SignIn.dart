// import 'package:cool_alert/cool_alert.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flag/flag_widget.dart';
// import 'package:flutter/gestures.dart';
import 'package:car_registration/navBar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:animate_do/animate_do.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  late PhoneNumber phonenum;
  bool _onEditing = true;
  String? _code;
  String phoneNumber = "";
  Color button_color = Color.fromARGB(255, 47, 163, 167);
  Color txt_color = Color.fromARGB(255, 75, 73, 74);
  bool _showError = false;
  String _errorMessage = '';
  TextEditingController phone = TextEditingController();

// Validator function
  String? _validatePhoneNumber(String? value) {
    // Perform your validation logic here

    // bool x = false;
    // if (value!.isEmpty || value == null || value.trim() == '') {
    //   return 'Please enter your phone number';
    // } else if (value.length > 9 || value.length < 9) {
    //   return 'Please enter 9 numbers';
    // }
    // else if (true) {
    //   bool flag = false;
    //   for (int i = 0; i < numbers.length; i++) {
    //     print(numbers[i]);
    //     if (numbers[i] == phoneNumber) {
    //       flag = true;
    //     }
    //   }
    //   if (flag == false) return 'You don\'t have an account, call to sign up';
    // }
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    } else if (value.length != 9) {
      return 'Please enter 9 numbers';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

// Function to handle changes in the input field
  void _onPhoneNumberChanged(PhoneNumber? phoneNumber) {
    if (phoneNumber != null) {
      String? updatedPhoneNumber = phoneNumber.phoneNumber;
      setState(() {
        _showError = false; // Hide the error message initially
      });
    }
  }

// Function to handle form submission
  void _submitForm() {
    // Get the phone number value from the IntlPhoneFieldController
    String? phoneNumber = phone.text;

    // Perform validation
    String? validationError = _validatePhoneNumber(phoneNumber);

    setState(() {
      if (validationError != null) {
        _showError = true; // Show the error message
        _errorMessage = validationError;
      } else {
        _showError = false; // Hide the error message
        _errorMessage = '';
        openSheet(context, 0, button_color, txt_color, 0);
      }
    });
  }

  // late QuerySnapshot<Map<String, dynamic>> res;
  List numbers = [];

  void initState() {
    super.initState();

    // getUsers();
  }

  // getUsers() async {
  //   // await new Future.delayed(const Duration(seconds: 2));
  //   res = await FirebaseFirestore.instance.collection('Users').get();
  //   print(res.docs.length);

  //   for (int i = 0; i < res.docs.length; i++) {
  //     setState(() {
  //       numbers.add(res.docs[i]['phoneNumber']);
  //     });
  //     print(numbers[i]);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color button_color = Color.fromARGB(255, 50, 173, 230);
    Color txt_color = Color.fromARGB(255, 75, 73, 74);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightM * 3,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 8.0, bottom: 0.0),
              child: Text(
                "Sign In",
                style: ourTextStyle(txt_size: heightM, txt_color: txt_color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 0.0, bottom: 8.0),
              child: Text(
                "Hi there! Nice to see you again",
                style: ourTextStyle(
                    txt_size: heightM * 0.7, txt_color: Colors.black45),
              ),
            ),
            Center(
              child: Image.network(
                  "https://my.messa.online/images_all/2022-login.gif",
                  height: heightM * 8.50,
                  fit: BoxFit.fill),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Phone Number",
                  style: ourTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.6),
                ),
              ),
            ),
            Container(
                alignment: AlignmentDirectional.center,
                width: 380,
                height: 55,
                margin: EdgeInsets.fromLTRB(23, 5, 5, 0),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withOpacity(0.13)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffeeeeee),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InternationalPhoneNumberInput(
                      ignoreBlank: false,
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      textFieldController: phone,
                      formatInput: true,
                      maxLength: 9,
                      selectorConfig: SelectorConfig(
                        useEmoji: true,
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      initialValue:
                          PhoneNumber(isoCode: 'SA', dialCode: '+966'),
                      onInputChanged: _onPhoneNumberChanged,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      cursorColor: Colors.black,
                      textStyle: inputTextStyle(
                          txt_size: heightM * 0.55, txt_color: txt_color),
                      inputDecoration: InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        hintText: '5X XXX XXXX',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(158, 158, 158, 1),
                            fontSize: 16),
                      ),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ],
                )),
            Container(
                // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                margin: _showError == true
                    ? EdgeInsets.fromLTRB(25, 0, 0, 10)
                    : EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Visibility(
                  visible: _showError && _errorMessage.isNotEmpty,
                  child: Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5),
                          Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )),
                )),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: heightM * 1.5,
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10.0), //12
                  color: Colors.transparent, //Colors.cyan.withOpacity(0.5),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    color: button_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    splashColor: button_color,
                    onPressed: _submitForm,
                    child: Text('Sign In',
                        textAlign: TextAlign.center,
                        style: ourTextStyle(
                            txt_color: Colors.white, txt_size: heightM * 0.6)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: heightM * 0.5,
            ),
          ],
        ),
      )),
    );
  }

  void openSheet(
      BuildContext context, heightM, button_color, txt_color, verificationId) {
    double heightM = MediaQuery.of(context).size.height / 30;

    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        context: context,
        elevation: 20,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'OTP Verification',
                        style: ourTextStyle(
                            txt_color: txt_color, txt_size: heightM * 0.7),
                      ),
                    )),
                SizedBox(
                  height: heightM * 0.5,
                ),
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        ' Enter the OTP you received to ${phoneNumber}',
                        style: ourTextStyle(
                            txt_color: txt_color, txt_size: heightM * 0.5),
                      ),
                    )),
                SizedBox(
                  height: heightM * 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: VerificationCode(
                    digitsOnly: true,
                    textStyle: ourTextStyle(
                        txt_color: txt_color, txt_size: heightM * 0.5),
                    keyboardType: TextInputType.number,
                    fullBorder: true,
                    underlineColor: button_color,
                    length: 6,
                    cursorColor: txt_color,
                    clearAll: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'clear all'.toUpperCase(),
                        style: ourTextStyle(
                            txt_color: txt_color, txt_size: heightM * 0.5),
                      ),
                    ),
                    onCompleted: (String value) {
                      setState(() {
                        _code = value;
                      });
                    },
                    onEditing: (bool value) {
                      setState(() {
                        _onEditing = value;
                      });
                      if (!_onEditing) FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                SizedBox(
                  height: heightM * 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: heightM * 1.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          // color: Color.fromARGB(0, 244, 67, 54),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Back',
                                textAlign: TextAlign.center,
                                style: ourTextStyle(
                                    txt_color: Colors.white,
                                    txt_size: heightM * 0.6)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: heightM * 1.9,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          color: Colors
                              .transparent, //Colors.cyan.withOpacity(0.5),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: button_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            // splashColor: button_color,
                            onPressed: () async {
                              // PhoneAuthCredential credential =
                              //     PhoneAuthProvider.credential(
                              //         verificationId: verificationId,
                              //         smsCode: _code!);
                              // try {
                              //   await FirebaseAuth.instance
                              //       .signInWithCredential(credential);
                              // } on FirebaseAuthException catch (error) {
                              //   Navigator.of(context).pop();
                              //   String Error = "";
                              //   print("e ${error}");

                              //   if (error
                              //       .toString()
                              //       .contains("does not exist")) {
                              //     CoolAlert.show(
                              //       context: context,
                              //       title: "No user correspond",
                              //       type: CoolAlertType.error,
                              //       text:
                              //           "User Not Exist! , Please Go to Sign Up Page",
                              //       confirmBtnColor: button_color,
                              //     );
                              //   } else if (error.toString().contains(
                              //       "The sms verification code used to create the phone auth credential is invalid")) {
                              //     CoolAlert.show(
                              //       context: context,
                              //       title: "Wrong OTP",
                              //       type: CoolAlertType.error,
                              //       text: "Invalid verification code",
                              //       confirmBtnColor: button_color,
                              //     );
                              //     Error = "Code Error !";
                              //   } else if (error.code ==
                              //       'invalid-verification-code') {
                              //     CoolAlert.show(
                              //       context: context,
                              //       title: "Wrong OTP",
                              //       type: CoolAlertType.error,
                              //       text: "Invalid verification code",
                              //       confirmBtnColor: button_color,
                              //     );
                              //     Error = "Wrong OTP entered";
                              //   }

                              //   print("ddd_222 ${error}");

                              //   // if (e.code == 'invalid-verification-code') {
                              //   //   CoolAlert.show(
                              //   //     context: context,
                              //   //     title: "",
                              //   //     type: CoolAlertType.error,
                              //   //     text: "Error",
                              //   //     confirmBtnColor: button_color,
                              //   //   );
                              //   // }
                              // }
                              // if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => navBar()),
                                  (Route<dynamic> route) => false);
                              // }
                            },
                            child: Text('Sign In',
                                textAlign: TextAlign.center,
                                style: ourTextStyle(
                                    txt_color: Colors.white,
                                    txt_size: heightM * 0.6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
              ],
            ),
          );
        });
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
  }

  TextStyle inputTextStyle(
      {required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.w500, fontSize: txt_size);
  }
}
