

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';  
import '../entities/human.dart';
import '../entities/project.dart';
import '../entities/token.dart';
import '../main.dart';
const String escape = '\uE00C';

class Release extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;
// ignore: use_key_in_widget_constructors
Release({required this.project}) ;
  @override
  ReleaseState createState() => ReleaseState();
}
int pmttoken=0;
class ReleaseState extends State<Release> {
  String? selectedToken;
  String? selectedAddress;
  TextEditingController amountController = TextEditingController();
  String amount="";
  @override
  Widget build(BuildContext context) {
    List<String> paymentTokens=[];
    for (Token t in widget.project.acceptedTokens!){
      paymentTokens.add("${t.symbol} (${t.name})");
      }
    return
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
          const  Text("Release Funds to Contractor",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text("You are voting to release the payment to the Contractor."+
            "\n\nYour vote is weighted by the amount that you contributed to the Project's funding. The funds will be released once 60% of the total voting power is calling this function."
            ,style: TextStyle(color: Theme.of(context).indicatorColor),
            )
            ),
            Padding(
              padding: const EdgeInsets.only(top:58),
              child: SizedBox(
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
                    bool foundit=false;
                    for (var entry in widget.project.contributions.entries) {
                      var key = entry.key;
                      if (key == Human().address) {
                        foundit=true;
                        print("found it");
                        widget.project.contributorsReleasing[key] = widget.project.contributions[key]!; // Update the value to 0
                        widget.project.contributorsDisputing[key] = 0; 
                        if (widget.project.contributorsReleasing.values.fold(0, (a, b) => a + b) / widget.project.contributions.values.fold(0, (a, b) => a + b) >= 0.6)
                        {
                          widget.project.status="closed";
                        }
                        await projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                        break; // Exit the loop
                      }
                      print("the loop was  not broken");
                    }
                    if (foundit==false){print("Still not finding it");}
                    Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                     
                  },
                   child: const Center(
                  child: Text("SUBM333IT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                )),
              ),
            ),
            ],
          )
       );
  }
}