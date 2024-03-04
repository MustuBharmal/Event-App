import 'package:ems/views/auth/controller/auth_controller.dart';
import 'package:ems/views/event_page/event_page_view.dart';
import 'package:ems/views/profile/controller/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';

class ProfileView extends GetView<ProfileController> {
  static const String routeName = '/profile-view';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Obx(
                  () => AuthController.instance.isLogoutLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () {
                            AuthController.instance.logout();
                          },
                          child: SizedBox(
                              width: Get.width * 0.06,
                              child: const Icon(Icons.logout)),
                        ),
                ),
              ),
              Stack(
                children: [
                  Obx(
                    () => Align(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 90, horizontal: 20),
                        width: Get.width,
                        height: controller.isNotEditable.value
                            ? Get.height * 0.283
                            : Get.height * 0.37,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          width: Get.width * 0.31,
                          height: Get.height * 0.147,
                          margin: const EdgeInsets.only(top: 35),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(70),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff7DDCFB),
                                Color(0xffBC67F2),
                                Color(0xffACF6AF),
                                Color(0xffF95549),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  controller.imagePickDialog();
                                  if (controller.profileImage != null) {
                                    controller.imageString.value =
                                        await AuthController.instance
                                            .uploadImageToFirebaseStorage(
                                                controller.profileImage!);
                                    controller.onSaveUserProfileDetails();
                                    Get.snackbar(
                                        'Updated', 'Profile image has updated!',
                                        colorText: AppColors.white,
                                        backgroundColor: AppColors.blue);
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: Obx(
                                      () => CircleAvatar(
                                        radius: Get.width * 0.145,
                                        backgroundColor: AppColors.white,
                                        backgroundImage: const AssetImage(
                                          'assets/time.png',
                                        ),
                                        foregroundImage: NetworkImage(
                                          controller.imageString.value,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.018,
                        ),
                        Obx(
                          () => controller.isNotEditable.value
                              ? Text(
                                  "${controller.firstNameController.text} ${controller.lastNameController.text}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : SizedBox(
                                  width: Get.width * 0.6,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller.firstNameController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'First Name',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller.lastNameController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Last Name',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: Get.height * 0.018,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.noOfSavedEvents.value
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Saved Events",
                                    style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing: -0.3,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color(0xff918F8F).withOpacity(0.5),
                              ),
                              Obx(
                                () => Column(
                                  children: [
                                    Text(
                                      AuthController.instance.user.value!
                                                  .userType! ==
                                              'student'
                                          ? controller.noOfJoinedEvents
                                              .toString()
                                          : controller.noOfOrganizedEvents
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.3),
                                    ),
                                    Text(
                                      AuthController.instance.user.value!
                                                  .userType! ==
                                              'student'
                                          ? "Joined Events"
                                          : "Created Events",
                                      style: TextStyle(
                                        fontSize: 17,
                                        letterSpacing: -0.3,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.024,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: DefaultTabController(
                            length: 2,
                            initialIndex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width: 0.01,
                                      ),
                                    ),
                                  ),
                                  child: TabBar(
                                    indicatorColor: Colors.black,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10,
                                    ),
                                    unselectedLabelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                        icon:
                                            Image.asset("assets/bookMark.png"),
                                        height: 20,
                                      ),
                                      Tab(
                                        icon: Image.asset(
                                            "assets/Group 18600.png"),
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: Get.height * 0.46,
                                  //height of TabBarView
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: AppColors.white,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Obx(
                                        () => ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                controller.savedEvents.length,
                                            itemBuilder: (context, index) {
                                              String image = '';
                                              image = controller
                                                  .selectEventImage(controller
                                                      .savedEvents[index]
                                                      .media);
          
                                              return GestureDetector(
                                                onTap: () => Get.toNamed(
                                                    EventPageView.routeName,
                                                    arguments: controller
                                                        .savedEvents[index]),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  width: Get.width,
                                                  height: Get.height * 0.14,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: AppColors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.15),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                        offset: const Offset(0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10, left: 10),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircleAvatar(
                                                          foregroundImage:
                                                              NetworkImage(
                                                                  image),
                                                          backgroundImage:
                                                              const AssetImage(
                                                                  'assets/time.png'),
                                                          radius: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                        .savedEvents[
                                                                            index]
                                                                        .eventName
                                                                        .capitalize!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            16.0),
                                                                    child: Text(
                                                                      controller
                                                                          .savedEvents[
                                                                              index]
                                                                          .eventDay,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                '${controller.savedEvents[index].description}',
                                                                maxLines: 2,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                softWrap: true,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      Obx(
                                        () => ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: controller
                                                .orgOrJoinedEvents.length,
                                            itemBuilder: (context, index) {
                                              String image = '';
                                              image = controller
                                                  .selectEventImage(controller
                                                      .orgOrJoinedEvents[index]
                                                      .media);
                                              // print(controller.orgOrJoinedEvents.length);
                                              return GestureDetector(
                                                onTap: () => Get.toNamed(
                                                    EventPageView.routeName,
                                                    arguments: controller
                                                            .orgOrJoinedEvents[
                                                        index]),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  width: Get.width,
                                                  height: Get.height * 0.14,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: AppColors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.15),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                        offset: const Offset(0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10, left: 10),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircleAvatar(
                                                          foregroundImage:
                                                              NetworkImage(
                                                                  image),
                                                          backgroundImage:
                                                              const AssetImage(
                                                                  'assets/time.png'),
                                                          radius: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                        .orgOrJoinedEvents[
                                                                            index]
                                                                        .eventName
                                                                        .capitalize!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            16.0),
                                                                    child: Text(
                                                                      controller
                                                                          .orgOrJoinedEvents[
                                                                              index]
                                                                          .eventDay,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                '${controller.orgOrJoinedEvents[index].description}',
                                                                maxLines: 2,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                softWrap: true,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 105, right: 35),
                        child: InkWell(
                          onTap: () {
                            if (controller.isNotEditable.value == false) {
                              controller.onSaveDetails();
                            }
                            controller.isNotEditable.value =
                                !controller.isNotEditable.value;
                          },
                          child: controller.isNotEditable.value
                              ? Image(
                                  image: const AssetImage('assets/edit.png'),
                                  width: Get.width * 0.06,
                                )
                              : Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: Get.width * 0.07,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
margin: EdgeInsets.only(left: 20),
width: 53,
height: 53,
child: Image.asset(
'assets/Group 26.png',
),
),
Container(
margin: EdgeInsets.only(left: 15),
width: 53,
height: 53,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(36),
color: AppColors.white,
),
child: Image(
image: AssetImage('assets/Ellipse 984.png')),
),
Container(
margin: EdgeInsets.only(left: 15),
width: 53,
height: 53,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(36),
color: AppColors.white,
),
child: Image(
image: AssetImage('assets/Ellipse 985.png')),
),
Container(
margin: EdgeInsets.only(left: 15),
width: 53,
height: 53,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(36),
color: AppColors.white,
),
child: Image(
image: AssetImage('assets/Ellipse 986.png')),
),
],
),
Container(
margin: EdgeInsets.only(left: 30, top: 10),
child: Text(
'NEW',
style: TextStyle(
fontSize: 12,
color: Colors.grey,
fontWeight: FontWeight.w500,
),
),
),
],
),*/
