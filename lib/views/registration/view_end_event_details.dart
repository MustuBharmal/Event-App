import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:ems/model/event_model.dart';
import 'package:ems/model/user_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';
import '../home/controller/home_controller.dart';

class ViewEndEventDetails extends StatelessWidget {
  static const String routeName = '/view-end-event-details';

  const ViewEndEventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var excel = Excel.createExcel();
    EventModel event = Get.arguments;
    //create an excel sheet
    Sheet sheet = excel[event.eventName];
    List<UserModel> listOfParticipatedUser = [];

    for(var user in HomeController.instance.listOfUser){
      var isCheck = event.joined.contains(user.uid);
      if(isCheck){
        listOfParticipatedUser.add(user);
      }
    }
    for (int i = 0; i < event.joined.length; i++) {
      var nameCell = sheet.cell(CellIndex.indexByString('B${i + 2}'));
      var number = sheet.cell(CellIndex.indexByString('C${i + 2}'));
      var email = sheet.cell(CellIndex.indexByString('D${i + 2}'));
      var gender = sheet.cell(CellIndex.indexByString('D${i + 2}'));
      nameCell.value = TextCellValue(
          '${listOfParticipatedUser[i].first!} ${listOfParticipatedUser[i].last!}');
      number.value = TextCellValue('${listOfParticipatedUser[i].mobileNumber}');
      email.value = TextCellValue('${listOfParticipatedUser[i].email}');
      gender.value = TextCellValue('${listOfParticipatedUser[i].gender}');
    }

    String eventImage = '';
    try {
      List media = event.media;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: myText(
                            text: 'Details',
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
                  Container(
                    width: Get.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          spreadRadius: 1,
                          color: const Color(0xff393939).withOpacity(0.15),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(eventImage),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myText(
                                text: event.eventName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    // width: 11.67,
                                    height: 15,
                                    child: Image.asset(
                                      'assets/location.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  myText(
                                    text: event.location!.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: myText(
                                    text: '${event.description}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blue,
                                    ),
                                    maxLines: 3),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              myText(
                                text: 'Event Date:- ${event.eventDay}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              myText(
                                text:
                                    'Total seats available:-  ${event.maxEntries! + event.joined.length}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              myText(
                                text: 'No. of Entries:-  ${event.joined.length}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              myText(
                                text: 'Venue:-  ${event.location}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            elevatedButton(text: "Download excel",onPress: (){
              writeCounter(excel);
            })
          ],
        ),
      ),
    );
  }
  Future<File> writeCounter(Excel excel) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    final file = await _localFile;
    return file.writeAsBytes(excel.encode()!);
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/event_details.xlsx');
  }
  Future<String> get _localPath async {
    final directory = Directory("/storage/emulated/0/Download");
    return directory.path;
  }

}
