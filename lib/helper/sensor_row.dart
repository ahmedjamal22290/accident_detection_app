import 'package:flutter/cupertino.dart';

Widget buildSensorRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),

        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
