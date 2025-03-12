import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/api/auth_api.dart';
import 'package:flutter_cs_locker_project/services/storage/storage.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_text_form_filed.dart';
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';
import 'package:flutter_cs_locker_project/components/dialog/loading_dialog.dart';

// Pages
import 'package:flutter_cs_locker_project/pages/app_layout.dart';
import 'package:flutter_cs_locker_project/pages/auth/signup_page.dart';
import 'package:flutter_cs_locker_project/pages/auth/signup_otp_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  HttpAuthAPIService httpAuthAPIService = HttpAuthAPIService();

  var signinFormKey = GlobalKey<FormState>();
  final signinUserData = UserData(
    username: TextEditingController(),
    password: TextEditingController(),
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
    signinUserData.username.dispose();
    signinUserData.password.dispose();
    super.dispose();
  }

  void onSignIn() {
    if (signinFormKey.currentState!.validate() && !isApiLoading) {
      showLoadingDialog(context);
      setState(() {
        isError = false;
        errorMessage = '';
      });

      isApiLoading = true;
      httpAuthAPIService
          .login(
        LoginUserData(
          username: signinUserData.username.text,
          password: signinUserData.password.text,
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

          if (res.containsKey('verify_status') && !res['verify_status']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpOTPPage(
                  userID: (res['userId'] as int),
                  otpRef: (res['refCode'] as String),
                ),
              ),
            );
            return;
          }

          Storage().saveData('AUTH_TOKEN', res['token']);
          Storage().saveJsonData(
            'AUTH_USER',
            {
              'email': res['email'],
              'firstname': res['firstname'],
              'lastname': res['lastname'],
            },
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AppLayout(),
            ),
            (route) => false,
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
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
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
            'เข้าสู่ระบบ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                './assets/background/page-top-right.png',
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 130,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: signinFormKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/logo/logo.png',
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomTextFormField(
                      controller: signinUserData.username,
                      inputLabel: 'E-mail',
                      inputHint: 'E-mail',
                      inputIcon: Icons.person,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onValidate: (value) {
                        if (value?.isEmpty ?? true) return 'กรุณากรอก E-mail';
                        if (!RegExp(r'@').hasMatch(value ?? '')) {
                          return 'กรุณากรอก E-mail ให้ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      controller: signinUserData.password,
                      inputLabel: 'รหัสผ่าน',
                      inputHint: 'Password',
                      inputIcon: Icons.key,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
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
                    const SizedBox(height: 30),
                    CustomElevatedButton(
                      label: 'เข้าสู่ระบบ',
                      fullWidth: true,
                      rounded: true,
                      color: 'primary',
                      onPressed: onSignIn,
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'หรือ',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomElevatedButton(
                      label: 'สมัครสมาชิก',
                      fullWidth: true,
                      rounded: true,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserData {
  final TextEditingController username;
  final TextEditingController password;

  UserData({
    required this.username,
    required this.password,
  });
}
