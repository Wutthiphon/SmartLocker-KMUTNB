import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../http_service.dart';

final String apiURL = "${dotenv.env['API_URL']}/image";

class HttpGetImageService {
  Future geHomePageImage() async {
    return APIService(
      url: "$apiURL/get-image",
      method: 'GET',
    ).fetch();
  }
}
