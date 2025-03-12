import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/api/locker_api.dart';
import 'package:flutter_cs_locker_project/services/storage/storage.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/locker_card_widget.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  late Future<bool> _signInStatusFuture;
  late Future<List<Locker>> _lockerFuture;

  @override
  void initState() {
    super.initState();
    _signInStatusFuture = checkSignInStatus();
    _lockerFuture = fetchLockers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkSignInStatus() async {
    return await Storage().getData('AUTH_TOKEN') != null;
  }

  Future<List<Locker>> fetchLockers() async {
    final data = await HttpLockerAPIService().getLockersNotInUsed();
    if (data is Map && data.containsKey('error') && data['error']) {
      debugPrint('Error: ${data['message']}');
      return [];
    }
    return (data as List)
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
              child: FutureBuilder<List<Locker>>(
                future: _lockerFuture,
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
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  List<Locker> lockers = snapshot.data ?? [];

                  return Column(
                    children: lockers
                        .map(
                          (locker) => LockerCard(
                            lockerData: locker,
                            isLogin: isSignIn,
                            onActionSuccess: () {
                              setState(() {
                                _lockerFuture = fetchLockers();
                              });
                            },
                            onActionNotSuccess: () => fetchLockers(),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
