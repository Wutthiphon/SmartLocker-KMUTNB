import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/api/auth_api.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_text_form_filed.dart';
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';
import 'package:flutter_cs_locker_project/components/dialog/loading_dialog.dart';

// Pages
import 'package:flutter_cs_locker_project/pages/auth/signup_otp_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  HttpAuthAPIService httpAuthAPIService = HttpAuthAPIService();

  bool isKeyboardOpen = false;

  var registerFormKey = GlobalKey<FormState>();
  final signupUserData = UserRegisterData(
    firstname: TextEditingController(),
    lastname: TextEditingController(),
    email: TextEditingController(),
    password: TextEditingController(),
    repassword: TextEditingController(),
  );
  bool isApiLoading = false;
  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    signupUserData.firstname.dispose();
    signupUserData.lastname.dispose();
    signupUserData.email.dispose();
    signupUserData.password.dispose();
    signupUserData.repassword.dispose();
    super.dispose();
  }

  void onSignUp() {
    setState(() {
      isError = false;
      errorMessage = '';
    });

    if (registerFormKey.currentState!.validate() && !isApiLoading) {
      if (signupUserData.password.text.length < 8) {
        setState(() {
          isError = true;
          errorMessage = 'รหัสผ่านต้องมีความยาวมากกว่า 8 ตัวอักษร';
        });
        return;
      }

      if (signupUserData.password.text != signupUserData.repassword.text) {
        setState(() {
          isError = true;
          errorMessage = 'รหัสผ่านไม่ตรงกัน';
        });
        return;
      }

      showLoadingDialog(context);
      isApiLoading = true;

      httpAuthAPIService
          .register(
        RegisterUserData(
          firstname: signupUserData.firstname.text,
          lastname: signupUserData.lastname.text,
          email: signupUserData.email.text,
          password: signupUserData.password.text,
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

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpOTPPage(
                userID: (res['userId'] as int),
                otpRef: (res['refCode'] as String),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            color: isKeyboardOpen
                ? const Color.fromARGB(212, 193, 222, 255)
                : Colors.transparent,
            child: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isKeyboardOpen ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'สมัครสมาชิก',
                style: TextStyle(
                  color: isKeyboardOpen ? Colors.black : Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/background/page-top-right.png'),
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: registerFormKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: signupUserData.firstname,
                        inputLabel: 'ชื่อ',
                        inputHint: 'Name',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อ';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: signupUserData.lastname,
                        inputLabel: 'นามสกุล',
                        inputHint: 'Lastname',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกนามสกุล';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: signupUserData.email,
                        inputLabel: 'E-mail',
                        inputHint: 'E-mail',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onValidate: (value) {
                          if (value?.isEmpty ?? true) return 'กรุณากรอก E-mail';
                          if (!RegExp(r'@').hasMatch(value ?? '')) {
                            return 'กรุณากรอก E-mail ให้ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: signupUserData.password,
                        inputLabel: 'รหัสผ่าน',
                        inputHint: 'Password',
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: signupUserData.repassword,
                        inputLabel: 'รหัสผ่านอีกครั้ง',
                        inputHint: 'Re Enter Password',
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่านอีกครั้ง';
                          }
                          return null;
                        },
                      ),
                      isError
                          ? Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      CustomElevatedButton(
                        label: 'สมัครสมาชิก',
                        fullWidth: true,
                        rounded: true,
                        color: 'primary',
                        onPressed: () => onSignUp(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserRegisterData {
  final TextEditingController firstname;
  final TextEditingController lastname;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController repassword;

  UserRegisterData({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.repassword,
  });
}
