import 'package:ems/views/event_page/controller/event_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/event_participant_model.dart';
import '../../model/group_event_model.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/my_widgets.dart';
import '../auth/controller/auth_controller.dart';
import '../home/controller/home_controller.dart';

class EventParticipantListView extends GetView<EventPageController> {
  const EventParticipantListView({Key? key}) : super(key: key);
  static const String routeName = '/event-participant-list-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              iconWithTitle(
                  text: 'List of participants', func: () => Get.back()),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: Get.width * 0.6,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: controller.joined.length,
                  itemBuilder: (context, index) {
                    Rx<IndividualParticipantModel?> single =
                        Rx<IndividualParticipantModel?>(null);
                    Rx<GroupEventModel?> group = Rx<GroupEventModel?>(null);
                    if (controller.joined.isEmpty) {
                      return const Center(
                        child: Text('There is no participants yet.'),
                      );
                    }
                    final user = HomeController.instance.listOfUser
                        .firstWhere((e) => e.uid == controller.joined[index]);
                    if (controller.event!.eventType == 'Group') {
                      group.value = controller.listOfGroupParticipants
                          .firstWhere((part) => part.teamLeaderUid == user.uid);
                    } else {
                      single.value = controller.listOfIndividualParticipants
                          .firstWhere((part) {
                        return part.membersUid == user.uid;
                      });
                    }
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: CircleAvatar(
                                  minRadius: 26,
                                  foregroundImage: user.image != ''
                                      ? NetworkImage(user.image!)
                                      : null,
                                  backgroundImage: const AssetImage(
                                      'assets/Group 18341 (1).png'),
                                ),
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Text(
                                '${user.first?.toUpperCase()} ${user.last?.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Obx(
                                () => Checkbox(
                                  value: controller.event!.eventType == 'Group'
                                      ? group.value!.attendance!.value
                                      : single.value!.attendance!.value,
                                  onChanged: (value) {
                                    if (controller.event!.eventType ==
                                        'Group') {
                                      group.value!.attendance!.value = value!;
                                    } else {
                                      single.value!.attendance!.value = value!;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: AuthController.instance.user.value!.uid ==
                controller.event!.uid &&
            !formatDate(controller.event!.rgEdDate).isAfter(currentTime()) &&
            !formatDate(controller.event!.eventDay).isAfter(currentTime()),
        child: Obx(
          () => SizedBox(
            width: Get.width * 0.45,
            height: Get.height * 0.06,
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : elevatedButton(
                    text: 'Attendance',
                    onPress: () {
                      if (controller.event!.eventType == 'Group') {
                        controller.fireBaseGroupFunUpdateAttendance();
                      } else {
                        controller.fireBaseIndividualFunUpdateAttendance();
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
