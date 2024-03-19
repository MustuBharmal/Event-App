import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('dd/MM/yyyy');

DateTime formatDate(String date) {
  DateTime temp = formatter.parse(date);

  return temp;
}

DateTime currentTime() {
  DateTime now = DateTime.now();
  String dFormat2 = formatter.format(now);
  DateTime temp = formatter.parse(dFormat2);

  return temp;
}
