import 'package:ems/views/registration/controller/registration_controller.dart';
import 'package:get/get.dart';

class RegistrationBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(RegistrationController());
  }

}