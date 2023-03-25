
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:reminder/local_style/Local_styles.dart';

import '../Models/task_model.dart';
import '../Providers/Database.dart';
import '../Screen/Add_Task_Screean.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../local_style/icons.dart';
import '../ref.dart';
import 'My_bottom_sheet.dart';
import 'My_button.dart';

showTasks(
    {required context,
    required List<TaskModel> tasks,
    required height,
    required width}) {
  return Stack(
    children: [
      Consumer<Database_prov>(
        builder: (context, prov, builder) => Container(
          height: height,
          padding: EdgeInsets.only(bottom: height / 10),
          // height: 50,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Slidable(
                  closeOnScroll: true,
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        onPressed: (context) async {
                          prov.deleteTask(tasks[index].id!);
                        },
                        foregroundColor: Colors.red,
                        icon: IconBroken.Close_Square,
                        label: 'Cancel',
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        onPressed: (context) async {
                          TaskModel task = TaskModel(
                            title: tasks[index].title,
                            isCompleted: tasks[index].isCompleted,
                            isFavorites: tasks[index].isFavorites == 0 ? 1 : 0,
                            date: tasks[index].date,
                            startTime: tasks[index].startTime,
                            endTime: tasks[index].endTime,
                            color: tasks[index].color,
                            remind: tasks[index].remind,
                            repeat: tasks[index].repeat,
                            id: tasks[index].id,
                          );
                          prov.updateTask(task);
                        },
                        foregroundColor: tasks[index].isFavorites == 1
                            ? Colors.red
                            : Colors.grey,
                        icon: IconBroken.Heart,
                        label: tasks[index].isFavorites == 1
                            ? 'delete from favourites'
                            : "add to favourites",

                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 20, vertical: height / 220),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            TaskModel task = TaskModel(
                              title: tasks[index].title,
                              isCompleted:
                                  tasks[index].isCompleted == 0 ? 1 : 0,
                              isFavorites: tasks[index].isFavorites,
                              date: tasks[index].date,
                              startTime: tasks[index].startTime,
                              endTime: tasks[index].endTime,
                              color: tasks[index].color,
                              remind: tasks[index].remind,
                              repeat: tasks[index].repeat,
                              id: tasks[index].id,
                            );
                            prov.updateTask(task);
                          },
                          icon: tasks[index].isCompleted == 1
                              ? Icon(
                                  Icons.check_box,
                                  color:
                                      Choose_color[tasks[index].color!.toInt()],
                                  size: 30,
                                )
                              : Icon(Icons.check_box_outline_blank_rounded,
                                  color: Choose_color[
                                      tasks[index].color!.toInt()]),
                        ),
                        Expanded(
                          child: Text(
                            tasks[index].title!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              myBottomSheet(
                                context: context,
                                height: height,
                                width: width,
                                taskdata: tasks[index],
                              );
                            },
                            icon: const Icon(Icons.more_vert_rounded,
                                color: Colors.grey, size: 25)),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
      Positioned(
        bottom: MediaQuery.of(context).size.height / 200,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20,
              vertical: MediaQuery.of(context).size.height / 40),
          child: Mbutton(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              colors: [
                local_red,
                local_blue,
              ],
              txt: "Add Task",
              wid: Icon(
                IconBroken.Plus,
                color: Colors.white,
              ),
              func: () async {
                //await Database_prov.init_db();
                // await Database_prov.createTask(TaskModel(id:0, title:"gg", isCompleted: 0, isFavorites:0 , date: DateTime.now().toString(), startTime: DateTime.now().toString(), endTime: DateTime.now().toString(), color: 1, remind: 0, repeat: "no"));
                TaskModel task = TaskModel(
                  title: "_titleController.text",
                  isCompleted: 0,
                  isFavorites: 0,
                  date: "DateFormat.yMd().format(_selectedDate)",
                  startTime: "_startTime",
                  endTime: "_endTime",
                  color: 1,
                  remind: 0,
                  repeat: "_selectedRepeat",
                  id: 110,
                );
                /* await Database_prov.createTask(task);*/
                //await Database_prov.getTasks().then((val) => print(val[0].title));
                //Database_prov.deleteTask(0);
                // await Database_prov.getTasks().then((val) async => await Database_prov.updateTask(val[0]));

                Navigator.of(context).pushNamed(AddTaskScreen.scid);

                print("ok");
              }),
        ),
      )
    ],
  );
}
