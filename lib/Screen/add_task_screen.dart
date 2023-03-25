import 'dart:math';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder/local_style/icons.dart';
import 'package:reminder/widgets/my_button.dart';

import '../Models/task_model.dart';
import '../Providers/Database.dart';
import '../Providers/notification_services.dart';
import '../local_style/Local_styles.dart';
import '../colors.dart';
import '../widgets/input_field.dart';
class AddTaskScreen extends StatefulWidget {

  const AddTaskScreen({Key? key}) : super(key: key);
  static const scid="AddTask_Screen";

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 20)))
      .toString();
  int _selectedRemind = 10;
  List<int> remindList = [
    10,
    30,
    60,
    1440,
  ];
  String _selectedRepeat = 'Never';
  List<String> repeatList = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
  ];


  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return Scaffold(
      appBar:  _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              InputField(
                title: 'Title',
                hint: 'Enter title',
                controller: _titleController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: Icon(
                    IconBroken.Calendar,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              startAndEndTimeInputField(),
              remindInputField(),
              repeatInputField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 20),
                    child: _colorPalette(),
                  ),
                ],
              ),
              SizedBox(height: height/30,),
              Mbutton(width: width, height: height, colors: [local_red,
                local_blue,], txt: "Submit", wid: Icon(IconBroken.Shield_Done,color: Colors.white,), func: () async {
                TaskModel task = TaskModel(
                  title: _titleController.text,
                  isCompleted: 0,
                  isFavorites: 0,
                  date: _selectedDate.toString(),
                  startTime: _startTime,
                  endTime: _endTime,
                  color: _selectedColor,
                  remind: _selectedRemind,
                  repeat: _selectedRepeat, id:Random.secure().nextInt(1000) ,
                );

                DateTime now = DateTime.now();
                String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                await Provider.of<Database_prov>(context,listen: false).createTask(task);
                await Provider.of<Database_prov>(context,listen: false).getTasks();


                //assign two variables for remotenotification and android notification




                NotificationHelper noti=NotificationHelper();

               var start=DateFormat.jm().parse(_startTime).subtract(Duration(minutes:task.remind!));
                print("${start.hour}  : ${start.minute}");


               noti.scheduledNotification(hour: start.hour, minutes: start.minute, id: task.id!, sound: "notification",task: task);
               setState(() {

               });
               Navigator.of(context).pop();

              })
            ],
          ),
        ),
      ),
    );
  }
  Row startAndEndTimeInputField() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            hint: _startTime,
            title: 'Strat Time',
            widget: IconButton(
              onPressed: () =>
                  _getTimeFromUser(isStartTime: true),
              icon: const Icon(
                IconBroken.Time_Circle,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Expanded(
          child: InputField(
            hint: _endTime,
            title: 'End Time',
            widget: IconButton(
              onPressed: () =>
                  _getTimeFromUser(isStartTime: false),
              icon: const Icon(
                IconBroken.Time_Circle,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputField repeatInputField() {
    return InputField(
      hint: _selectedRepeat,
      title: 'Repeat',
      widget: Row(
        children: [
          DropdownButton(
            dropdownColor: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            items: repeatList
                .map(
                  (value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
                .toList(),
            icon: const Icon(
              IconBroken.Arrow___Down_2,
              color: Colors.grey,
            ),
            elevation: 4,
            iconSize: 32,
            underline: Container(
              height: 0,
            ),
            style: TextStyle(),
            onChanged: (String? newvalue) {
              setState(() {
                _selectedRepeat = newvalue!;
              });
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  InputField remindInputField() {
    return InputField(
      hint: _selectedRemind > 60
          ? '1 day early'
          : _selectedRemind == 60
          ? '1 hour early'
          : '$_selectedRemind minutes early',
      title: 'Remind',
      widget: Row(
        children: [
          DropdownButton(
            dropdownColor: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            items: remindList
                .map<DropdownMenuItem<String>>(
                  (int value) => DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(
                  value == 60
                      ? '1 hour'
                      : value == 1440
                      ? '1 day'
                      : ' $value minutes',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
                .toList(),
            icon: const Icon(
              IconBroken.Arrow___Down_2,
              color: Colors.grey,
            ),
            elevation: 4,
            iconSize: 32,
            underline: Container(
              height: 0,
            ),
            style: TextStyle(),
            onChanged: (String? newvalue) {
              setState(() {
                _selectedRemind = int.parse(newvalue!);
              });
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon:  Icon(IconBroken.Arrow___Left_2,color: Colors.black,),
        onPressed: (){
          Navigator.of(context).pop();
        },

      ),
      backgroundColor: Colors.white,
      title: const Text(
        'Add Task',style: TextStyle(
        color: Colors.black
      ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty) {
      _createTask();
      print('################# SOMETHING add ##########');
    } else if (_titleController.text.isEmpty) {

    } else {
      print('################# SOMETHING BAD ##########');
    }
  }

  _createTask() async {
    final task = Tasks(
      title: _titleController.text,
      isCompleted: 0,
      isFavorites: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    );

  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Wrap(
              children: appColors.map((e) => GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    backgroundColor:e,
                    radius: 16,
                    child: _selectedColor == appColors.indexWhere((element) => e==element)
                        ? const Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                onTap: () {
                  setState(() {

                    _selectedColor =appColors.indexWhere((element) => e==element) ;
                  });
                },
              ),).toList()

            ),
          ],
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {

    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formatttedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = _formatttedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatttedTime;
      });
    } else {
      print('time Canceld');
    }
  }

}
