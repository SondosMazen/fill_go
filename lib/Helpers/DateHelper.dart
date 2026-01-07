import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;

class DateHelper {
  static String timeAgo({String? dateStr, DateTime? dateTime}) {
    if (dateStr == null && dateTime == null) return "";
    DateTime? dt = dateTime ?? DateTime.tryParse(dateStr!);
    if (dt == null) return "";
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  static String dateTimeTOString({required DateTime? dateTime,String dateFormat='MM/yyyy'}) {
    String formattedDate = DateFormat(dateFormat).format(dateTime!);
    return formattedDate;
  }
}
