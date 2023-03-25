import 'package:flutter/material.dart' hide ModalBottomSheetRoute;


class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 14,
            ),
            margin: const EdgeInsets.only(
              top: 8,
            ),
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    readOnly: widget != null ? true : false,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    cursorColor: Colors.grey[800],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(),
                      border: InputBorder.none,
                    ),
                  )),
                  widget ?? Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
