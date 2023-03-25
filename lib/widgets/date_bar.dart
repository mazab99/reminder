import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:intl/intl.dart';

class DateBar extends StatelessWidget {
  const DateBar({super.key,required this.dt});
  final DateTime dt;

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.EEEE().format(dt),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat.yMMMd().format(dt),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ));
  }
}