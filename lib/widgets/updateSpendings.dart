

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
class UpdateSpendings extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;
String stage="main";
// ignore: use_key_in_widget_constructors
UpdateSpendings({required this.project});

  @override
  UpdateSpendingsState createState() => UpdateSpendingsState();
}
int pmttoken=0;
class UpdateSpendingsState extends State<UpdateSpendings> {
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
          const  Text("Update Spendings",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text('Call this to make the Economy contract account for your contribution to this project.\n\nIt will be reflected in the "Native Spent" data point on your user profile.'
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
                           print("updating");
                            String cevine = await cf.updateContributorSpendings(widget.project);
                           print("dupa cevine");
                          if (cevine.contains("nu merge")){
                              print("nu merge din setParty");
                              setState(() { widget.stage="error";});
                              return;
                          }
                          try {
                            int cheltuit= await cf.getNativeSpent(Human().address!);
                            Human().user!.nativeSpent=cheltuit;
                            usersCollection.doc(Human().address).set(Human().user!.toJson());
                          } catch (e) {
                            
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

