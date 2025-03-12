import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/storage/storage.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/dialog/confirmation_dialog.dart';

// Pages
import 'package:flutter_cs_locker_project/pages/setting/application_info_page.dart';
import 'package:flutter_cs_locker_project/pages/setting/change_password_page.dart';
import 'package:flutter_cs_locker_project/pages/setting/edit_profile_page.dart';
import 'package:flutter_cs_locker_project/pages/app_layout.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Future<bool> _signInStatusFuture;
  late UserData userData;

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
      }
    }

    return isSignIn;
  }

  void onSignOut() {
    showConfirmationDialog(
      context: context,
      title: 'ออกจากระบบ',
      content: 'คุณต้องการออกจากระบบหรือไม่?',
      onConfirm: () {
        Storage().remove('AUTH_TOKEN');
        Storage().remove('AUTH_USER');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _signInStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          bool isSignIn = snapshot.data ?? false;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  isSignIn
                      ? Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 76, 108, 145),
                                  Color.fromARGB(255, 104, 162, 196)
                                ],
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.account_circle_outlined,
                                size: 40,
                                color: Colors.white,
                              ),
                              title: Text(
                                '${userData.firstname} ${userData.lastname}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email: ${userData.email}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 77, 77, 77),
                                  Color.fromARGB(255, 128, 128, 128)
                                ],
                              ),
                            ),
                            child: const ListTile(
                              leading: Icon(
                                Icons.account_circle_outlined,
                                size: 40,
                                color: Colors.white,
                              ),
                              title: Text(
                                'กรุณาเข้าสู่ระบบ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('เกี่ยวกับแอปพลิเคชัน'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApplicationInfoPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isSignIn
                      ? ListView(
                          shrinkWrap: true,
                          children: [
                            Card(
                              color: Colors.white,
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('แก้ไขโปรไฟล์'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfilePage(),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: Colors.white,
                              child: ListTile(
                                leading: const Icon(Icons.lock),
                                title: const Text('เปลี่ยนรหัสผ่าน'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordPage(),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: Colors.white,
                              child: ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('ออกจากระบบ'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () => onSignOut(),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        )
                      : const SizedBox(height: 20),
                  const Center(
                    child: Column(
                      children: [
                        Text('Lock!Lock! | Version: 1.0.0'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
