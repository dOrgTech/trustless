

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entities/project.dart';
const String escape = '\uE00C';




class SetParty extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project=Project(isUSDT: false);

// ignore: use_key_in_widget_constructors
SetParty() ;

  @override
  SetPartytate createState() => SetPartytate();
}
int pmttoken=0;
class SetPartytate extends State<SetParty> {
  
  @override
  Widget build(BuildContext context) {
    
    List<DropdownMenuItem<int>> paymentTokens=[];
    return
    Container(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
              width: 0.3,
            ),
          ),
          // width: MediaQuery.of(context).size.width*0.7,
          height:450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             
            const  SizedBox(
                width: 360,
                child: Text("Set Other Party",
                textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 19), 
                  ),
              ),
             
            SizedBox(
              width:450,
              child: TextField(
                onChanged: (value) {
                  widget.project.terms=value;
                },
                style: const TextStyle(fontSize: 13),
                decoration:  const InputDecoration(
                  labelText: "Other party address",
                  hintText: 'Cannot be changed after submitting.'),),
            ),
          //  const SizedBox(height: 90),
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
            
                    // setState(() {widget.loading=true;});
                    // String projectAddress=await createClientProject(
                    //   widget.project,
                    //   this,
                     
                    //   );
                    //   receivePort.listen((message) {
                    //   projectAddress=message;
                    // //  });               
                    Navigator.of(context).pop();
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

  bool pressedName = false;
  bool pressedDesc = false;

 
}