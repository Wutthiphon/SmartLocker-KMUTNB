import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../http_service.dart';

final String apiURL = "${dotenv.env['API_URL']}/locker";

class HttpLockerAPIService {
  Future getLockersNotInUsed() async {
    return APIService(
      url: "$apiURL/get-locker",
      method: 'GET',
    ).fetch();
  }

  Future getMyLockerInUsed() async {
    return APIService(
      url: "$apiURL/get-reservelocker",
      method: 'GET',
    ).fetch();
  }

  Future getMyLockerExpired() async {
    return APIService(
      url: "$apiURL/record-get",
      method: 'GET',
    ).fetch();
  }

  Future onReserveLocker(int lockerID) async {
    return APIService(
      url: "$apiURL/reservation-locker",
      method: 'POST',
      data: {
        'locker_id': lockerID,
      },
    ).fetch();
  }

  Future onUnlockLocker(int lockerID) async {
    return APIService(
      url: "$apiURL/unlock-locker-app",
      method: 'POST',
      data: {
        'locker_id': lockerID,
      },
    ).fetch();
  }

  Future onEndReserveLocker(int lockerID) async {
    return APIService(
      url: "$apiURL/cancel-locker",
      method: 'POST',
      data: {
        'locker_id': lockerID,
      },
    ).fetch();
  }
}
