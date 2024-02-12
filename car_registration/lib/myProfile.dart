import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class Profile {
  String workerName;
  String workshopName;
  String phoneNumber;

  Profile({
    required this.workerName,
    required this.workshopName,
    required this.phoneNumber,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  Profile _profile = Profile(
    workerName: 'John Doe',
    workshopName: 'ABC Workshop',
    phoneNumber: '1234567890',
  );

  TextEditingController _workerNameController = TextEditingController();
  TextEditingController _workshopNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _workerNameController.text = _profile.workerName;
    _workshopNameController.text = _profile.workshopName;
    _phoneNumberController.text = _profile.phoneNumber;
  }

  @override
  void dispose() {
    _workerNameController.dispose();
    _workshopNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _profile.workerName = _workerNameController.text;
        _profile.workshopName = _workshopNameController.text;
        _profile.phoneNumber = _phoneNumberController.text;
        _toggleEdit();
      });
    }
  }

  void _deleteProfile() {
    setState(() {
      _profile = Profile(
        workerName: 'John Doe',
        workshopName: 'ABC Workshop',
        phoneNumber: '1234567890',
      );
      _workerNameController.text = _profile.workerName;
      _workshopNameController.text = _profile.workshopName;
      _phoneNumberController.text = _profile.phoneNumber;
      _toggleEdit();
    });
  }

  bool _showErrorPhone = false;
  String _errorMessagePhone = '';
