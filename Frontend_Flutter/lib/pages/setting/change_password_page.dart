import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/components/custom_text_form_filed.dart';
import 'package:flutter_cs_locker_project/services/api/auth_api.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';
import 'package:flutter_cs_locker_project/components/dialog/loading_dialog.dart';
import 'package:flutter_cs_locker_project/components/dialog/alert_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  HttpAuthAPIService httpAuthAPIService = HttpAuthAPIService();

  var chgPassFormKey = GlobalKey<FormState>();
  final changePasswordData = UserEditPasswordData(
    oldPassword: TextEditingController(),
    newPassword: TextEditingController(),
    reNewPassword: TextEditingController(),
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
    super.dispose();
  }

  void onSubmit() {
    setState(() {
      isError = false;
      errorMessage = '';
    });

    if (chgPassFormKey.currentState!.validate() && !isApiLoading) {
      if (changePasswordData.newPassword.text.length < 8) {
        setState(() {
          isError = true;
          errorMessage = 'รหัสผ่านต้องมีความยาวมากกว่า 8 ตัวอักษร';
        });
        return;
      }

      if (changePasswordData.newPassword.text ==
          changePasswordData.oldPassword.text) {
        setState(() {
          isError = true;
          errorMessage = 'รหัสผ่านใหม่ต้องไม่เหมือนรหัสผ่านเดิม';
        });
        return;
      }

      if (changePasswordData.newPassword.text !=
          changePasswordData.reNewPassword.text) {
        setState(() {
          isError = true;
          errorMessage = 'รหัสผ่านไม่ตรงกัน';
        });
        return;
      }

      showLoadingDialog(context);
      isApiLoading = true;

      httpAuthAPIService
          .userChangePassword(
        EditUserPasswordData(
          oldPassword: changePasswordData.oldPassword.text,
          newPassword: changePasswordData.newPassword.text,
          reNewPassword: changePasswordData.reNewPassword.text,
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

          setState(() {
            changePasswordData.oldPassword.text = '';
            changePasswordData.newPassword.text = '';
            changePasswordData.reNewPassword.text = '';
          });
          showAlertDialog(
            context: context,
            title: "สำเร็จ",
            content: "เปลี่ยนรหัสผ่านเรียบร้อยแล้ว",
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
            'เปลี่ยนรหัสผ่าน',
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
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: chgPassFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      inputLabel: 'รหัสผ่านเดิม',
                      inputHint: 'Old Password',
                      controller: changePasswordData.oldPassword,
                      obscureText: true,
                      onValidate: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอกรหัสผ่านเดิม';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      inputLabel: 'รหัสผ่านใหม่',
                      inputHint: 'New Password',
                      controller: changePasswordData.newPassword,
                      obscureText: true,
                      onValidate: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอกรหัสผ่านใหม่';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      inputLabel: 'ยืนยันรหัสผ่านใหม่',
                      inputHint: 'Re-Enter New Password',
                      controller: changePasswordData.reNewPassword,
                      obscureText: true,
                      onValidate: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณายืนยันรหัสผ่านใหม่';
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
              )),
        ),
      ),
    );
  }
}

class UserEditPasswordData {
  final TextEditingController oldPassword;
  final TextEditingController newPassword;
  final TextEditingController reNewPassword;

  UserEditPasswordData({
    required this.oldPassword,
    required this.newPassword,
    required this.reNewPassword,
  });
}
