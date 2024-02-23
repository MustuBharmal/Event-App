
import 'dart:developer';

import 'package:intl/intl.dart';

formatDate(String date){
   
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  log('$formatter');
  final String formatted = formatter.format(DateTime.parse(date));
log(formatted);
  return formatted;
}