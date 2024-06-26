import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trustless/entities/project.dart';
import 'package:trustless/main.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/usercard.dart';
import '../widgets/action.dart';
import '../widgets/projectDetails.dart';
import 'human.dart';

String workingHash ="0x71436760615bde646197979c0be8a86c1c6179cd17ae7492355e76ff79949bbc";

class User{
  User({this.about,this.link, this.name, required this.lastActive,  required this.address,required this.nativeEarned,
  required this.usdtEarned,required this.usdtSpent,required this.nativeSpent,required this.projectsContracted,
  required this.projectsArbitrated,required this.projectsBacked,
  required this.projectsAuthored});
  List<TTransaction>actions=[];
  String address;
  String nativeEarned;
  String usdtEarned;
  String nativeSpent;
  String usdtSpent;
  String? name;
  String? link;
  String? about;
  List<String>projectsContracted;
  List<String>projectsArbitrated;
  List<String>projectsAuthored;
  List<String>projectsBacked;
  DateTime lastActive;
  UserCard getCard() {
    return UserCard(user: this);
  } 
  Map<String, dynamic> toJson() => {
        'nativeEarned': nativeEarned,
        'link':link,
        'usdtEarned': usdtEarned,
        'nativeSpent': nativeSpent,
        'usdtSpent': usdtSpent,
        'name': name,
        'about':about,
        'projectsContracted': projectsContracted,
        'projectsArbitrated': projectsArbitrated,
        'projectsAuthored': projectsAuthored,
        'projectsBacked': projectsBacked,
        'lastActive': lastActive,
      };
  factory User.fromNew(String address){

    User u= User(lastActive: DateTime.now(), address: address, 
    nativeEarned: "0", 
    usdtEarned: "0",
    usdtSpent: "0",
    link:"",
    name:"(no alies set)",
    about:null,
    nativeSpent: "0",
    projectsContracted: [],
    projectsArbitrated: [], 
    projectsBacked: [],
    projectsAuthored: [],);
    
    return u;
  }
  }


List<String>possibleActions=["updateRep", "reclaimFee","createProject", "setParties","sendFunds","sign","withdraw","voteToRelease","voteToDispute","arbitrate","reimburse"];

class TTransaction{
  TTransaction({
    required this.time,
    required this.sender,
    required this.functionName,
    required this.contractAddress,
    required this.params,
    required this.hash
  })
  {
    blockExplorerUrl= "${Human().chain.blockExplorer}/tx/${hash}";
  }
  String sender;
  String functionName;
  String contractAddress;
  String params;
  String hash;
  late String blockExplorerUrl;
  DateTime time;

  // Convert a TTransaction instance into a Map.
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'functionName': functionName,
      'contractAddress': contractAddress,
      'params': params,
      'time': time,
    };
  }

  @override
  String toString() {
    return '''
      TTransaction:
        Time: $time
        Sender: $sender
        Function Name: $functionName
        Contract Address: $contractAddress
        Parameters: $params
        Hash: $hash
    ''';
  }

  // Create a TTransaction instance from a map (JSON).
  factory TTransaction.fromJson(Map<String, dynamic> json) {
    TTransaction transaction = TTransaction(
      time: DateTime.parse(json['time']),
      sender: json['sender'],
      functionName: json['functionName'],
      contractAddress: json['contractAddress'],
      params: json['params'],
      hash: json['hash'],
    );
    return transaction;
  }

}

