

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';  // Import this for TextInputFormatter
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';

import '../entities/project.dart';
import '../entities/token.dart';
const String escape = '\uE00C';

class Withdraw extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;

// ignore: use_key_in_widget_constructors
Withdraw({required this.project}) ;

  @override
  WithdrawState createState() => WithdrawState();
}
int pmttoken=0;
class WithdrawState extends State<Withdraw> {
  String? selectedToken;
  String? selectedAddress;
  TextEditingController amountController = TextEditingController();
  String amount="";
  @override
  Widget build(BuildContext context) {
    
    List<String> paymentTokens=[];
    for (Token t in widget.project.acceptedTokens!){
      paymentTokens.add(t.symbol +" ("+t.name+")");}
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
          const  Text("Withdraw from project",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text("Claim to your wallet funds along with any economy tokens that might have been awarded. This can be called by backers or/and the contractor, depending on the project stage."
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
                  print("pressed");
                    for (var entry in widget.project.contributions.entries) {
                      var key = entry.key;
                      if (key == Human().address) {
                        print("found it");
                        widget.project.contributions[key] = 0; // Update the value to 0
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
            ),
            ],
          )
    );

  }

 
}