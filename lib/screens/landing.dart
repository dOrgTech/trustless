
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/widgets/action.dart';
import 'package:trustless/widgets/governance.dart';
import 'package:trustless/widgets/popTopLeft.dart';
import '../main.dart';
import '../utils/reusable.dart';
import '../widgets/awe.dart';
import '../widgets/footer.dart';
import '../widgets/gameoflife.dart';
import '../widgets/projectDetails.dart';

class Landing extends StatefulWidget {
   bool done=false;
  bool wrapper=false;
  @override
  State<Landing> createState() => _LandingState();
}

    double opa0 = 0;
    double opa1 = 0;
    double opa2 = 0;
    double opa3 = 0;
    double h1 = 0;
    double w1 = 20;
    double h2 = 0;
    double w2 = 20;
    double h3 = 0;
    double w3 = 20;
class _LandingState extends State<Landing> {
  void initState() {
     widget.done=false;
   if (widget.done==false){
         Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opa0 = 1;
        w1 = 200;
        h1 = 114;
        widget.done=true;
      });
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        w2 = 200;
        h2 = 114;
      });
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        h3 = 114;
        opa2 = 1;
      });
    });
   }
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        opa3 = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 670), () {
      setState(() {
        opa1 = 1;
      });
    });
    super.initState();
  }
    Widget addresses(what, address,context){
    return 
    Container(
       padding: const EdgeInsets.only(top: 4, bottom: 2),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          SizedBox(
            child: Text(what, textAlign: TextAlign.end, style: const TextStyle( fontWeight: FontWeight.w600),)),
          const SizedBox(width: 10,),
          Text(address , style: TextStyle()),
         const SizedBox(width: 10,),
          TextButton(
            child: const Icon(Icons.copy),
            onPressed: (){ 
            Clipboard.setData(
                ClipboardData(
                  text:address));
            showBottomSheet( 
              context: (context),
             builder:(context){

              return SizedBox(
              width:240,
              height:70,
              child:Center(child: Text("Address copied to cliboard", style: (TextStyle(fontSize: 20)),)));
          }, 
          );
            })
        ],),
    );
}

Widget dreapta(){
  return  Positioned(
          right: 0,
          top: 0,
          child: Container(
              decoration: BoxDecoration(
                  // color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(170))),
              child: Center(
                child:BuyATN(),
              )))
   ;
}
 Widget douaranduri(ce, cat){
              return   AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:Colors.black38,
                                width: 0.9),
                            color:
                                const Color.fromARGB(49, 189, 189, 189),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        height: h2,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: const Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  ce,
                                 cat,
                                  )),
                        ));
                  }

                  Widget balance(ce, cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [        
            Text(
              ce,
              style:  GoogleFonts.robotoMono(fontSize: 16),
            ),
        const SizedBox(
          height: 12,
        ),
        Text(
          cat,
          style:  GoogleFonts.robotoMono(
            fontSize: 18,
            // color: const Color(0xff4a4a4a),
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
                  
            Widget treiranduri(ce,ad,trei ){
              return  AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                      border: Border.all(
                              color:Colors.black38,
                          width: 0.9),
                      color:
                          const Color.fromARGB(49, 189, 189, 189),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: h3,
                  width: 200,
                  child: AnimatedOpacity(
                    opacity: opa2,
                    duration: const Duration(milliseconds: 800),
                    child: Center(
                      child:
                 Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Text(ce),
                     Text(ad),
                     Text(trei),
                   ],
                 ), 
                      
                     ),
                  )
                      );
      }

  @override
  Widget build(BuildContext context) {
    
    return  
    MediaQuery.of(context).size.aspectRatio<1?
  MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.7),
       child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
         child: Stack(
           children: [
          Opacity(
                  opacity: 0.05,
                  child: GameOfLife()),
             ListView(
               children: [
                SizedBox(
                  width: 400,
                  child: AnimatedStatsDisplay()),
                 Container(
                   color:Theme.of(context).colorScheme.onError.withOpacity(0.6),
                   child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      const SizedBox(height: 30),
                       Padding(
                          padding: const EdgeInsets.all(28.0),
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
                          Container(
                          height:150,
                              padding: const EdgeInsets.all(9.0),
                              child: Center(
                                child: Stack(
                                  children: [
                                    Image.asset("assets/newlogo_layer3.png",height: 140,),
                                    AnimatedOpacity(
                                      duration: Duration(milliseconds: 1500),
                                      opacity: opa2,
                                      child: 
                                    Image.asset("assets/newlogo_layer1.png",height: 140,)
                                    ),
                                  ],
                                ),
                              ),
                                ),
                     ],
                   ),
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
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: ActivityFeed()
                    ),  
                Footer()
               ],
             ),
           ],
         ),
       ),
     )
    :
    Container(
      height: MediaQuery.of(context).size.height+100,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
           Opacity(
                opacity: 0.05,
                child: GameOfLife()),
                // child: Container()), 
              

          CoolAnimationWidget(),
            Positioned(
                  bottom: 0,
                  child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height:150 ,
                          child: Footer()),
                ),
          // SizedBox(
          //         height: MediaQuery.of(context).size.height,
          //         width:  MediaQuery.of(context).size.width,
          //         child:  Scrollbar(
          //         child:  SingleChildScrollView(
          //             child: Column(
          //               children: [
                          
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Container(
          //                         width: MediaQuery.of(context).size.width/2,
          //                         margin: const EdgeInsets.all(40),
          //                         child: Wrap(
          //                           spacing: 20,
          //                           runSpacing: 20,
          //                           alignment: WrapAlignment.center,
          //                           runAlignment: WrapAlignment.center,
          //                             children: [
          //                               // treiranduri("Treasury Balance","3023", "1 tokens"),
          //                               douaranduri("XTZ Stored", valueInContracts.toString()),
          //                               douaranduri("USDT Stored", valueInContracts.toString()),
          //                               douaranduri("Active Projects", 
          //                               projects.length.toString()),
          //                               // activeProjects.toString()),
          //                               douaranduri("Total XTZ Paid", 0.toString()),
          //                               douaranduri("Total USDT Paid", 3323.toString()),
          //                               ]),
          //                       ),
          //                       dreapta()
          //                     ],
          //                   ),
          //                   const  SizedBox(height: 88),
          //                 // Poll(proposalAddress: "0xdsuiqhsudh")
          //               ],
          //             ),
          //           )
          //           ),
          //         ),
        ],
      ),
    );
            }
          
      
  }
