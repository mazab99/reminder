import 'dart:convert';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:reminder/Screen/Home_screen.dart';

import '../Providers/Database.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with TickerProviderStateMixin {
  AnimationController? logocontrol,progresscontrol;
  Animation? Logo_animate,progress_animate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logocontrol=AnimationController(vsync: this,duration: Duration(seconds: 5));
    Logo_animate=Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: logocontrol!, curve: Curves.easeInOutCubicEmphasized));
    Logo_animate!.addListener(()=>setState(() {}));
    progresscontrol=AnimationController(vsync: this,duration: Duration(seconds: 2));
    progress_animate=Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: logocontrol!, curve: Curves.easeInOutCubicEmphasized));
    progress_animate!.addListener(()=>setState(() {}));
    logocontrol!.forward().then((value){
      progresscontrol!.forward().then((value)async {

        Future.delayed(Duration(milliseconds: 100),() async {
          try{
            await Provider.of<Database_prov>(context,listen: false).init_db();

          }
          catch(e)
          {
            await Provider.of<Database_prov>(context,listen: false).Opren_db();
            await Provider.of<Database_prov>(context,listen: false).init_db();
          }

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false);

        });
      });


    });
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body:
            Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: Logo_animate!.value,
                    child: Container(
                      height: height/2.5,
                      width: width/1.5,
                      child: Container(

                        margin: EdgeInsets.symmetric(horizontal: width/10,vertical: height/10),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/img/logo.png',
                            ),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    ),
                  ),
                  ShaderMask(


                    shaderCallback: (bounds) {
                      return RadialGradient(
                        center: Alignment.topLeft,
                        radius: .5,
                        colors: [Color.fromRGBO(205, 69, 72, 1),Color.fromRGBO(66 ,133 ,211, 1)],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child:   Container(
                      margin: EdgeInsets.all(width/20),
                      padding: EdgeInsets.all(width/20),

                      child: Opacity(
                        opacity:progress_animate!.value ,
                        child: Container(
                          height: height/14,
                          width: width/5,
                          child: Opacity(
                            opacity: .9,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballBeat, /// Required, The loading type of the widget
                                colors: const [Colors.white],       /// Optional, The color collections
                                strokeWidth: 1,


                                backgroundColor: Colors.transparent,      /// Optional, Background of the widget
                                pathBackgroundColor: Colors.transparent   /// Optional, the stroke backgroundColor
                            ),
                          ),
                        )
                      ),
                    ),
                  ),

                ],
              ),
            ),


      ),
    );
  }
}
