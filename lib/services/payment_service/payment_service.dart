import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../views/home/bottom_bar_view.dart';

Map<String, dynamic>? paymentIntentData;

Future<void> joinedEvent(context, {String? eventId}) async {
  try {
    FirebaseFirestore.instance.collection('events').doc(eventId).set({
      'joined': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      'max_entries': FieldValue.increment(-1),
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection('booking').doc(eventId).set({
        'booking': FieldValue.arrayUnion([
          {'uid': FirebaseAuth.instance.currentUser!.uid, 'tickets': 1}
        ])
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully joined")));

      Timer(const Duration(seconds: 3), () {
        Get.offAll(const BottomBarView());
      });
    });
  } catch (e) {
    log(e.toString());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
  }
}
