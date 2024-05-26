import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../entities/human.dart';
import '../entities/user.dart';
import '../utils/reusable.dart';
import 'membersList.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key, required this.user});
  User user;

  @override
  Widget build(BuildContext context) {
    return 
      Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
              SizedBox(
                height: 42,
                child:  Padding(
                  padding: const EdgeInsets.only(top:8.0,left:13,bottom:8),
                  child: Row(
                    children: [
                      FutureBuilder<Uint8List>(
                          future: generateAvatarAsync(hashString(user.address)),  // Make your generateAvatar function return Future<Uint8List>
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
                        ),
                      const SizedBox(width: 10),
                      Text(
                        shortenString(user.address!),
                        style:const TextStyle(fontSize: 13)),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right:24),
                height: 42,
                color: const Color.fromARGB(0, 76, 175, 79),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Icon(Icons.work_history, size: 15),  SizedBox(width: 1), Text(user.projectsContracted.length.toString(), style: TextStyle(fontSize: 13)),
                    SizedBox(width: 12),
                    Icon(Icons.edit,size: 15), SizedBox(width: 1),Text(user.projectsAuthored.length.toString(), style: TextStyle(fontSize: 13)),
                    SizedBox(width:12),
                    Icon(Icons.gavel,size: 15), SizedBox(width: 1),Text(user.projectsArbitrated.length.toString(), style: TextStyle(fontSize: 13)),
                    SizedBox(width: 12),
                    Icon(Icons.money,size: 15),SizedBox(width: 1), Text(user.projectsBacked.length.toString(), style: TextStyle(fontSize: 13)),
                  ],
                )
                ),
                Container(
                  padding: EdgeInsets.only(right: 13),
                height: 42,
                child: Center(child: Text(
                  DateFormat('MMM d, yyyy').format(user.lastActive),
                  style: TextStyle(fontSize: 13),
                  ))),
            
            ],
        )
      )
    
    
    ;
  }
}