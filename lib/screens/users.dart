
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
import '../widgets/usercard.dart';


class Users extends StatefulWidget {
    List<UserCard> userCards=[];
   Users({super.key});
   String? _selectedOption= "Top Arbiters";
   String query="";
  @override
  State<Users> createState() => _UsersState();
}
 
class _UsersState extends State<Users> {
    @override
  void initState() {
  
 
 
  }
  int _selectedCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    widget.userCards=[];
  for (int i = 0; i < 12 && i < users.length; i++) {
    if (
        users[i].address.toLowerCase().contains(widget.query)
          ||
        users[i].name.toString().toLowerCase().contains(widget.query)
        )
        {
      widget.userCards.add(users[i].getCard());
    }
  }
  if (widget._selectedOption=="Top Arbiters"){
  widget.userCards.sort((a, b) => b.user.projectsArbitrated.length.compareTo(a.user.projectsArbitrated.length));
  }else if(widget._selectedOption=="Top Contractors"){
  widget.userCards.sort((a, b) => b.user.projectsContracted.length.compareTo(a.user. projectsContracted.length));
  }else{
  widget.userCards.sort((a, b) => b.user.projectsBacked.length.compareTo(a.user.projectsBacked.length));
  }
    return 
      MediaQuery.of(context).size.aspectRatio>1?wide():tall();
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

  wide(){
    return  Container(
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
                 data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                 child: Row(
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
                                  onChanged: (value){
                                    setState(() {
                                      widget.query=value;
                                    });
                                  },
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
                       Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                       height: 46, 
                       width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 1200),
                       child:  MediaQuery(
                 data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        
        Radio<String>(
          value: 'Top Contractors',
          groupValue: widget._selectedOption,
          onChanged: (String? value) {
            setState(() {
              widget._selectedOption = value;
            });
          },
        ),
        const Text('Top Contractors'),
        SizedBox(width: 50),
        Radio<String>(
          value: 'Top Arbiters',
          groupValue: widget._selectedOption,
          onChanged: (String? value) {
            print("top arbiters");
            setState(() {
             widget._selectedOption = value;
            });
          },
        ),
        const Text('Top Arbiters'),
        SizedBox(width: 50),
        Radio<String>(
          value: 'Top Backers',
          groupValue: widget._selectedOption,
          onChanged: (String? value) {
            print("top backers");
            setState(() {
            widget._selectedOption = value;
            });
          },
        ),
        const Text('Top Backers'),
      ],
    )
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
                                ...widget.userCards.asMap().entries.map((entry) {
                            var index = entry.key;
                            var userCard = entry.value;
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
                              UserDetails( human: users[_selectedCardIndex])
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
  tall(){
    return   MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.88),
      child: Container(
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
                   data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                   child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              SizedBox(
                               
                                width:MediaQuery.of(context).size.width-20,
                                height:50,
                                child: TextField(
                                  onChanged: (value){
                                    setState(() {
                                      widget.query=value;
                                    });
                                  },
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
                              ],
                             ),
                        )),
                         Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                         height: 46, 
                         width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 1200),
                         child:  MediaQuery(
                   data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio<String>(
            value: 'Top Contractors',
            groupValue: widget._selectedOption,
            onChanged: (String? value) {
              setState(() {
                widget._selectedOption = value;
              });
            },
          ),
          const Text('Top Contractors'),
          SizedBox(width: 50),
          Radio<String>(
            value: 'Top Arbiters',
            groupValue: widget._selectedOption,
            onChanged: (String? value) {
              print("top arbiters");
              setState(() {
               widget._selectedOption = value;
              });
            },
          ),
          const Text('Top Arbiters'),
          SizedBox(width: 50),
          Radio<String>(
            value: 'Top Backers',
            groupValue: widget._selectedOption,
            onChanged: (String? value) {
              print("top backers");
              setState(() {
              widget._selectedOption = value;
              });
            },
          ),
          const Text('Top Backers'),
        ],
      )
            )),
            const SizedBox(height: 23),
                    Container(
                         height: MediaQuery.of(context).size.height-210,
                      // color:Colors.yellow,
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 1200),
                      child: SizedBox(
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
                              ...widget.userCards.asMap().entries.map((entry) {
                          final index = entry.key;
                          final userCard = entry.value;
                          return InkWell(
                            onTap: () {
                          setState(() {
                            _selectedCardIndex = index;
                          });
                               showDialog(
                    barrierDismissible:  false,
                    context: context, 
                    builder: (context) => AlertDialog(
                      
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 700,
                        child: 
                        MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                          
                          child: UserDetails(human: users[0]))
                        
                      )
                    )
                  );
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
                      )
                    ],
                  ), 
                ],
              ), // End of ListView
          ),
    );

  }
}



