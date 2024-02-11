import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trustless/screens/prelaunch.dart';
import 'package:trustless/widgets/projectDetails.dart';
import 'package:trustless/widgets/usercard.dart';
import '../entities/project.dart';
import '../entities/user.dart';
import '../main.dart';
import '../utils/reusable.dart';
Map<String, TextStyle> actionStyles = {
  "createProject": GoogleFonts.spaceMono(fontSize: 14, ),
  "setParties": GoogleFonts.spaceMono(fontSize: 14,fontWeight:FontWeight.w500),
  "fundProject": GoogleFonts.robotoMono(fontWeight: FontWeight.w500),
  "withdraw": GoogleFonts.ubuntuMono(fontWeight: FontWeight.w200),
  "voteToRelease": GoogleFonts.b612Mono(fontWeight: FontWeight.w600),
  "voteToDispute": GoogleFonts.b612Mono(fontWeight: FontWeight.w700),
  "arbitrate": GoogleFonts.b612Mono(fontWeight: FontWeight.w400),
  "reimburse": GoogleFonts.b612Mono(fontWeight: FontWeight.w400),
};
Map<String, Icon> actionIcons = {
  "createProject": Icon(Icons.create_new_folder,size: 13,),
  "setParties": Icon(Icons.group_add,size: 13),
  "fundProject": Icon(Icons.account_balance_wallet,size: 13),
  "withdraw": Icon(Icons.money_off,size: 13),
  "voteToRelease": Icon(Icons.how_to_vote,size: 13),
  "voteToDispute": Icon(Icons.gavel,size: 13),
  "arbitrate": Icon(Icons.balance,size: 13),
  "reimburse": Icon(Icons.refresh,size: 13),
};


Map<String, Color> actionColors = {
  "createProject": Colors.blue,
  "setParties": Colors.green,
  "fundProject": Colors.orange,
  "withdraw": Colors.red,
  "voteToRelease": Color.fromARGB(255, 167, 176, 39),
  "voteToDispute": Colors.amber,
  "arbitrate": Colors.teal,
  "reimburse": Color.fromARGB(255, 161, 63, 181),
};
class ActionItem extends StatefulWidget {
  TTransaction action;
  var opa=1.0;
  bool shown=false;
  ActionItem({required this.action});

  @override
  State<ActionItem> createState() => _ActionItemState();
}


class _ActionItemState extends State<ActionItem> {
  @override
  void initState() {
  
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     if (widget.opa==0.0){
    //   Future.delayed(Duration(milliseconds: 0)).then((value) {
    //   setState(() {
    //     widget.opa=1;
    //   });
    // });
    }
     Project p= projects.firstWhere(
                              (element) => element.contractAddress==widget.action.contract,
                              orElse: () => projects[0]);
     // Retrieve the action's base color from the mapping
    Color baseColor = actionColors[widget.action.name] ?? Colors.grey; // Default color if action not found
    // Blend the base color with the theme's canvasColor
    Color blendedColor = Color.alphaBlend(baseColor.withOpacity(0.2), Theme.of(context).textTheme.bodySmall!.color!);
    Color blendedColor1 = Color.alphaBlend(baseColor.withOpacity(0.08), Theme.of(context).textTheme.bodySmall!.color!);
    // return Text(action.name);
      List<Color> containerColors = [
      Theme.of(context).indicatorColor.withOpacity(1),
      Theme.of(context).indicatorColor.withOpacity(0.5),
    ];
    List<double> stops = [0.01, 0.59]; 
    return  Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Color.fromARGB(12, 0, 0, 0),
        // decoration: BoxDecoration(),
        padding: EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             Container(
                  width: 160,height: 40,
                  color: Color.fromARGB(0, 76, 175, 79),
                  child:  Padding(
                    padding: const EdgeInsets.only(top:8.0,left:0,bottom:8),
                    child: Row(
                      children: [
                        FutureBuilder<Uint8List>(
                                future: generateAvatarAsync(hashString(widget.action.user.address!)),  // Make your generateAvatar function return Future<Uint8List>
                                builder: (context, snapshot) {
                                  // Future.delayed(Duration(milliseconds: 500));
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    
                                    
                                    return Container(
                                      width: 20.0,
                                      height:20.0,
                                      color: Theme.of(context).canvasColor,
                                    );
                                  } else if (snapshot.hasData) {
                                    
                                    return SizedBox(width: 20,height: 20,  child: Image.memory(snapshot.data!));
                                    
                                  } else {
                                    return Container(
                                      width: 20.0,
                                      height: 20.0,
                                      color: Theme.of(context).canvasColor,  // Error color
                                    );
                                  }
                                },
                              ),
                        const SizedBox(width: 5),
                        Text(
                          shortenString(widget.action.user.address!),
                          style:const TextStyle(fontSize: 12)),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 25,
                          child: TextButton(onPressed: (){
                            copied(context, widget.action.user.address);
                          }, child: Icon(Icons.copy, size: 17)),
                        )
                      ],
                    ),
                  ),

                ),
      Spacer(),
                     
    Container(
                width: 160,
                padding: EdgeInsets.all(8.0),
                color: Colors.transparent, // Use the blended color as the background
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(actionIcons[widget.action.name]?.icon, color: blendedColor), // Use the base color for the icon
                    SizedBox(width: 12),
                    Text(
                      widget.action.name,
                      style: TextStyle(color: blendedColor1), // Use the base color for text as well
                    ),
                    // Add more widgets as needed
                  ],
        ),
      ), 
      Spacer(),
    ["setParties","createProject"].contains(widget.action.name)?
    Container(
      width: 120,
      height: 40,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.7,
            child: Container(
              height: 20,
              width: 20,
              child:Icon(Icons.circle, size: 12,),
              decoration:  BoxDecoration(
                  
                borderRadius:  BorderRadius.all(Radius.circular(12)),
                color:Theme.of(context).indicatorColor.withOpacity(0.7),
                
               ),
            ),
          ),
          const SizedBox(width: 10),
          Text("Economy", style: GoogleFonts.changa(
            color:Theme.of(context).indicatorColor.withOpacity(0.85),
            fontWeight: FontWeight.bold),),
        ],
      ),
    ):
   
     Container(
                 height: 40,
                  color: Color.fromARGB(0, 76, 119, 175),
                  child:  Padding(
                    padding: const EdgeInsets.only(top:8.0,left:0,bottom:8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                  
                        FutureBuilder<Uint8List>(
                                future: generateAvatarAsync(hashString(p.contractAddress!)),  // Make your generateAvatar function return Future<Uint8List>
                                builder: (context, snapshot) {
                                  // Future.delayed(Duration(milliseconds: 500));
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container(
                                      width: 20.0,
                                      height:20.0,
                                      color: Theme.of(context).canvasColor,
                                     
                                    );
                                  } else if (snapshot.hasData) {
                                    
                                    return SizedBox(width: 20,height: 20,  child: Image.memory(snapshot.data!));
                                    
                                  } else {
                                    return Container(
                                      width: 20.0,
                                      height: 20.0,
                                      color: Theme.of(context).canvasColor, 
                                       // Error color
                                    );
                                  }
                                },
                              ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // Minimize padding
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize the hit test area
                            ),
                          onPressed: (){
                            Navigator.of(context).pushNamed("/projects/${p.contractAddress}");
                          },
                          
                          child: Text(
                              p.name!,
                            style: GoogleFonts.dmMono(fontSize: 14,)),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                ),
                 Spacer(),
         
              SizedBox(
                
                child: Text(
                  getTimeAgo( widget.action.time)+"    ",
                  style: GoogleFonts.dmMono(fontSize: 13),
                  )

              ),
             
            
            ],
          ),
        ),
     
    );
  }


}



