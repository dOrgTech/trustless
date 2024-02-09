

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/projectDetails.dart';

import 'package:web3dart/web3dart.dart';

class BuyATN extends StatefulWidget {
 BuyATN();
 

 
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
  double height = 330;
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
        height = MediaQuery.of(context).size.height/2;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 24),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    padding: EdgeInsets.symmetric(vertical: 4),
                    width: sime-MediaQuery.of(context).size.width/10,
                    color: Theme.of(context).cardColor,
                    child: Center(
                        child: TyperAnimatedTextKit(
                      isRepeatingAnimation: false,
                      speed: Duration(milliseconds: 75),
                      text: [
                        "SELF-REGULATING BUSINESS ENVIRONMENT",
                      ],
                      textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
                          // fontFamily: "OCR-A",
                          ),
                    )),
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: opa,
                    child:
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 4),
                          Row(
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
                          SizedBox(height: 5),
                        ])
                    ]),
                  ),
                  SizedBox(height: 25),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1600),
                    opacity: opa,
                    child: Container(
                      width: 420,
                      decoration: BoxDecoration(color: Theme.of(context).cardColor),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 9),
                          Text(
                            "This is a self-contained architecture of incentives designed to facilitate value emergence. ",
                            style:
                                TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 9),
                          Text(
                            "Engage in fully-trustless business arrangements. ",
                            style:
                                TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(height: 6),
                          // Text(
                          //     "This is a self-contained architecture of incentives designed to facilitate value emergence"),
                          // Text(
                          //     "* Each of the following 500K tokens sold triggers a 0.00025 ETH increase in price."),
                          SizedBox(height: 9)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 39),
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 1300),
                      opacity: opa,
                      child:  TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).indicatorColor,
                              elevation: 1),
                          onPressed: () async{
                              showDialog(
                          context: context,
                          builder: (context) =>  AlertDialog(
                            content: SizedBox(
                              height: 500,
                              width: 500,
                              child:
                             
                              Container(),
                            ),
                          ),
                        );
                          },
                          child: Container(
                            width: 168,
                            height: 36,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color:  Theme.of(context).canvasColor,),
                                SizedBox(width: 7),
                                Text(
                                  "Create a Project",
                                  style: TextStyle(
                                    color:  Theme.of(context).canvasColor,
                                      ),
                                )
                              ],
                            ),
                          ))),
                  SizedBox(height: 30)
                ],
              )),
        );
      }
    );
  }
}