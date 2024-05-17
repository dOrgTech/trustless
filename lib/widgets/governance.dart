

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/newGenericProject.dart';
import 'package:trustless/widgets/projectDetails.dart';
import 'package:trustless/screens/prelaunch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

import '../screens/projects.dart';

class BuyATN extends StatefulWidget {
 BuyATN();
 double opa_aur = 0;
  bool? isUser;
  
  @override
  _BuyATNState createState() => _BuyATNState();
}

class _BuyATNState extends State<BuyATN> with TickerProviderStateMixin {
  double left = 0.0;
  double opa = 0;
  
  double spread = 0.0;
  double down = 0.0;
  double sime = 3;
  double gro = 0;
  double height = 0;
  AnimationController? controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    controller!.forward();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        left = -0.3;
        down = 1.3;
        spread = 0.3;
        sime = MediaQuery.of(context).size.width/3.1;
        gro = 0;
        height = MediaQuery.of(context).size.height/1.2;
      });
    });
    Future.delayed(Duration(milliseconds: 500), () {
      opa = 1;
      gro = 500.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
      widget.opa_aur = 0.3;
      });
    });
    List<Color> colors = [
      Theme.of(context).canvasColor.withOpacity(0.99),
      Theme.of(context).canvasColor.withOpacity(0.89)
    ];
    List<double> stops = [0.03, 5.8];
    return Consumer(
      builder: (context,ref,child) {
        return Opacity(
          opacity: 0.8,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              width: sime,
              height: height,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).indicatorColor.withOpacity(0.3),
                      blurRadius: 7.0, // soften the shadow
                      spreadRadius: spread, //extend the shadow
                      offset: Offset(
                        left,
                        down,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150)),
                  gradient: RadialGradient(colors: colors, stops: stops)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 
                          // Placeholder(),
                          // Pattern(),
                           Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Center(
                                  child: TyperAnimatedTextKit(
                    isRepeatingAnimation: false,
                    pause: const Duration(seconds: 4),
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 31),
                    text: const ["Self-Sufficient\nDecentralized\nBusiness\nEnvironment"],
                    textStyle:TextStyle(
                        height: 1.5,
                       
                        fontSize: 23),
                                  ),
                                ),
                              ),
                         Padding(
                         padding: const EdgeInsets.all(9.0),
                         child: Stack(
                           children: [
                             Image.asset("assets/newlogo_layer3.png"),
                             AnimatedOpacity(
                               duration: Duration(milliseconds: 1500),
                               opacity: widget.opa_aur,
                               child: 
                             Image.asset("assets/newlogo_layer1.png")
                             ),
                           ],
                         ),
                            ),
                             ],
                      )),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    padding: EdgeInsets.symmetric(vertical: 4),
                    // width: sime-MediaQuery.of(context).size.width/10,
                    color: Theme.of(context).cardColor,
                    child: Center(
                        child:
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Economy Contract address: ",
                                  style: TextStyle(fontFamily: "Roboto Mono")),
                                  SizedBox(width: 40),
                                  Text(getShortAddress(sourceAddress)),
                                  SizedBox(width: 8),
                                  TextButton(onPressed: (){
                                    copied(context, sourceAddress);
                                  }, child: Icon(Icons.copy))
                            ],
                          ),
                        ),
                  ),
                  // SizedBox(height: 20),
                  // AnimatedOpacity(
                  //   duration: Duration(seconds: 1),
                  //   opacity: opa,
                  //   child:
                  //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       children: [
                  //         SizedBox(height: 4),
                         
                  //         SizedBox(height: 5),
                  //       ])
                  //   ]),
                  // ),
                  
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1600),
                    opacity: opa,
                    child: Container(
                      padding:EdgeInsets.all(20),
                      // decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.9)),
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 9),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "An architecture of incentives to help with value emergence. It comes with all the stability of traditional legal contracts and none of the drawbacks.",
                              textAlign: TextAlign.justify,
                              style:
                                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                             Container(
                              width: 183,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.1), // Button background color
                                border: Border.all(
                                  color:Theme.of(context).indicatorColor, // Color of the contour
                                  width: 0.2, // Thickness of the contour
                                ),
                                borderRadius: BorderRadius.circular(4.0), // Match this with your button's border radius if any
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Theme.of(context).indicatorColor.withOpacity(0.1)), // Handle overlay color for ripple effect if needed
                                ),
                                onPressed: () {
                                  launch("https://github.com/dOrgTech/homebase-projects/blob/master/README.md");
                                },
                                child: Center(child: 
                                    Text("Read Docs"),
                                  ),
                              ),
                            )
                           
                        
                          // SizedBox(height: 6),
                          // Text(
                          //     "This is a self-contained architecture of incentives designed to facilitate value emergence"),
                          // Text(
                          //     "* Each of the following 500K tokens sold triggers a 0.00025 ETH increase in price."),
                          
                        ],
                      ),
                    ),
                  ),
                 
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 1300),
                      opacity: opa,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal:34.0),
                              child: const Center(
                                child: Text(
                                "Engage in trustless business arrangements. ",
                                style:
                                    TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                        ),
                              ),
                            ),
                            const SizedBox(height: 22),
                          Padding(
                            padding: const EdgeInsets.only(bottom:30.0),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Theme.of(context).indicatorColor,
                                    elevation: 1),
                                onPressed: () async{
                                  Navigator.of(context).pushNamed("/projects");
                              
                                },
                                child: Container(
                                  width: 168,
                                  height: 36,
                                  padding: EdgeInsets.only(bottom:0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit, color:  Theme.of(context).canvasColor,),
                                      SizedBox(width: 7),
                                      Text(
                                        "Create Project",
                                        style: TextStyle(
                                          color:  Theme.of(context).canvasColor,
                                            ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      )),
                  
                ],
              )),
        );
      }
    );
  }
}