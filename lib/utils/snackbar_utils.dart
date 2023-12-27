import 'package:flutter/material.dart';

class SnackbarUtils {
  static showSnackbar(SnackbarLevel level, BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: level.color,
        content: Text(
          level.prefix + msg,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        )));
  }
}

enum SnackbarLevel {
  INFO(Colors.blue, "Thông tin: "),
  ERROR(Colors.red, "Lỗi: "),
  SUCCESS(Colors.green, "Thành công: "),
  WARNING(Colors.yellow, "Cảnh báo: ");

  const SnackbarLevel(this.color, this.prefix);

  final Color color;
  final String prefix;
}
