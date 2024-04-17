

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';  // Import this for TextInputFormatter
import 'package:trustless/entities/human.dart';
import 'package:trustless/entities/user.dart';
import 'package:trustless/main.dart';
import 'package:trustless/widgets/somethingsWrong.dart';
import 'package:trustless/widgets/waiting.dart';

import '../entities/project.dart';
import '../entities/token.dart';
const String escape = '\uE00C';

class ReclaimFee extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;
String stage="main";
// ignore: use_key_in_widget_constructors
ReclaimFee({required this.project}) ;

  @override
  ReclaimFeeState createState() => ReclaimFeeState();
}
int pmttoken=0;
class ReclaimFeeState extends State<ReclaimFee> {

  Widget main(){
      switch (widget.stage) {
          case "main":
            return stage0();
          case "waiting":
            return SizedBox(height:450,child: WaitingOnChain());
          case "error":
            return SomethingWentWrong(project:widget.project);
          default:       
            return stage0();
      }
  }


  @override
 Widget build(BuildContext context) {return main();}

 Widget stage0(){
 return 
     
   (! (Human().address!.toLowerCase()==widget.project.contractor!.toLowerCase()) && 
   ! (Human().address!.toLowerCase()==widget.project.author!.toLowerCase()) 
    )?
    Container(
      height: 190,
      child:Column(
        children: [
          SizedBox(height: 40),
          Text("The unused arbitration fee can be only reclaimed by the Author or the Contractor of the project. "),
          SizedBox(height: 40),
          ElevatedButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Got it.",style: TextStyle(color:Theme.of(context).canvasColor),))
        ],
      )
    ) 
    
    :
    
    Container(
      width: 650,
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
              width: 0.3,
            ),
          ),
          // width: MediaQuery.of(context).size.width*0.7,
          height:650,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          const  Text("Update Reputation",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text("This action will increment your `spendings` record in the Economy contract to reflect your activity in this project. You only need to call this function if the project concluded without a dispute, otherwise the update"
            ,style: TextStyle(color: Theme.of(context).indicatorColor),
            )
            ),
            Padding(
              padding: const EdgeInsets.only(top:58),
              child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       SizedBox(height: 30,width: 150,
                    child: Opacity(
                      opacity: 0.6,
                      child: TextButton(
                        style: ButtonStyle(
                          // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                          // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                          elevation: MaterialStateProperty.all(0.0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                        ),
                          onPressed:
                        (){
                        Navigator.of(context).pop();
                        },
                          child: const Center(
                        child: Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 130,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                        elevation: MaterialStateProperty.all(1.0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                      ),
                      onPressed: ()async{
                        setState(() {widget.stage="waiting";});
                          print("ReclaimFeeing contract");
                          String cevine = await cf.reclaimFee(widget.project);
                           print("dupa cevine");
                             if (cevine.contains("nu merge")){
                              print("nu merge din setParty");
                              setState(() { widget.stage="error";});
                              return;
                            }
                        // widget.project.status="ongoing";
                        await projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                        Human().user!.projectsContracted.add(widget.project.contractAddress!);
                        await usersCollection.doc(Human().address).set(Human().user!.toJson());
                        User u;
                        if (!users.any((user) => user.address == Human().address)){users.add(Human().user!);}
                        if (!users.any((user) => user.address == widget.project.arbiter)){
                            u = User.fromNew(widget.project.arbiter!);
                            u.projectsArbitrated.add(widget.project.contractAddress!);
                            users.add(u);
                         }else{u = users.firstWhere((user) => user.address == widget.project.arbiter);}
                          await usersCollection.doc(widget.project.arbiter).set(u.toJson());
                        Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                      },
                       child:  Center(
                      child: Text("SUBMIT", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, 
                        color:Theme.of(context).brightness==Brightness.dark?Color.fromARGB(255, 0, 0, 0):Color.fromARGB(255, 255, 255, 255)),
                    ))),
                  ),
                ],
              ),
            ),
            ],
          )
    );
 }
}