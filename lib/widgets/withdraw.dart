

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';  // Import this for TextInputFormatter
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import 'package:trustless/widgets/somethingsWrong.dart';
import 'package:trustless/widgets/waiting.dart';
import '../entities/project.dart';
import '../entities/token.dart';

const String escape = '\uE00C';
class Withdraw extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;
String stage="main";
// ignore: use_key_in_widget_constructors
Withdraw({required this.project});

  @override
  WithdrawState createState() => WithdrawState();
}
int pmttoken=0;
class WithdrawState extends State<Withdraw> {
  String? selectedToken;
  String? selectedAddress;
  TextEditingController amountController = TextEditingController();
  String amount="";
    Widget main(){
      switch (widget.stage) {
          case "main":
            return stage0();
          case "waiting":
            return SizedBox(height:500, child: WaitingOnChain());
          case "error":
            return SomethingWentWrong(project:widget.project);
          default:       
            return stage0();
        }
  }

  @override
  Widget build(BuildContext context) {
    return main();
  }

  Widget stage0(){
  return  Container(
      width: 650,
      height:650,
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
              width: 0.3,
            ),
          ),
          // width: MediaQuery.of(context).size.width*0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          const  Text("Withdraw from Project",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text("Claim your contribution to this Project back to your wallet.\n\nPost-dispute, if the Arbiter allocates funds to the Contractor, you'll retrieve only a portion of your contribution, proportional to your share of the total project funding."
            ,style: TextStyle(color: Theme.of(context).indicatorColor),
            )
            ),
            Padding(
              padding: const EdgeInsets.only(top:58),
              child: Row(
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
                           print("Signing contract");
                            String cevine = await cf.withdrawAsContributor(widget.project);
                           print("dupa cevine");
                          if (cevine.contains("nu merge")){
                              print("nu merge din setParty");
                              setState(() { widget.stage="error";});
                              return;
                          }
                        for (var entry in widget.project.contributions.entries) {
                          var key = entry.key;
                          if (key == Human().address) {
                            print("found it");
                            widget.project.contributions[key] = "0"; // Update the value to 0
                            projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                            
                            break; // Exit the loop
                          }
                        }
                        Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                      },
                       child: const Center(
                      child: Text("SUBMIT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                    )),
                  ),
                ],
              ),
            ),
            ],
          )
    );
 }
}


class WidthdrawAsContractor extends StatefulWidget {
   WidthdrawAsContractor({super.key, required this.project});
   bool loading=false;
    bool done=false;
    bool error=false;
    Project project;
    String stage="main";
    // ignore: use_key_in_widget_constructors


  @override
  State<WidthdrawAsContractor> createState() => _WidthdrawAsContractorState();


  }

class _WidthdrawAsContractorState extends State<WidthdrawAsContractor>{

  @override
  Widget build(BuildContext context) {
    return Human().address?.toString() != widget.project.contractor?.toLowerCase().toString()?
    SizedBox(height: 230, width: 400, child: Center(child: Column(
      children: [
         const  SizedBox(height:60),
        const Text("You are not signed in as the Contractor of this Project.", textAlign: TextAlign.center,),
         const  SizedBox(height:60),
        ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
        }, child: Text("OK"))
      ],
    ))):
     maina();
  }



 Widget stage0(){
  return   Container(
      width: 650,
      height:650,
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
              width: 0.3,
            ),
          ),
          // width: MediaQuery.of(context).size.width*0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          const  Text("Get Paid",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text("Withdraw payment for work done to your wallet or contract.\n\nPost-dispute, you can only claim what the Arbiter has decided to award you."
            ,style: TextStyle(color: Theme.of(context).indicatorColor),
            )
            ),
            Padding(
              padding: const EdgeInsets.only(top:58),
              child: Row(
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
                            print("Signing contract");
                              String cevine = await cf.withdrawAsContractor(widget.project);
                            print("dupa cevine");
                            if (cevine.contains("nu merge")){
                                print("nu merge din setParty");
                                setState(() { widget.stage="error";});
                                return;
                           }
                        projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                        try
                            {
                              String oldEarned = Human().user!.nativeEarned;
                              String newEarned=oldEarned;
                              cf.getUserRep();
                        }catch (Exception) 
                        {if (kDebugMode) {
                          print("helo");
                        }}
                        await usersCollection.doc(Human().address).set(Human().user!.toJson());
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                      },
                       child: const Center(
                      child: Text("SUBMIT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                    )),
                  ),
                ],
              ),
            ),
            ],
          )
    );
 }
  Widget maina(){
      switch (widget.stage) {
          case "main":
            return stage0();
          case "waiting":
            return SizedBox(height:500, child: WaitingOnChain());
          case "error":
            return SomethingWentWrong(project:widget.project);
          default:       
            return stage0();
        }
}
}