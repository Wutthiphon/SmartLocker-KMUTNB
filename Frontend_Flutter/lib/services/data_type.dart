import 'package:flutter/material.dart';

class AppMenuItem {
  final Icon icon;
  final String label;
  final Widget page;

  AppMenuItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}

class LoginUserData {
  final String username;
  final String password;

  LoginUserData({
    required this.username,
    required this.password,
  });
}

class RegisterUserData {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  RegisterUserData({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });
}

class RegisterVerifyOTP {
  final int userID;
  final String otpRef;
  final String otpCode;

  RegisterVerifyOTP({
    required this.userID,
    required this.otpRef,
    required this.otpCode,
  });
}

class UserData {
  final String email;
  final String firstname;
  final String lastname;

  UserData({
    required this.email,
    required this.firstname,
    required this.lastname,
  });
}

class EditUserPasswordData {
  final String oldPassword;
  final String newPassword;
  final String reNewPassword;

  EditUserPasswordData({
    required this.oldPassword,
    required this.newPassword,
    required this.reNewPassword,
  });
}

class EditUserProfiledData {
  final String firstname;
  final String lastname;

  EditUserProfiledData({
    required this.firstname,
    required this.lastname,
  });
}

class Locker {
  final int lockerID;
  final int lockerNumber;
  final bool isInUse;
  final String? passCode;
  final DateTime? reserveDate;
  final DateTime? endReserveDate;

  Locker({
    required this.lockerID,
    required this.lockerNumber,
    required this.isInUse,
    this.passCode,
    this.reserveDate,
    this.endReserveDate,
  });

  String getDateFormat(DateTime date) {
    return '${date.day}/${date.month}/${date.year + 543}';
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      lockerID: json['lockerID'],
      lockerNumber: json['lockerNumber'],
      isInUse: json['isInUse'],
      passCode: json['passCode'],
      reserveDate: json['reserveDate'] != null
          ? DateTime.parse(json['reserveDate'])
          : null,
      endReserveDate: json['endReserveDate'] != null
          ? DateTime.parse(json['endReserveDate'])
          : null,
    );
  }
}
