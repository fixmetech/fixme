import 'package:fixme/utils/helper/network_manager.dart';
import 'package:fixme/features/translation/controllers/translation_controller.dart';
import 'package:get/get.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(TranslationController());
  }
}