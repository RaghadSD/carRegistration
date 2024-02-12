import 'package:cloud_firestore/cloud_firestore.dart';

class carModel {
  String userId;
  String managerId;
  String carPlate;
  String phoneNumber;
  String MakerEn;
  String makerAr;
  Timestamp date;
  String statusAr;
  String statusEn;
  carModel({
    required this.userId,
    required this.managerId,
    required this.carPlate,
    required this.phoneNumber,
    required this.MakerEn,
    required this.makerAr,
    required this.date,
    required this.statusAr,
    required this.statusEn,
  });
}
