import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';
import 'package:timeago/timeago.dart';

class UserNotificationScreen extends StatelessWidget {
  const UserNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: iconWithTitle(
                  func: () {
                    Get.back();
                  },
                  text: 'Notifications'),
            ),
            /*Container(
              color: const Color(0xffEEEEEE).withOpacity(0.9),
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),*/
            StreamBuilder<QuerySnapshot>(
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List<DocumentSnapshot> data = snap.data!.docs;
                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Upcoming Feature',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (ctx, i) {
                    String name, title, image;
                    DateTime date;

                    try {
                      name = data[i].get('name');
                    } catch (e) {
                      name = '';
                    }

                    try {
                      title = data[i].get('message');
                    } catch (e) {
                      title = '';
                    }

                    try {
                      image = data[i].get('image');
                    } catch (e) {
                      image = '';
                    }

                    try {
                      date = data[i].get('time').toDate();
                    } catch (e) {
                      date = DateTime.now();
                    }

                    return buildTile(name, title, date, image);
                  },
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                );
              },
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('myNotifications')
                  .snapshots(),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  buildTile(String name, String title, DateTime subTitle, String image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 73),
          child: Text(
            format(subTitle),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.genderTextColor,
            ),
          ),
        ),
        Divider(
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }

  buildDate(String time) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Text(
        time,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AppColors.black,
        ),
      ),
    );
  }
}