class UserDetails extends StatefulWidget {
  User human;
  UserDetails({required this.human,super.key, });

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
   Widget involvement(String address, String type){
    Project p= projects.firstWhere(
                                (element) => element.contractAddress==address,
                                orElse: () => projects[0]);
  return Padding(padding: const EdgeInsets.all(5),
    child: Row(

      children: [

      SizedBox(width:  MediaQuery.of(context).size.aspectRatio>1? 60 : 3),
          SizedBox(
                 height: 40,
                  child:  Padding
                  (
                    padding: const EdgeInsets.only(top:0,left:0,bottom:0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         MediaQuery.of(context).size.aspectRatio>1?
                       FutureBuilder<Uint8List>(
                                future: generateAvatarAsync(hashString(p.contractAddress!)),  // Make your generateAvatar function return Future<Uint8List>
                                builder: (context, snapshot) {
                                  // Future.delayed(Duration(milliseconds: 500));
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                          color: Theme.of(context).canvasColor,
                                      ),
                                      width: 50.0,
                                      height:50.0,
                                    
                                    );
                                  } else if (snapshot.hasData) {
                                    
                                    return Container(width: 50,height: 50,  
                                     decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                    child: Image.memory(snapshot.data!));
                                    
                                  } else {
                                    return Container(
                                      width: 50.0,
                                      height: 50.0,
                                      color: Theme.of(context).canvasColor,  // Error color
                                    );
                                  }
                                },
                              ):const Text(""),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // Minimize padding
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize the hit test area
                            ),
                          onPressed: (){
                            Navigator.of(context).pushNamed("/projects/${p.contractAddress}");
                          },
                          
                          child: SizedBox(
                            
                            child: Text(
                             p.name!.length<17?
                                              p.name!:
                                              p.name!.substring(0,16)+".."
                                ,
                              style: GoogleFonts.dmMono(fontSize: 14,)),
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                ),
        const Spacer(),
        Text(type),
        const SizedBox(width: 60),
    ],),
    );
  }

  @override
  Widget build(BuildContext context) {
        List<ActionItem> activity=[];
    for (TTransaction t in actions){
      if (t.sender==widget.human.address){
      activity.add(ActionItem(action: t, landingPage: false));
      }
    }
    List<Widget> involvements = [];
    for (String address in widget.human.projectsArbitrated){involvements.add(involvement( address, "Arbiter"));}
    for (String address in widget.human.projectsAuthored){involvements.add(involvement( address, "Author"));}
    for (String address in widget.human.projectsBacked){involvements.add(involvement( address, "Backer"));}
    for (String address in widget.human.projectsContracted){involvements.add(involvement( address, "Contractor"));}
    involvements.shuffle(Random());
    return  MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor:
             MediaQuery.of(context).size.aspectRatio>1?1: 0.80),
      child: Padding(
        padding: const EdgeInsets.only(left:18,top:10),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.only(top:8.0,left:15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Uint8List>(
                        future: generateAvatarAsync(hashString(widget.human.address)),  // Make your generateAvatar function return Future<Uint8List>
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: 40.0,
                              height: 40.0,
                              color: Colors.grey,
                            );
                          } else if (snapshot.hasData) {
                            return Image.memory(snapshot.data!);
                          } else {
                            return Container(
                              width: 40.0,
                              height: 40.0,
                              color: Colors.red,  // Error color
                            );
                          }
                        },
                      ),
                    const SizedBox(width: 10),
                    Text(
                      MediaQuery.of(context).size.aspectRatio<1?
                      getShortAddress(widget.human.address):widget.human.address, style: const TextStyle(fontSize: 13),),
                    const SizedBox(width: 10),
                    TextButton(onPressed: (){
                      copied(context, widget.human.address);
                    }, child: const Icon(Icons.copy))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(width: 0.3 , color: Theme.of(context).colorScheme.onError)
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                       Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text( Human().chain.nativeSymbol.toString() +" spent: "+ cf.weiToEth( widget.human.nativeSpent)),
                             Text( "USDT spent: "+widget.human.usdtSpent.toString())
                          ],),
                      ),
                        Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text( Human().chain.nativeSymbol.toString() +" earned: "+cf.weiToEth( widget.human.nativeEarned)),
                            Text( "USDT earned: "+widget.human.usdtEarned.toString())
                          ],),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 39),
            SizedBox(
              // height: MediaQuery.of(context).size.height-400,
              width: 450,
            child: DefaultTabController(
              length: 3, 
              initialIndex: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height-400,
                width: 450,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 400,
                      alignment: Alignment.center,
                      child:  TabBar(
                        labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                        tabs: [Tab(text:"ABOUT"),Tab(text:"INVOLVEMENTS"),Tab(text:"ACTIVITY")]),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height-450,
                      child: TabBarView(children: [
                        Column(children: [
                          const SizedBox(height: 40),
                          Text(widget.human.name??"(no alias set)", style:GoogleFonts.lato(
                            color: Theme.of(context).indicatorColor,
                            fontSize: 20)),
                          const SizedBox(height: 10),
                          OldSchoolLink(
                              text: widget.human.link ?? "no link",
                              url: widget.human.link ?? "no link",
                            ),
                          const SizedBox(height: 15),
                          Text("Last seen: ${widget.human.lastActive}", style: const TextStyle(fontSize: 13),),
                          const SizedBox(height: 40),
                          !(widget.human.about==null)?
                           SizedBox(
                            width: 390,
                            child:Text(widget.human.about!),
                          ):SizedBox(
                            width: 390,
                            height: MediaQuery.of(context).size.height/2 - 300,
                            child: const Center(child: 
                            Opacity(
                              opacity: 0.3,
                              child: Text("No description provided",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize:24),
                              ),
                            )),
                          ),
                        ],),  
                        SizedBox(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                                    Padding(
                                      padding:  const EdgeInsets.only(left:38.0),
                                      child: Row(
                                        children:  [
                                         SizedBox(width:  MediaQuery.of(context).size.aspectRatio>1? 50 : 3),
                                          Text("Project"),
                                          Spacer(),
                                          Text("Stakeholder Type"),
                                          SizedBox(width: 50)
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    ...involvements
                            ],
                          ),
                        ),
                       ListView(children: activity),
                      
                      ]),
                    )
                  ],
                ),
              )
            ),
           ),
         
            // Text("orice frate, orice")
                ],)
             
      ),
    );
  }
}

