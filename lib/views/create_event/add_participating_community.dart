import 'package:ems/model/group_community_model.dart';
import 'package:ems/views/create_event/controller/create_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class AddParticipatingCommunity extends GetView<CreateEventController> {
  AddParticipatingCommunity({super.key});

  static const String routeName = '/add-participating-community';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.resetControllers();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 27,
                        height: 27,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/circle.png'),
                          ),
                        ),
                        child: Image.asset('assets/bi_x-lg.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: myText(
                        text: 'Add Community',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(''),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    textFormFieldForValue(
                      inputType: TextInputType.number,
                      icon: ('assets/people_group_icon.png'),
                      hintText: 'No. of Community participating',
                      validator: (input) {
                        if (input.isEmpty) {
                          Get.snackbar('Opps', "Count is required",
                              colorText: AppColors.white,
                              backgroundColor: AppColors.blue);
                          return '';
                        }
                        return null;
                      },
                      onChanged: (String num) {
                        controller.noOfCommunity.value = int.parse(num);
                      },
                    ),
                    Obx(
                      () => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.noOfCommunity.value,
                          itemBuilder: (context, index) {
                            controller.listOfCommunity.clear();
                            controller.listOfCommunity.addAll(List.generate(
                                controller.noOfCommunity.value,
                                (index) => GroupCommunityModel()));
                            return Column(
                              children: [
                                textFormFieldForValue(
                                  inputType: TextInputType.number,
                                  icon: ('assets/people_group_icon.png'),
                                  hintText: 'No. of members in the community',
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      Get.snackbar('Opps', "Count is required",
                                          colorText: AppColors.white,
                                          backgroundColor: AppColors.blue);
                                      return '';
                                    }
                                    return null;
                                  },
                                  onChanged: (String num) {
                                    controller.listOfCommunity[index]
                                        .noOfCommunity = int.parse(num);
                                  },
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .listOfCommunity[index].noOfCommunity,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          textFormFieldForValue(
                                            inputType: TextInputType.number,
                                            icon:
                                                ('assets/people_group_icon.png'),
                                            hintText:
                                                'No. of members (excluding team leader)',
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                Get.snackbar(
                                                    'Opps', "Count is required",
                                                    colorText: AppColors.white,
                                                    backgroundColor:
                                                        AppColors.blue);
                                                return '';
                                              }
                                              return null;
                                            },
                                            onChanged: (String num) {},
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            );
                          }),
                    ),
                    elevatedButton(
                      onPress: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                      },
                      text: 'Submit',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
