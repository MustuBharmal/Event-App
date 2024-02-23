import 'package:ems/views/create_event/controller/create_event_controller.dart';
import 'package:get/get.dart';

class CreateEventBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(CreateEventController());
  }

}