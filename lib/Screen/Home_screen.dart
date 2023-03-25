import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:reminder/Models/task_model.dart';
import 'package:reminder/Screen/Add_Task_Screean.dart';
import 'package:reminder/local_style/icons.dart';
import 'package:reminder/ref.dart';
import 'package:reminder/widgets/My_button.dart';

import '../Providers/Database.dart';
import '../widgets/show tasks.dart';
import 'calender_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return DefaultTabController(
      length: 4,
      child: Consumer<Database_prov>(
        builder:(context,prov,ch)=> StreamBuilder(
          stream: prov.getTasks().asStream(),
          builder:(context,AsyncSnapshot<List<TaskModel>> snapshot)=> !snapshot.hasData?Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          ):Scaffold(
            appBar: AppBar(
                backgroundColor:Colors.white ,
              title: Text("Board",style: TextStyle(
                color: Colors.black
              ),),
              actions:[
                IconButton(icon: Icon(IconBroken.Calendar, color: Colors.black),
                onPressed: (){
                  Navigator.of(context).pushNamed(CalenderPage.scid);
                },
                ),
              ],
              bottom: TabBar(

                labelPadding: EdgeInsets.symmetric(horizontal: 0),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.red,
                indicatorWeight: 4,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                  Tab(
                    text: 'Uncompleted',
                  ),
                  Tab(
                    text: 'Favorites',
                  ),
                ],
              ),
          ),
          body: TabBarView(

          children:[
            showTasks(
              context: context,
                 tasks:snapshot.data!.toList(),
              height: height,
              width: width
            ),
            showTasks(
                context: context,
                tasks:snapshot.data!.where((element) => element.isCompleted==1).toList(),
                height: height,
                width: width
            ),

            showTasks(
                context: context,
                tasks:snapshot.data!.where((element) => element.isCompleted==0).toList(),
                height: height,
                width: width
            ),
            showTasks(
                context: context,
                tasks:snapshot.data!.where((element) => element.isFavorites==1).toList(),
                height: height,
                width: width
            ),
          ]
            ),
          ),
        ),
      ),
    );
  }


}



