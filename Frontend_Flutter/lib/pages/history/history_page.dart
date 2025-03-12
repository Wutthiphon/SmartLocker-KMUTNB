import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/api/locker_api.dart';
import 'package:flutter_cs_locker_project/services/storage/storage.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/locker_card_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<bool> _signInStatusFuture;
  late Future<List<Locker>> _myLockerFuture;
  late Future<List<Locker>> _myLockerHistoryFuture;

  @override
  void initState() {
    super.initState();
    _signInStatusFuture = checkSignInStatus();
    fetchData();
  }

  Future<bool> checkSignInStatus() async {
    return await Storage().getData('AUTH_TOKEN') != null;
  }

  void fetchData() {
    setState(() {
      _myLockerFuture = fetchMyLockerInUsed();
      _myLockerHistoryFuture = fetchMyLockerHistory();
    });
  }

  Future<List<Locker>> fetchMyLockerInUsed() async {
    final data = await HttpLockerAPIService().getMyLockerInUsed();
    if (data is Map && data.containsKey('error') && data['error']) {
      debugPrint('Error: ${data['message']}');
      return [];
    }
    return (data['data'] as List)
        .map((e) => Locker.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Locker>> fetchMyLockerHistory() async {
    final data = await HttpLockerAPIService().getMyLockerExpired();
    if (data is Map && data.containsKey('error') && data['error']) {
      debugPrint('Error: ${data['message']}');
      return [];
    }
    return (data['data'] as List)
        .map((e) => Locker.fromJson(e as Map<String, dynamic>))
        .toList();
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
              child: isSignIn
                  ? Column(
                      children: [
                        buildCard(
                          title: 'ล็อคเกอร์ที่กำลังใช้งานอยู่',
                          icon: Icons.key,
                          future: _myLockerFuture,
                          emptyMessage: 'ไม่มีล็อคเกอร์ที่กำลังใช้งานอยู่',
                        ),
                        buildCard(
                          title: 'ประวัติการใช้งาน',
                          icon: Icons.history,
                          future: _myLockerHistoryFuture,
                          emptyMessage: 'ยังไม่มีการใช้งานล็อคเกอร์',
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Icon(
                            Icons.lock,
                            size: 100,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            'กรุณาเข้าสู่ระบบ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCard({
    required String title,
    required IconData icon,
    required Future<List<Locker>> future,
    required String emptyMessage,
  }) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueGrey, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Locker>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<Locker> lockers = snapshot.data ?? [];

                return Column(
                  children: lockers.isNotEmpty
                      ? lockers
                          .map(
                            (locker) => LockerCard(
                              lockerData: locker,
                              isLogin: true,
                              onActionSuccess: () => fetchData(),
                            ),
                          )
                          .toList()
                      : [Text(emptyMessage)],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
