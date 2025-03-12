import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/storage/storage.dart';
import 'package:flutter_cs_locker_project/services/api/auth_api.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_text_form_filed.dart';
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';
import 'package:flutter_cs_locker_project/components/dialog/loading_dialog.dart';
import 'package:flutter_cs_locker_project/components/dialog/alert_dialog.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late Future<bool> _signInStatusFuture;
  late UserData userData;

  HttpAuthAPIService httpAuthAPIService = HttpAuthAPIService();

  var editProfileFormKey = GlobalKey<FormState>();
  final changePasswordData = UserEditProfileData(
    firstname: TextEditingController(),
    lastname: TextEditingController(),
  );
  bool isApiLoading = false;
  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _signInStatusFuture = checkSignInStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkSignInStatus() async {
    bool isSignIn = await Storage().getData('AUTH_TOKEN') != null;
    if (isSignIn) {
      Map<String, dynamic>? userDataString =
          (await Storage().getJsonData('AUTH_USER'));
      if (userDataString != null) {
        userData = UserData(
          email: userDataString['email'] ?? '',
          firstname: userDataString['firstname'] ?? '',
          lastname: userDataString['lastname'] ?? '',
        );

        changePasswordData.firstname.text = userData.firstname;
        changePasswordData.lastname.text = userData.lastname;
      }
    }

    return isSignIn;
  }

  void onSubmit() {
    setState(() {
      isError = false;
      errorMessage = '';
    });

    if (editProfileFormKey.currentState!.validate() && !isApiLoading) {
      if (changePasswordData.firstname.text == '' ||
          changePasswordData.lastname.text == '') {
        setState(() {
          isError = true;
          errorMessage = 'รหัสผ่านไม่ตรงกัน';
        });
        return;
      }

      showLoadingDialog(context);
      isApiLoading = true;

      httpAuthAPIService
          .userEditProfile(
        EditUserProfiledData(
          firstname: changePasswordData.firstname.text,
          lastname: changePasswordData.lastname.text,
        ),
      )
          .then(
        (res) {
          isApiLoading = false;
          hideLoadingDialog(context);
          if (res.containsKey('error') && !!res['error']) {
            setState(() {
              isError = true;
              errorMessage = res['message'];
            });
            return;
          }

          Storage().saveJsonData(
            'AUTH_USER',
            {
              'email': res['email'],
              'firstname': res['firstname'],
              'lastname': res['lastname'],
            },
          );
          showAlertDialog(
            context: context,
            title: "สำเร็จ",
            content: "แก้ไขโปรไฟล์สำเร็จ",
            alert_type: 'success',
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'แก้ไขโปรไฟล์',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 110, 132, 145),
                  Color.fromARGB(255, 59, 86, 102),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        body: FutureBuilder<bool>(
          future: _signInStatusFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: editProfileFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        inputLabel: 'ชื่อ',
                        inputHint: 'First Name',
                        controller: changePasswordData.firstname,
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกชื่อ';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        inputLabel: 'นามสกุล',
                        inputHint: 'Last Name',
                        controller: changePasswordData.lastname,
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกนามสกุล';
                          }
                          return null;
                        },
                      ),
                      if (isError)
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 30),
                      CustomElevatedButton(
                        label: 'บันทึก',
                        color: 'primary',
                        fullWidth: true,
                        rounded: true,
                        onPressed: onSubmit,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserEditProfileData {
  final TextEditingController firstname;
  final TextEditingController lastname;

  UserEditProfileData({
    required this.firstname,
    required this.lastname,
  });
}
