import 'package:get/get.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/data/model/restaurant.dart';

class RestoFavController extends GetxController {
  var listFavResto = <Restaurant>[].obs;
  var isLoading = false.obs;
  late DatabaseHelper _dbHelper;
  RestoFavController() {
    _dbHelper = DatabaseHelper();
    getListFavResto();
  }

  Future<void> getListFavResto() async {
    print("_getAllNotes");
    listFavResto.value = await _dbHelper.getRestos();
    // _getAllNotes();
  }

  Future<void> addFavoriteResto(Restaurant resto) async {
    await _dbHelper.insertResto(resto);
    // _getAllNotes();
  }

  Future<Restaurant> getRestoById(int id) async {
    return await _dbHelper.getRestoById(id);
  }
}
