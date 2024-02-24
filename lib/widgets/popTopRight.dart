// ignore_for_file: must_be_immutable

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:trustless/widgets/projectDetails.dart';
import '../main.dart';
import '../utils/reusable.dart';

class PopRight extends StatefulWidget {
 PopRight({super.key});
   bool? isUser;
  @override
  State<PopRight> createState() => _PopRightState();
}

class _PopRightState extends State<PopRight>with TickerProviderStateMixin {
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
      duration: const Duration(seconds: 1),
    );
    controller!.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        left = -0.3;
        down = 1.3;
        spread = 0.3;
        sime = MediaQuery.of(context).size.width/3.1;
        gro = 0;
        height = MediaQuery.of(context).size.height/2;
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      opa = 1;
      gro = 500.0;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 900,height: 800,child: Column(
      children: [
        const Spacer(),
        AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            padding: const EdgeInsets.symmetric(vertical: 4),
            // width: sime-MediaQuery.of(context).size.width/10,
            color: Theme.of(context).cardColor,
            child: Center(
                // ignore: deprecated_member_use
                child: TyperAnimatedTextKit(
              isRepeatingAnimation: false,
              speed: const Duration(milliseconds: 75),
              text: const [ 'TRUSTLESS BUSINESS ENVIRONMENT',],
              textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold
                  // fontFamily: "OCR-A",
                  ),
            )),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: opa,
            child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                const  SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("Economy Contract address: ",
                          style: TextStyle(fontFamily: "Roboto Mono")),
                          const SizedBox(width: 40),
                          Text(getShortAddress(sourceAddress)),
                          const SizedBox(width: 8),
                          TextButton(onPressed: (){
                            copied(context, sourceAddress);
                          }, child: const Icon(Icons.copy))

                    ],
                  ),
                  const SizedBox(height: 5),
                        ])
                    ]),
                  ),
                  const SizedBox(height: 25),
          const SizedBox(height: 25),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1600),
              opacity: opa,
              child: Container(
                width: 420,
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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
              const Spacer(),
            AnimatedOpacity(
                duration: const Duration(milliseconds: 1300),
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
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color:  Theme.of(context).canvasColor,),
                          const SizedBox(width: 7),
                          Text(
                            "Create a Project",
                            style: TextStyle(
                              color:  Theme.of(context).canvasColor,
                                ),
                          )
                        ],
                      ),
                    ))),
               const Spacer()
      ],
    ),);
    
  }
}