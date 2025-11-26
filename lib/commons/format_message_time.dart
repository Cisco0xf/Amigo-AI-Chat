import 'package:intl/intl.dart';

extension FormatMessageTime on DateTime {
  String get formatMessageTime {
    const String format = "MMM d, yyyy | h:mm a";

    String formatedTime = DateFormat(format).format(this);

    return formatedTime;
  }
}
