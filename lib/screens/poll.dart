import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:graphite/graphite.dart';
import 'package:trustless/main.dart';
import 'package:webviewx/webviewx.dart';

import '../entities/human.dart';
import '../utils/reusable.dart';
bool block=true;
class Poll extends StatefulWidget {
   Poll({super.key});
  bool _isConnecting=false;
  String initialContent= 'https://app.sli.do/event/ai2YkxtEj12HosChouNHod';
  List<String>allowed=[];
  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
 String initialContent='https://app.sli.do/event/ai2YkxtEj12HosChouNHod';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Padding(
          padding: const EdgeInsets.only(left:80.0),
          child: ElevatedButton(onPressed: (){
            showDialog(context: context, builder:(context)=> AlertDialog(
              content:VotersList()
            ) );
          }, child: Text("Voters")),
        ),
        actions:[ 
         
          
        btnw(), const SizedBox(width: 100)
         ]
      ),
        body: block? Container(
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child:
          Center(
            child: ListView(children: [
              Center(
                child: WebViewX(width: 1000, height: 1000,
                ignoreAllGestures: true,
                initialContent: initialContent,
                ),
              )
            ],),
          )
          ):Container(
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child:
          Center(
            child: ListView(children: [
              Center(
                child: WebViewX(width: 1000, height: 1000,
                ignoreAllGestures: false,
                // initialContent: " http://localhost:8000",
                initialContent: initialContent,
                // initialContent: " https://f874-2a04-241e-103-4a80-7dff-7136-fbe5-a0d6.ngrok-free.app",
                ),
              )
            ],),
          )
          )
    );
    
  }
  btnw(){
    
    return    Human().address==null?
   
   TextButton(onPressed: ()async{
    if (Human().metamask==false){
      
      showDialog(context: context, builder: (context){return 
      const AlertDialog(
        content: Text("Metamask not detected.")
      );
      });
    }
    setState((){
      widget._isConnecting=true;
    });
    var cevine=  await Human().signIn();

    setState((){
      widget._isConnecting=false;
    });
    if (Human().allowed ){
     block=false;
     Navigator.of(context).pushNamed("/");

    }
    else{
      showDialog(context: context, builder: (context)=>
      AlertDialog(content:Container(
        height: 150,width: 700,padding: EdgeInsets.all(30),
        child: Center(child: Text(
          Human().voted?
          "Address "+Human().address!+" already voted. ":
          "Address "+Human().address!+" is not allowed to vote in this poll. "
          ))))
      );
    }

   }, child: 
   Text(
    Human().address==null?
    "Connect Wallet":Human().address!))
    :
   SizedBox(
      width: 150,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          isExpanded: true,
          value: getShortAddress(Human().address!.toString()),
          icon: const Icon(Icons.arrow_drop_down),
          hint: Row(
            children: [
             
              Text(shortenString(Human().address!.toString())),
            ],
          ),
          onChanged: (value) {
            // Implement actions based on dropdown selection
          },
          items: [
            DropdownMenuItem(
              value: getShortAddress(Human().address!.toString()),
              child: Text(shortenString(Human().address!.toString())),
            ),
            const DropdownMenuItem(
              value: 'Profile',
              child: Text('Profile'),
            ),
            const DropdownMenuItem(
              value: 'Switch Address',
              child: Text('Switch Address'),
            ),
            const DropdownMenuItem(
              value: 'Disconnect',
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
  
}

class VotersList extends StatelessWidget {
 
   VotersList({super.key, });
  List<Widget> rows = [];
  @override
  Widget build(BuildContext context) {
    for (Voter voter in voters) {
  rows.add(
    Container(
      padding:const EdgeInsets.all(5),
      margin: const EdgeInsets.all(2),
      color:Theme.of(context).canvasColor,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
             
               SizedBox(
                width: 160,
                child: Center(child: Text( voter.name))),
              SizedBox(
                width: 160,
                child: Center(child: Text( getShortAddress( voter.address)))),
              TextButton(onPressed: (){
               copied(context,voter.address);
              }, child: Icon(Icons.copy))
            ],
          ),
          SizedBox(width: 70), // Adjust as needed
          Text("${voter.voted}"),
        ],
      ),
    ),
  );
};

    return Container(
      height:600,
      width: 700,
      child: Center(
        child: ListView(
          children:[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 10),
            Text("   "), SizedBox(width: 110,),  Text("Address"), SizedBox(width: 240,), Text("Voted"),SizedBox(width: 40,) 
            ],),
            SizedBox(height: 10),
            ...rows,
          
            
            ]
        ),
      ),
    );
  }
}

  copied(context, text) async{
    
    await Clipboard.setData(
          ClipboardData(text:text)
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        // The content of the SnackBar.
        content: Center(
            child: Text(
          'Item copied to clipboard',
          style: TextStyle(fontSize: 15),
        )),
        // The duration of the SnackBar.
        duration: Duration(seconds: 2),
      ),
    );
  }