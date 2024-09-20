import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:t4f_test/model/model.dart';

class HomeController extends GetxController {
  RxBool isLoading = RxBool(false);
  List<Product>? products;
  List<Product>? reserve;
  String id = '';
  RxInt activeIndex = RxInt(0);
  RxString error = RxString('');

  @override
  void onInit() async {
    getProducts();
    id = await getProductId();
    super.onInit();
  }

  Future getProducts() async {
    try {
      isLoading(true);
      var url = Uri.https(
        '66e20997c831c8811b57050e.mockapi.io',
        '/api/v1/home/items',
      );
      var res = await http.get(url);
      if (res.statusCode == 200) {
        products = List<Product>.from(
          jsonDecode(res.body).map(
            (x) => Product.fromJson(x),
          ),
        );
        products!.shuffle();
        reserve = products!
            .where(
              (x) => x.id == id,
            )
            .toList();
        products!.removeWhere(
          (x) => x.id == id,
        );
        products!.insertAll(0, reserve!);
        isLoading(false);
      } else if (res.statusCode >= 400) {
        if (res.statusCode == 400) {
          throw 'Invalid request';
        }
        if (res.statusCode == 404) {
          throw 'Not found';
        }
      } else {
        throw 'A problem has occurred !!!';
      }
    } catch (err) {
      // print(err.toString());
      error.value = err.toString().contains('Failed host lookup')
          ? 'Check your internet!'
          : err.toString();
    } finally {
      isLoading(false);
    }
  }

  saveProductId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ProductId', id);
    print('Save ProductId $id');
  }

  getProductId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('ProductId') ?? '';
    print('Get ProductId $id');
    return id;
  }
}