// Function to handle changes in the input field of the phone number
  void _onPhoneNumberChanged(PhoneNumber? phoneNumber) {
    if (phoneNumber != null) {
      String? updatedPhoneNumber = phoneNumber.phoneNumber;
      setState(() {
        _showErrorPhone = false; // Hide the error message initially
      });
    }
  }

  // Phone Validator function
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (value.length != 9) {
      return 'Please enter 9 numbers';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

// Function to handle phone submission
  void _submitPhone() {
    // Get the phone number value from the IntlPhoneFieldController
    String? phoneNumber = _phoneNumberController.text;

    // Perform validation
    String? validationError = _validatePhoneNumber(phoneNumber);

    setState(() {
      if (validationError != null) {
        _showErrorPhone = true; // Show the error message
        _errorMessagePhone = validationError;
      } else {
        _showErrorPhone = false; // Hide the error message
        _errorMessagePhone = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color button_color = Color.fromARGB(255, 50, 173, 230);
    Color txt_color = Color.fromARGB(255, 75, 73, 74);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.8),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.network(
                  "https://images.squarespace-cdn.com/content/v1/5b29245a2714e595994fc88c/1625790952709-JXRN18NTJJDM7BI4EA79/profile_pic.png",
                  fit: BoxFit.cover,
                  height: 150.0,
                  width: 150.0,
                )),

            // CircleAvatar(
            //   radius: 64,
            //   backgroundImage: AssetImage(),
            // ),
          ),
          SizedBox(height: 16.0),
          Form(
              key: GlobalKey<FormState>(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Worker Name",
                        style: ourTextStyle(
                            txt_color: _isEditing == false
                                ? Color.fromARGB(171, 75, 73, 74)
                                : txt_color,
                            txt_size: heightM * 0.55),
                      ),
                    ),
                  ),
                  _isEditing == false
                      ? TextFormField(
                          controller: _workerNameController,
                          enabled: false,
                          style: inputTextStyle(
                              txt_size: heightM * 0.55, txt_color: txt_color),
                          // validator: _validateCarPlate,
                          decoration: InputDecoration(
                            border: InputBorder.none, // Remove underline
                          ))
                      : Container(
                          alignment: AlignmentDirectional.center,
                          width: 380,
                          height: 55,
                          margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.13)),
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
                              TextFormField(
                                controller: _workerNameController,
                                enabled: _isEditing,
                                style: inputTextStyle(
                                    txt_size: heightM * 0.55,
                                    txt_color: txt_color),
                                // validator: _validateCarPlate,
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove underline
                                  hintText: 'Enter your name',
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(158, 158, 158, 1),
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ))

                  // TextFormField(
                  //     controller: _workerNameController,
                  //     enabled: _isEditing,
                  //     decoration: InputDecoration(),
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter a worker name.';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                ],
              )),
          SizedBox(height: 16.0),
          Form(
              key: GlobalKey<FormState>(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Workshop Name",
                        style: ourTextStyle(
                            txt_color: _isEditing == false
                                ? Color.fromARGB(171, 75, 73, 74)
                                : txt_color,
                            txt_size: heightM * 0.55),
                      ),
                    ),
                  ),
                  TextFormField(
                      controller: _workshopNameController,
                      enabled: false,
                      style: inputTextStyle(
                          txt_size: heightM * 0.55, txt_color: txt_color),
                      // validator: _validateCarPlate,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Remove underline
                      )),
                ],
              )),
          SizedBox(height: 16.0),
          Form(
              key: GlobalKey<FormState>(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Phone Number",
                        style: ourTextStyle(
                            txt_color: _isEditing == false
                                ? Color.fromARGB(171, 75, 73, 74)
                                : txt_color,
                            txt_size: heightM * 0.55),
                      ),
                    ),
                  ),
                  _isEditing == false
                      ? TextFormField(
                          controller: _phoneNumberController,
                          enabled: false,
                          style: inputTextStyle(
                              txt_size: heightM * 0.55, txt_color: txt_color),
                          // validator: _validateCarPlate,
                          decoration: InputDecoration(
                            border: InputBorder.none, // Remove underline
                          ))
                      : Container(
                          alignment: AlignmentDirectional.center,
                          width: 380,
                          height: 55,
                          margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.13)),
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
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                textFieldController: _phoneNumberController,
                                formatInput: true,

                                textStyle: inputTextStyle(
                                    txt_size: heightM * 0.55,
                                    txt_color: txt_color),
                                maxLength: 9,
                                selectorConfig: SelectorConfig(
                                  useEmoji: true,
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                initialValue: PhoneNumber(
                                    isoCode: 'SA', dialCode: '+966'),
                                onInputChanged: _onPhoneNumberChanged,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                cursorColor: Colors.black,

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
                          ))
                  // : Container(
                  //     alignment: AlignmentDirectional.center,
                  //     width: 380,
                  //     height: 55,
                  //     margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(8),
                  //       border: Border.all(
                  //           color: Colors.black.withOpacity(0.13)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Color(0xffeeeeee),
                  //           blurRadius: 10,
                  //           offset: Offset(0, 4),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         TextFormField(
                  //           controller: _phoneNumberController,
                  //           enabled: _isEditing,
                  //           style: inputTextStyle(
                  //               txt_size: heightM * 0.55,
                  //               txt_color: txt_color),
                  //           // validator: _validateCarPlate,
                  //           decoration: InputDecoration(
                  //             border: InputBorder.none, // Remove underline
                  //             hintText: 'Enter your name',
                  //             hintStyle: TextStyle(
                  //                 color: Color.fromRGBO(158, 158, 158, 1),
                  //                 fontSize: 16),
                  //           ),
                  //         ),
                  //       ],
                  //     ))

                  ,
                  // TextFormField(
                  //   controller: _phoneNumberController,
                  //   enabled: _isEditing,
                  //   keyboardType: TextInputType.phone,
                  //   decoration: InputDecoration(),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter a phone number.';
                  //     }
                  //     return null;
                  //   },
                  // ),
                ],
              )),
          SizedBox(
            height: heightM * 0.5,
          ),
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
                  onPressed: _isEditing ? _updateProfile : _toggleEdit,
                  // onPressed: () {
                  //   _deleteProfile;
                  //   _submitPhone();

                  //   // phone.clear();
                  //   // carPalte.clear();
                  //   // carMaker.clear();
                  // },
                  child: Text(_isEditing ? 'Save' : 'Update Profile',
                      textAlign: TextAlign.center,
                      style: ourTextStyle(
                          txt_color: Colors.white, txt_size: heightM * 0.6)),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.0),
          if (_isEditing)
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
                    color: Color.fromARGB(255, 185, 35, 21),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    splashColor: button_color,
                    onPressed: _deleteProfile,
                    child: Text("Delete Profile",
                        textAlign: TextAlign.center,
                        style: ourTextStyle(
                            txt_color: Colors.white, txt_size: heightM * 0.6)),
                  ),
                ),
              ),
            ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ElevatedButton(
          //       onPressed: _isEditing ? _updateProfile : _toggleEdit,
          //       child: Text(_isEditing ? 'Save' : 'Edit'),
          //     ),
          //     if (_isEditing)
          //       Center(
          //         child: Container(
          //           width: MediaQuery.of(context).size.width * 0.9,
          //           height: heightM * 1.5,
          //           child: Material(
          //             elevation: 10.0,
          //             borderRadius: BorderRadius.circular(10.0), //12
          //             color: Colors.transparent, //Colors.cyan.withOpacity(0.5),
          //             child: MaterialButton(
          //               minWidth: MediaQuery.of(context).size.width,
          //               color: button_color,
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10.0)),
          //               splashColor: button_color,
          //               onPressed: _deleteProfile,
          //               child: Text("Delete Profile",
          //                   textAlign: TextAlign.center,
          //                   style: ourTextStyle(
          //                       txt_color: Colors.white,
          //                       txt_size: heightM * 0.6)),
          //             ),
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ],
      ),
    );
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
