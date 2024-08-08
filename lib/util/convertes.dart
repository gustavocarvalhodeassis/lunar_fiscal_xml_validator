import 'package:intl/intl.dart';

DateTime stringToDate(String text) => DateTime.parse(text);

String? dateToString(DateTime? date) => date != null ? DateFormat('dd/MM/yyyy').format(date) : null;

String? doubleToCurrency(double? value) => value != null ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value) : null;
