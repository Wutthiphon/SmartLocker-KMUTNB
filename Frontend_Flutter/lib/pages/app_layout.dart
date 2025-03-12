import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/storage/storage.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Navigation Components
import 'package:flutter_cs_locker_project/components/app_top_menu/top_menu.dart';
import 'package:flutter_cs_locker_project/components/app_bottom_menu/bottom_menu.dart';

// Pages
import 'package:flutter_cs_locker_project/pages/home/home_page.dart';
import 'package:flutter_cs_locker_project/pages/history/history_page.dart';
import 'package:flutter_cs_locker_project/pages/setting/setting_page.dart';
import 'package:flutter_cs_locker_project/pages/reserve/reserve_page.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool isSignIn = false;
  int activeIndex = 0;
  final List<AppMenuItem> menuItems = [
    AppMenuItem(
      icon: const Icon(FontAwesomeIcons.house),
      label: 'หน้าแรก',
      page: const HomePage(),
    ),
    AppMenuItem(
      icon: const Icon(FontAwesomeIcons.vault),
      label: 'ล็อคเกอร์ของฉัน',
      page: const HistoryPage(),
    ),
    AppMenuItem(
      icon: const Icon(FontAwesomeIcons.bookBookmark),
      label: 'จองล็อคเกอร์',
      page: const ReservePage(),
    ),
    AppMenuItem(
      icon: const Icon(FontAwesomeIcons.gear),
      label: 'การตั้งค่า',
      page: const SettingPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    checkSignInStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkSignInStatus() async {
    bool signInStatus = await Storage().getData('AUTH_TOKEN') != null;

// Check Token is expired

    setState(() {
      isSignIn = signInStatus;
    });
  }

  void onTab(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenu(
        appBar: AppBar(),
        title: menuItems[activeIndex].label,
        activeIndex: activeIndex,
        isSignIn: isSignIn,
      ),
      body: menuItems[activeIndex].page,
      bottomNavigationBar: BottomMenu(
        activeIndex: activeIndex,
        menuItems: menuItems,
        onTab: onTab,
      ),
    );
  }
}
