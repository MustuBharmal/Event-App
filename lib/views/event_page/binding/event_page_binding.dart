import 'package:ems/views/event_page/controller/event_page_controller.dart';
import 'package:get/get.dart';

class EventPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EventPageController());
  }
}
