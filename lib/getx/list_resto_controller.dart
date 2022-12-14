import 'package:get/get.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

class RestoController extends GetxController {
  var listResto = <Restaurant>[].obs;
  var isLoading = false.obs;
  var haveConection = true.obs;
  @override
  void onInit() {
    getListResto();
    super.onInit();
  }

  Future getListResto() async {
    listResto.clear();
    isLoading(true);
    try {
      const String baseUrl = 'https://restaurant-api.dicoding.dev/list';
      final response = await http.get(Uri.parse(baseUrl));
      isLoading(false);
      haveConection(true);
      RestoListModel decodeRestoStatus = restoModelFromJson(response.body);
      listResto.value = decodeRestoStatus.restaurants.toList();
      return listResto;
    } catch (e) {
      isLoading(false);
      haveConection(false);
      return e;
    }
  }

  Future getListRestoQuery(query) async {
    listResto.clear();
    isLoading(true);
    try {
      final response = await http.get(
          Uri.parse("https://restaurant-api.dicoding.dev/search?q=$query"));
      isLoading(false);
      RestoListModel decodeRestoStatus = restoModelFromJson(response.body);
      listResto.value = decodeRestoStatus.restaurants.toList();
      return listResto;
    } catch (e) {
      isLoading(false);
      return e;
    }
  }
}
