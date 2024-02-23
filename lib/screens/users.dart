
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../entities/user.dart';
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Addressss"),
                                  Text("            Involvements"),
                                  Text("   Last Active"),
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

  

  Widget userDetails(User human){
    return Padding(
      padding: const EdgeInsets.only(left:28,top:30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.only(top:148.0,left:45),
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
         const SizedBox(height: 39),
         const Padding(
            padding:  EdgeInsets.only(left:38.0),
            child: Text("Involvements:",style: TextStyle(fontSize: 19)),
          ),
          const SizedBox(height: 19),
          Padding(
            padding:  const EdgeInsets.only(left:38.0),
            child: Row(
              children: const [
                Text("Project Name"),
                SizedBox(width: 170),
                Text("Stakeholder Type")
              ],
            ),
          ),
          const Divider(),
          // Text("orice frate, orice")
              ],)
           
    );
  }
}
