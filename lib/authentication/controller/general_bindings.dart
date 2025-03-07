import 'package:code_champ/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings
{
  void dependencies()
  {
    Get.put(NetworkManager());
  }
}
