import 'package:resto_app/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/list';
  Future<RestoListModel> getListResto() async {
    final response = await http.get(Uri.parse(_baseUrl));
    RestoListModel decodeRestoStatus = restoModelFromJson(response.body);
    return decodeRestoStatus;
  }

  Future<RestoListModel> getListRestoQuery(query) async {
    final response = await http
        .get(Uri.parse("https://restaurant-api.dicoding.dev/search?q=$query"));
    RestoListModel decodeRestoStatus = restoModelFromJson(response.body);
    return decodeRestoStatus;
  }
}
