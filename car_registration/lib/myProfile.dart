import 'package:car_registration/SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _workerNameController = TextEditingController();
  TextEditingController _workshopNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  Future<void> _retrieveProfileData() async {
    print(_isEditing);
    try {
      //(FirebaseAuth.instance.currentUser!.uid
      final String userId = 'A'; // Replace with your user ID
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Workers')
              .where('userId', isEqualTo: userId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        _workerNameController.text = userData['name'];
        _workshopNameController.text = userData['workshopName'];
        _phoneNumberController.text = userData['phoneNumber'];
      }

      print(_isEditing);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving profile: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String userId = 'A'; // Replace with your user ID
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Workers')
              .where('userId', isEqualTo: userId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentReference<Map<String, dynamic>> userRef =
            querySnapshot.docs.first.reference;

        await userRef.update({
          'name': _workerNameController.text,
          'workshopName': _workshopNameController.text,
          'phoneNumber': _phoneNumberController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $error')),
      );
    } finally {
      setState(() {
        _toggleEdit();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveProfileData();
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

  void _deleteProfile() {
    setState(() async {
      //1- confirmation

      //2- delete
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          await user.delete();
          //3- replace each car has its id with his  manager id
          print('Account deleted successfully.');
          Navigator.pushReplacementNamed(context, '/SignIn');
        } catch (e) {
          print('Failed to delete account: $e');
        }
      } else {
        print('No user is currently signed in.');
      }
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

  void _submitPhone() {
    String? phoneNumber = _phoneNumberController.text;
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

  bool _showErrorName = false;
  String _errorMessageName = '';

  String? _validateName(String? value) {
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]{2,20}$');
    final RegExp symbolRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>0-9]');

    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2 || value.length > 20) {
      return 'The name should be 2-20 characters';
    }

    if (symbolRegex.hasMatch(value)) {
      return 'Invalid name format';
    }

    return null;
  }

  void _submitName() {
    String? name = _workerNameController.text;
    String? validationError = _validateName(name);
    print(name);
    setState(() {
      if (validationError != null) {
        _showErrorName = true; // Show the error message
        _errorMessageName = validationError;
        print(_errorMessageName);
      } else {
        _showErrorName = false; // Hide the error message
        _errorMessageName = '';
        print(_errorMessageName);
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
      body: _isLoading
          ? Center(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: button_color,
                  )))
          : ListView(
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
                                    txt_size: heightM * 0.55,
                                    txt_color: txt_color),
                                // validator: _validateCarPlate,
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove underline
                                ))
                            : Container(
                                alignment: AlignmentDirectional.center,
                                width: 380,
                                height: 55,
                                margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
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
                                        border: InputBorder
                                            .none, // Remove underline
                                        hintText: 'Enter your name',
                                        hintStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                158, 158, 158, 1),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )),
                        Container(
                            // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            margin: _showErrorName == true
                                ? EdgeInsets.fromLTRB(5, 0, 0, 5)
                                : EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Visibility(
                              visible: _showErrorName &&
                                  _errorMessageName.isNotEmpty,
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
                                        _errorMessageName,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )),
                            ))
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
                                    txt_size: heightM * 0.55,
                                    txt_color: txt_color),
                                // validator: _validateCarPlate,
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove underline
                                ))
                            : Container(
                                alignment: AlignmentDirectional.center,
                                width: 380,
                                height: 55,
                                margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
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
                                      textFieldController:
                                          _phoneNumberController,
                                      formatInput: true,

                                      textStyle: inputTextStyle(
                                          txt_size: heightM * 0.55,
                                          txt_color: txt_color),
                                      maxLength: 9,
                                      selectorConfig: SelectorConfig(
                                        useEmoji: true,
                                        selectorType:
                                            PhoneInputSelectorType.DIALOG,
                                      ),
                                      initialValue: PhoneNumber(
                                          isoCode: 'SA', dialCode: '+966'),
                                      onInputChanged: _onPhoneNumberChanged,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
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
                                            color: Color.fromRGBO(
                                                158, 158, 158, 1),
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
                            margin: _showErrorPhone == true
                                ? EdgeInsets.fromLTRB(5, 0, 0, 5)
                                : EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Visibility(
                              visible: _showErrorPhone &&
                                  _errorMessagePhone.isNotEmpty,
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
                                        _errorMessagePhone,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )),
                            ))
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
                        onPressed: () {
                          if (_isEditing) {
                            _submitName();
                            _submitPhone();
                            if (!_showErrorName && !_showErrorPhone) {
                              print("nothing");
                              _updateProfile();
                            } else {
                              print("there is an error");
                            }
                          } else {
                            _toggleEdit();
                          }
                        },
                        child: Text(_isEditing ? 'Save' : 'Update Profile',
                            textAlign: TextAlign.center,
                            style: ourTextStyle(
                                txt_color: Colors.white,
                                txt_size: heightM * 0.6)),
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
                        color:
                            Colors.transparent, //Colors.cyan.withOpacity(0.5),
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
                                  txt_color: Colors.white,
                                  txt_size: heightM * 0.6)),
                        ),
                      ),
                    ),
                  ),
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
