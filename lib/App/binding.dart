import '../Modules/AddRequest/add_request_controller.dart';
import '../Modules/Login/login_controller.dart';
import '../Modules/Main/Home/home_controller.dart';
import 'package:get/get.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => AddRequestController(), fenix: true);
  }
}
