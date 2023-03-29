import 'package:intl/intl.dart';

class Dates {
  String formatDate(String date) {
    String dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
    return dateFormate;
  }

  String convertDateToString(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  bool isSameDate(DateTime other) {
    DateTime now = DateTime.now();
    return now.year == other.year &&
        now.month == other.month &&
        now.day == other.day;
  }

  String getCharDay(String nameDay) {
    String charDay = '';
    switch (nameDay) {
      case 'Monday':
        charDay = 'L';
        break;
      case 'Tuesday':
        charDay = 'M';
        break;
      case 'Wednesday':
        charDay = 'X';
        break;
      case 'Thursday':
        charDay = 'J';
        break;
      case 'Friday':
        charDay = 'V';
        break;
      case 'Saturday':
        charDay = 'S';
        break;
      case 'Sunday':
        charDay = 'D';
        break;
    }
    return charDay;
  }

  String invertDay(String date) {
    String finalDay = '';

    finalDay = date.substring(6, 10);
    finalDay = finalDay + '-';
    finalDay = finalDay + date.substring(3, 5) + "-";
    finalDay = finalDay + date.substring(0, 2);
    return finalDay;
  }
}
