import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../http_service.dart';
import '../data_type.dart';

final String apiURL = "${dotenv.env['API_URL']}/auth";

class HttpAuthAPIService {
  Future login(LoginUserData loginUserData) async {
    return APIService(
      url: "$apiURL/user-login",
      method: 'POST',
      data: {
        "email": loginUserData.username,
        "password": loginUserData.password,
      },
    ).fetch();
  }

  Future register(RegisterUserData registerUserData) async {
    return APIService(
      url: "$apiURL/user-register",
      method: 'POST',
      data: {
        "email": registerUserData.email,
        "password": registerUserData.password,
        "firstname": registerUserData.firstname,
        "lastname": registerUserData.lastname,
      },
    ).fetch();
  }

  Future registerVerifyOTP(RegisterVerifyOTP verifyOTPData) async {
    return APIService(
      url: "$apiURL/verify-otp",
      method: 'POST',
      data: {
        "user_id": verifyOTPData.userID,
        "ref": verifyOTPData.otpRef,
        "otp": verifyOTPData.otpCode,
      },
    ).fetch();
  }

  Future userChangePassword(EditUserPasswordData editUserPasswordData) async {
    return APIService(
      url: "$apiURL/update-password",
      method: 'POST',
      data: {
        "oldpassword": editUserPasswordData.oldPassword,
        "newpassword": editUserPasswordData.newPassword,
      },
    ).fetch();
  }

  Future userEditProfile(EditUserProfiledData editUserProfiledData) async {
    return APIService(
      url: "$apiURL/update-user",
      method: 'POST',
      data: {
        "firstname": editUserProfiledData.firstname,
        "lastname": editUserProfiledData.lastname,
      },
    ).fetch();
  }
}
