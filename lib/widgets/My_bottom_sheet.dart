import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import 'package:provider/provider.dart';
import 'package:reminder/Providers/Database.dart';

import '../Models/task_model.dart';
import '../local_style/icons.dart';
import 'My_button.dart';

TextEditingController currentPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();

var formState = GlobalKey<FormState>();

void myBottomSheet({
  required BuildContext context,
  required double height,
  required double width,
  required TaskModel taskdata,
}) {
  showBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    context: context,
    builder: (context) => Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                  bottom: 25,
                ),
                child: Column(
                  children: [
                    Mbutton(
                        width: width,
                        height: height,
                        colors: [
                          Colors.red,
                          Colors.red.withOpacity(.8),
                        ],
                        txt: taskdata.isFavorites == 1
                            ? 'Delete From Favourites'
                            : "Add To Favourites",
                        wid: const Icon(
                          IconBroken.Heart,
                          color: Colors.white,
                        ),
                        func: () async {
                          TaskModel task = TaskModel(
                            title: taskdata.title,
                            isCompleted: taskdata.isCompleted,
                            isFavorites: taskdata.isFavorites == 0 ? 1 : 0,
                            date: taskdata.date,
                            startTime: taskdata.startTime,
                            endTime: taskdata.endTime,
                            color: taskdata.color,
                            remind: taskdata.remind,
                            repeat: taskdata.repeat,
                            id: taskdata.id,
                          );
                          Provider.of<Database_prov>(context, listen: false)
                              .updateTask(task);
                          Navigator.of(context).pop();
                        }),
                    SizedBox(
                      height: height / 30,
                    ),
                    Mbutton(
                        width: width,
                        height: height,
                        colors: [
                          Colors.green,
                          Colors.green.withOpacity(.8),
                        ],
                        txt: "Delte Task",
                        wid: const Icon(
                          IconBroken.Close_Square,
                          color: Colors.white,
                        ),
                        func: () async {
                          Provider.of<Database_prov>(context, listen: false)
                              .deleteTask(taskdata.id!);
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
