import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder/Providers/Database.dart';
import 'package:reminder/local_style/icons.dart';

import '../Models/task_model.dart';
import '../widgets/date_bar.dart';
import '../widgets/show tasks.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  static const scid = "clender_page";

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Database_prov>(
      builder: (context, prov, ch) => FutureBuilder(
        future: prov.getTasks(),
        builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) =>
            !snapshot.hasData
                ? Center(
                    child: Text("no tasks"),
                  )
                : Scaffold(
                    appBar: _appBar(),
                    body: Column(
                      children: [
                        _calender(),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                            child: DateBar(
                          dt: _selectedDate,
                        )),
                        showTasks(
                          context: context,
                          tasks: snapshot.data!.where((element) {
                            DateFormat dateFormat =
                                DateFormat("yyyy-MM-dd HH:mm:ss");
                            DateTime dateTime = dateFormat.parse(element.date!);
                            print(dateTime);
                            return DateFormat.yMMMd().format(_selectedDate) ==
                                DateFormat.yMMMd().format(dateTime);
                          }).toList(),
                          height: MediaQuery.of(context).size.height / 1.6,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        'Schedule',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(
          IconBroken.Arrow___Left_2,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _calender() {
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      margin: const EdgeInsets.all(10),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: Colors.green,
        dateTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        dayTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        monthTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        onDateChange: (newselectedDate) {
          setState(() {
            _selectedDate = newselectedDate;
          });
        },
      ),
    );
  }
}
