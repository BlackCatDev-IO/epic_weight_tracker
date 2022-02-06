import 'package:intl/intl.dart';

class DateTimeFormatter {
  static final _dateFormatter = DateFormat.yMMMd();

  static String formatDate(DateTime date) => _dateFormatter.format(date);
}
