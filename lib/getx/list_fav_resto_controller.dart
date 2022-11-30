import 'package:get/get.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/data/model/restaurant.dart';

class RestoFavController extends GetxController {
  var listFavResto = <Restaurant>[].obs;
  var valueIcon = true.obs;
  late DatabaseHelper _dbHelper;
  RestoFavController() {
    _dbHelper = DatabaseHelper();
    getListFavResto();
  }

  Future<void> getListFavResto() async {
    listFavResto.value = await _dbHelper.getRestos();
  }

  Future<void> addFavoriteResto(Restaurant resto) async {
    await _dbHelper.insertResto(resto);
    getListFavResto();
  }

  Future getRestoById(id) async {
    try {
      await _dbHelper.getRestoById(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteResto(id) async {
    await _dbHelper.deleteResto(id);
    getListFavResto();
  }
}
