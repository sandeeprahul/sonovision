import 'package:get/get.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final Rx<Map<String, dynamic>> homeData = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  final ApiService _apiService = ApiService();

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final jsonData = await _apiService.getHomeData();
      homeData.value = jsonData;
    } catch (e) {
      error.value = 'Failed to load home data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}