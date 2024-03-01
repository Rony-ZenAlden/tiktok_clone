import 'package:get/get.dart';
import 'package:tiktok_clone/constant/network_manger.dart';

class GeneralBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}