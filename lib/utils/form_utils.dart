import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class FormUtils {
  static String dateToStr(DateTime date) {
    initializeDateFormatting('es_ES');
    var formatter = DateFormat('dd/MM/yyyy', 'es_ES');
    return formatter.format(date);
  }

  static String dateToStrLong(DateTime date) {
    initializeDateFormatting('es_ES');
    var formatter = DateFormat('dd/MM/yyyy hh:mm', 'es_ES');
    return formatter.format(date);
  }

  static Future<dynamic> showBottomSheet(BuildContext context, Widget child) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: IntrinsicHeight(
                  child: SingleChildScrollView(child: child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