class ActivityFeed extends StatefulWidget {
  final List<User> users;

  ActivityFeed({required this.users});

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  List<User> displayedUsers = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((value) => {
      timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (displayedUsers.length < 15) {
        setState(() {
          displayedUsers.add(widget.users[displayedUsers.length]);
        });
      } else {
         setState(() {
        displayedUsers.addAll(widget.users.sublist(15));
          });
        timer.cancel();
      }
    })
    });
   
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left:30, top:15),
        child: 
      Column(
        children: [
            // ________________________________________BEGIN_HEADER_________________________________
         Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Color.fromARGB(12, 0, 0, 0),
        // decoration: BoxDecoration(),
        padding: EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:45.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Container(
                  width: 160,height: 40,
                  color: Color.fromARGB(0, 76, 175, 79),
                  child:  Padding(
                    padding: const EdgeInsets.only(top:8.0,left:0,bottom:8),
                    child: Text(
                            "User or Org",
                            style: GoogleFonts.dmMono(fontSize: 14,))
                  ),

                ),
      Spacer(),
                     
    Container(
                width: 190,
                padding: EdgeInsets.all(8.0),
                color: Colors.transparent, // Use the blended color as the background
                child: Text(
                            "Executed",
                            style: GoogleFonts.dmMono(fontSize: 14,))
      ), 
      Spacer(),

   
     Container(
                 height: 40,
                  color: Color.fromARGB(0, 76, 119, 175),
                  child:  Padding(
                    padding: const EdgeInsets.only(top:8.0,left:0,bottom:8),
                    child: Text(
                            "on Contract",
                            style: GoogleFonts.dmMono(fontSize: 14,))
                  ),
                ),
                 Spacer(),
         Spacer(),
            SizedBox(width: 100,child: Text("  "),),
            
            ],
          ),
        ),
     
    ),



            // ________________________________________END_HEADER_________________________________
            
          
          Expanded(
            child: ListView.builder(
              itemCount: displayedUsers.length,
              itemBuilder: (context, index) {
                return Opacity(opacity: 0.85, child: ActionItem(action: displayedUsers[index].actions.first)); // Your list item
              },
            ),
          ),
        ],
      ),

    
        // ListView.builder(
        //   itemCount: displayedUsers.length,
        //   itemBuilder: (context, index) {
        //     return ActionItem(action: displayedUsers[index].actions.first); 
          // },
        // ),
      ),
    );
  }
}

class FixedHeaderWithScrollableList extends StatelessWidget {
  final List<User> displayedUsers; // Assuming you have a User class

  FixedHeaderWithScrollableList({Key? key, required this.displayedUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200, // Height of your header
            color: Colors.transparent, // Your transparent header
            child: Center(child: Text('Sticky Header')),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedUsers.length,
              itemBuilder: (context, index) {
                return ActionItem(action: displayedUsers[index].actions.first); // Your list item
              },
            ),
          ),
        ],
      ),
    );
  }
}