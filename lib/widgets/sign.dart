

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

class Sign extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;

// ignore: use_key_in_widget_constructors
Sign({required this.project}) ;

  @override
  SignState createState() => SignState();
}
int pmttoken=0;
class SignState extends State<Sign> {
  @override
  Widget build(BuildContext context) {
    
 
    return

    ! (Human().address==widget.project.contractor) ? 
    Container(
      child:Text("You are not signed in as the designated Contractor.")
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
          const  Text("Sign Contract",
            textAlign: TextAlign.center,
             style: TextStyle(fontSize: 19), 
              ),
            SizedBox(width: 380,
            child:Text("Please ensure that you have reviewed and agree to the Project Terms as well as with the Author's choice of Arbiter. \n\nUpon taking this action, the funds held by this contract will be locked until one of the parties releases them to the other or a dispute is settled."
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
                      print("Signing contract");
                      widget.project.status="ongoing";
                      projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());

                    Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                  },
                   child:  Center(
                  child: Text("SUBMIT", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, 
                    color:Theme.of(context).brightness==Brightness.dark?Color.fromARGB(255, 0, 0, 0):Color.fromARGB(255, 255, 255, 255)),
                ))),
              ),
            ),
            ],
          )
    );

  }

 
}