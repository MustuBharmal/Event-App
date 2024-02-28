import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/check_box.dart';
import '../../widgets/my_widgets.dart';
import '../home/controller/home_controller.dart';

class EventParticipantListView extends StatelessWidget {
  const EventParticipantListView({Key? key}) : super(key: key);
  static const String routeName = '/event-participant-list-view';

  @override
  Widget build(BuildContext context) {
    List<String> invite = Get.arguments;
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
                  itemCount: invite.length,
                  itemBuilder: (context, index) {
                    final user = HomeController.instance.listOfUser
                        .firstWhere((e) => e.uid == invite[index]);
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
                                  backgroundImage: NetworkImage(user.image!),
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
                              const ChecksBox(),
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
    );
  }
}
