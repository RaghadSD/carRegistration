import 'package:car_registration/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:progress_bar_steppers/steppers.dart';

class addVehicle extends StatefulWidget {
  const addVehicle({super.key});

  @override
  State<addVehicle> createState() => _addVehicle();
}

class _addVehicle extends State<addVehicle> {
  GlobalKey<DropdownSearchState<String>> dropdownKey =
      GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController carPalte = TextEditingController();
  TextEditingController carMaker = TextEditingController();
  bool _showErrorPhone = false;
  String _errorMessagePhone = '';
  final _firestore = FirebaseFirestore.instance;

  var currentStep = 1;
  var totalSteps = 0;

  final stepsData = [
    StepperData(
      label: 'Receiving vehicle',
    ),
    StepperData(
      label: 'Confirming receipt',
    ),
    StepperData(
      label: 'Delivery of vehicle',
    ),
    StepperData(
      label: 'Confirming delivery',
    ),
  ];

  @override
  void initState() {
    totalSteps = stepsData.length;
    super.initState();
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

// Function to handle changes in the input field of the phone number
  void _onPhoneNumberChanged(PhoneNumber? phoneNumber) {
    if (phoneNumber != null) {
      String? updatedPhoneNumber = phoneNumber.phoneNumber;
      setState(() {
        _showErrorPhone = false; // Hide the error message initially
      });
    }
  }

// Function to handle phone submission
  void _submitPhone() {
    // Get the phone number value from the IntlPhoneFieldController
    String? phoneNumber = phone.text;

    // Perform validation
    String? validationError = _validatePhoneNumber(phoneNumber);

    setState(() {
      if (validationError != null) {
        _showErrorPhone = true; // Show the error message
        _errorMessagePhone = validationError;
        print("_showErrorPhone");
        print(_showErrorPhone);
      } else {
        _showErrorPhone = false; // Hide the error message
        _errorMessagePhone = '';
        print("_showErrorPhone");
        print(_showErrorPhone);
      }
    });
  }

  bool _showErrorPlate = false;
  String _errorMessagePlate = '';

  String? _validateCarPlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Car plate is required';
    }
    final pattern = r'^[A-Za-z]{1,3}\d{1,4}$|^\d{1,4}[A-Za-z]{1,3}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Invalid car plate format';
    }

    return null;
  }

  void _submitPlate() {
    String? plate = carPalte.text;
    String? validationError = _validateCarPlate(plate);

    setState(() {
      if (validationError != null) {
        _showErrorPlate = true; // Show the error message
        _errorMessagePlate = validationError;
        print("_showErrorPlate");
        print(_showErrorPlate);
      } else {
        _showErrorPlate = false; // Hide the error message
        _errorMessagePlate = '';
        print("_showErrorPlate");
        print(_showErrorPlate);
      }
    });
  }

  bool _showErrorMaker = false;
  String _errorMessageMaker = '';

  String? _validateCarMaker(String? value) {
    if (value == null || value.isEmpty) {
      return 'Car maker is required';
    }
    return null;
  }

  void _submitMaker() {
    String? maker = carMaker.text;
    String? validationError = _validateCarMaker(maker);

    setState(() {
      if (validationError != null) {
        _showErrorMaker = true; // Show the error message
        _errorMessageMaker = validationError;
        print("_showErrorMaker");
        print(_showErrorMaker);
      } else {
        _showErrorMaker = false; // Hide the error message
        _errorMessageMaker = '';
        print("_showErrorMaker");
        print(_showErrorMaker);
      }
    });
  }

  List<String> carMakers = [
    'Acura',
    'Alfa Romeo',
    'Aston Martin',
    'Audi',
    'Bentley',
    'BMW',
    'Bugatti',
    'Buick',
    'Cadillac',
    'Chevrolet',
    'Chrysler',
    'Citroën',
    'Dacia',
    'Daewoo',
    'Daihatsu',
    'Dodge',
    'Ferrari',
    'Fiat',
    'Ford',
    'Geely',
    'Genesis',
    'GMC',
    'Honda',
    'Hummer',
    'Hyundai',
    'Infiniti',
    'Isuzu',
    'Jaguar',
    'Jeep',
    'Kia',
    'Koenigsegg',
    'Lamborghini',
    'Lancia',
    'Land Rover',
    'Lexus',
    'Lincoln',
    'Lotus',
    'Maserati',
    'Maybach',
    'Mazda',
    'McLaren',
    'Mercedes-Benz',
    'Mercury',
    'MG',
    'Mini',
    'Mitsubishi',
    'Nissan',
    'Oldsmobile',
    'Opel',
    'Pagani',
    'Peugeot',
    'Plymouth',
    'Polestar',
    'Pontiac',
    'Porsche',
    'Ram',
    'Renault',
    'Rolls-Royce',
    'Saab',
    'Saturn',
    'Scion',
    'Seat',
    'Škoda',
    'Smart',
    'SsangYong',
    'Subaru',
    'Suzuki',
    'Tesla',
    'Toyota',
    'Vauxhall',
    'Volkswagen',
    'Volvo',
    'Wiesmann',
  ];

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
              padding: const EdgeInsets.only(right: 8.0, left: 20.0),
              child: Text(
                "Add Vehicle",
                style:
                    ourTextStyle(txt_size: heightM * 0.8, txt_color: txt_color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 30.0, top: 0.0, bottom: 8.0),
              child: Text(
                "Workshop workers, effortlessly register customer cars for seamless updates",
                style: ourTextStyle(
                    txt_size: heightM * 0.5, txt_color: Colors.black45),
              ),
            ),

            Steppers(
              direction: StepperDirection.horizontal,
              labels: stepsData,
              currentStep: currentStep,
              stepBarStyle: StepperStyle(
                activeColor: button_color,
                maxLineLabel: 2,
                // inactiveColor: StepperColors.ink200s
              ),
            ),

            SizedBox(
              height: heightM * 0.25,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Car Plate (English)",
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
                    TextFormField(
                      controller: carPalte,
                      style: inputTextStyle(
                          txt_size: heightM * 0.55, txt_color: txt_color),
                      // validator: _validateCarPlate,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Remove underline
                        hintText: 'Enter car plate (e.g., ABC123)',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(158, 158, 158, 1),
                            fontSize: 16),
                      ),
                    ),
                  ],
                )),

            Container(
                // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                margin: _showErrorPlate == true
                    ? EdgeInsets.fromLTRB(25, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Visibility(
                  visible: _showErrorPlate && _errorMessagePlate.isNotEmpty,
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
                            _errorMessagePlate,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )),
                )),
            SizedBox(
              height: heightM * 0.25,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Car Maker",
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
                    DropdownSearch<String>(
                      key: dropdownKey,
                      popupProps: PopupProps.menu(
                        menuProps: MenuProps(),
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: button_color,
                              ),
                            ),
                            labelStyle: inputTextStyle(
                                txt_color: txt_color, txt_size: heightM * 0.45),
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        scrollbarProps: ScrollbarProps(
                          thickness: 5,
                        ),
                        listViewProps: ListViewProps(
                          padding: EdgeInsets.all(0),
                        ),
                        searchDelay: Duration(milliseconds: 200),
                        showSearchBox: true,
                      ),
                      items: carMakers,
                      onChanged: (String? newValue) {
                        setState(() {
                          carMaker.text = newValue!;
                        });
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle: inputTextStyle(
                            txt_size: heightM * 0.55, txt_color: txt_color),
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none, // Remove underline
                          hintText: 'Select car maker',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(158, 158, 158, 1),
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
                // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                margin: _showErrorMaker == true
                    ? EdgeInsets.fromLTRB(25, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Visibility(
                  visible: _showErrorMaker && _errorMessageMaker.isNotEmpty,
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
                            _errorMessageMaker,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )),
                )),
            SizedBox(
              height: heightM * 0.25,
            ),
            ///////////////////////////////////////////////////
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

                      textStyle: inputTextStyle(
                          txt_size: heightM * 0.55, txt_color: txt_color),
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
                margin: _showErrorPhone == true
                    ? EdgeInsets.fromLTRB(25, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Visibility(
                  visible: _showErrorPhone && _errorMessagePhone.isNotEmpty,
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
                      print(carPalte.text);
                      print(carMaker.text);
                      print(phone.text);

                      _submitPlate();
                      _submitMaker();
                      _submitPhone();
                      if (!_showErrorMaker &&
                          !_showErrorPhone &&
                          !_showErrorPlate) {
                        final docData = {
                          "userId": "",
                          "managerId": "",
                          "carPlate": carPalte.text,
                          "phoneNumber": phone.text,
                          "MakerEn": carMaker.text,
                          "makerAr": "",
                          "date": Timestamp.now(),
                          "statusAr": "تم استلام المركبة",
                          "statusEn": "Receiving Vehicle",
                        };
                        _firestore.collection("Cars").add(docData).then(
                            (documentSnapshot) => print(
                                "Added Data with ID: ${documentSnapshot.id}"));
                        phone.clear();
                        carPalte.clear();
                        carMaker.clear();
                        dropdownKey.currentState?.clear();
                      } else
                        print("there is error");
                    },
                    child: Text('Add Vehicle',
                        textAlign: TextAlign.center,
                        style: ourTextStyle(
                            txt_color: Colors.white, txt_size: heightM * 0.6)),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
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
