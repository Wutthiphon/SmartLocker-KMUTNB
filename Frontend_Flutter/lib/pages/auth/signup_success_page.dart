import 'package:flutter/material.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';

// Pages
import 'package:flutter_cs_locker_project/pages/app_layout.dart';

class SignUpSuccessPage extends StatefulWidget {
  const SignUpSuccessPage({super.key});

  @override
  State<SignUpSuccessPage> createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessPage> {
  void onNextStep() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const AppLayout(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              './assets/background/page-top-right.png',
              fit: BoxFit.cover,
              height: 180,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 180.0,
              left: 10.0,
              right: 10.0,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 125,
                  color: Color.fromARGB(255, 76, 175, 117),
                ),
                const SizedBox(height: 10),
                const Text(
                  'สำเร็จ!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'สมัครสมาชิกเรียบร้อยแล้ว!\nคุณสามารถใช้งาน Lock!Lock! ได้แล้ว',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                CustomElevatedButton(
                  label: 'เสร็จสิ้น',
                  fullWidth: true,
                  rounded: true,
                  color: 'success',
                  onPressed: onNextStep,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
