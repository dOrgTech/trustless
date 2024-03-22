
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/widgets/action.dart';

import '../entities/project.dart';
import '../entities/user.dart';
import '../main.dart';
import '../utils/reusable.dart';
import '../utils/scripts.dart';

List<Widget> userCards=[];
var selectedStatus="";
class Users extends StatefulWidget {
  const Users({super.key});
  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
    @override
  void initState() {
    userCards=[];
    super.initState();
  for (int i = 0; i < 12 && i < users.length; i++) {
    userCards.add(users[i].getCard());
  }
  
  }
    int _selectedCardIndex = -1;


  @override
  Widget build(BuildContext context) {
    return 
     Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height-65,
          child: ListView( // Start of ListView
            shrinkWrap: true,
            children: [
              Column( // Start of Column
                crossAxisAlignment: CrossAxisAlignment.center, // Set this property to center the items horizontally
                mainAxisSize: MainAxisSize.min, // Set this property to make the column fit its children's size vertically
                children: [
            const  SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                       height: 46, 
                       width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 1200),
                       child:  MediaQuery(
                 data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: SizedBox(
                                width: 
                                MediaQuery.of(context).size.width>1200?
                                500:
                                MediaQuery.of(context).size.width * 0.5,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                         borderSide: const BorderSide(width: 0.1),
                                      ),
                                    prefixIcon: const Icon(Icons.search),
                                    hintText: 'Search user by address or alias',
                                    // other properties
                                  ),
                                  // other properties
                                ),
                              ),
                            ),
                            ],
                           ),
                      )),
                      const SizedBox(height: 23),
                  Container(
                       height: MediaQuery.of(context).size.height-210,
                    // color:Colors.yellow,
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 1200),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height-180,
                          width: 500,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left:24.0),
                                    child: Text("Addressss"),
                                  ),
                                  Text("            Involvements"),
                                  Padding(
                                    padding: EdgeInsets.only(right:14),
                                    child: Text("   Last Active"),
                                  ),
                                ],
                              ),
                                ...userCards.asMap().entries.map((entry) {
                            final index = entry.key;
                            final userCard = entry.value;
                            return InkWell(
                              onTap: () {
                            setState(() {
                              _selectedCardIndex = index;
                            });
                              },
                              child: Container(
                            decoration: BoxDecoration(
                              border: _selectedCardIndex == index
                                  ? Border.all(color:Theme.of(context).indicatorColor)
                                  : null,
                            ),
                            child: userCard,
                              ),
                            );
                              }).toList(),
                                 ],
                               ),
                          ),
                        ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child:
                              _selectedCardIndex==-1?
                              selectAnItem():
                              userDetails(users[_selectedCardIndex])
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ), 
              ],
            ), // End of ListView
        );
      }
  Widget selectAnItem(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        // SizedBox(height: 10),
        Icon(Icons.turn_left,size: 145,color: Color.fromARGB(96, 171, 171, 171),),
        SizedBox(height: 24),
        Text("Select an item", style: TextStyle(
          color: Color.fromARGB(96, 171, 171, 171),fontSize: 41
        ),)
      ],
    );
  }

  Widget involvement(String address, String type){
    Project p= projects.firstWhere(
                                (element) => element.contractAddress==address,
                                orElse: () => projects[0]);
  return Padding(padding: const EdgeInsets.all(5),
    child: Row(

      children: [
      const  SizedBox(width: 60),
          Container(
                 height: 40,
                  color: Color.fromARGB(0, 76, 119, 175),
                  child:  Padding(
                    padding: const EdgeInsets.only(top:0,left:0,bottom:0),
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

  Widget userDetails(User human){
    List<ActionItem> activity=[];
    for (TTransaction t in actions){
      activity.add(ActionItem(action: t, landingPage: false));
    }

    List<Widget> involvements = [];
    for (String address in human.projectsArbitrated){involvements.add(involvement( address, "Arbiter"));}
    for (String address in human.projectsAuthored){involvements.add(involvement( address, "Author"));}
    for (String address in human.projectsBacked){involvements.add(involvement( address, "Backer"));}
    for (String address in human.projectsContracted){involvements.add(involvement( address, "Contractor"));}
    involvements.shuffle(Random());
    return Padding(
      padding: const EdgeInsets.only(left:28,top:30),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.only(top:8.0,left:45),
              child: Row(
                children: [
                  FutureBuilder<Uint8List>(
                      future: generateAvatarAsync(hashString(human.address)),  // Make your generateAvatar function return Future<Uint8List>
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
                  Text(human.address, style: const TextStyle(fontSize: 16),),
                  const SizedBox(width: 10),
                  TextButton(onPressed: (){}, child: const Icon(Icons.copy))
                ],
              ),
            ),
              Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text( Human().chain.nativeSymbol.toString() +" spent: "+human.nativeSpent.toString()),
                         Text( "USDT spent: "+human.usdtSpent.toString())
                      ],),
                  ),
                    Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text( Human().chain.nativeSymbol.toString() +" earned: "+human.nativeEarned.toString()),
                        Text( "USDT earned: "+human.usdtEarned.toString())
                      ],),
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
                    child: const TabBar(tabs: [Tab(text:"ABOUT"),Tab(text:"INVOLVEMENTS"),Tab(text:"ACTIVITY")]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height-450,
                    child: TabBarView(children: [
                      Container(child: Center(child: Text("ABOUT this user")),),
                      SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                                  Padding(
                                    padding:  const EdgeInsets.only(left:38.0),
                                    child: Row(
                                      children: const [
                                        SizedBox(width: 50),
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
           
    );
  }
}
