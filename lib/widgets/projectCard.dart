import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/utils/reusable.dart';
import '../entities/project.dart';
import 'package:intl/intl.dart';

class PCard extends StatelessWidget {

   PCard({super.key, this.project});
  Project? project;
  @override
  Widget build(BuildContext context) {
    
    return  Card(
      elevation: 4,
      child: TextButton(
        onPressed: () {
   Navigator.pushNamed(context, '/projects/${project!.contractAddress}');
        },
        child: SizedBox(
          width: 490,
          height: 260,
           child: Column(
            children: [
             const SizedBox(height: 8),
           Container(
            padding: EdgeInsets.only(top:4,bottom: 4,left:14,right: 14),
           decoration: BoxDecoration(
           color: Colors.grey.withOpacity(0.2),
          border: Border.all(width: 0.6,color: Colors.black12)
           ),
           child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Created: ${DateFormat.yMMMd().format(project!.creationDate!)}",style: const TextStyle(fontSize: 13),),
                    Text(project!.status=="Dispute"?"Expires: ${DateFormat.yMMMd().format(project!.expiresAt!)}":"",style: TextStyle(fontSize: 13)),
                ],
              ),
              ),
              SizedBox(height: 23),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                   
                    children: [
                      FutureBuilder<Uint8List>(
                                future: generateAvatarAsync(hashString(project!.contractAddress!)),  // Make your generateAvatar function return Future<Uint8List>
                                builder: (context, snapshot) {
                                  // Future.delayed(Duration(milliseconds: 500));
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    
                                    
                                    return Container(
                                     
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                      width: 50.0,
                                      height:50.0,
                                      color: Theme.of(context).canvasColor,
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
                              const SizedBox(height: 10),
                               Padding(
                    padding: const EdgeInsets.only(left:8.0, top:10),
                    child: Column(
                        children: [
                         
                         
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color:Theme.of(context).canvasColor,
                                  border: Border.all(width: 0.5, color: Colors.white24)                      
                                ),
                            child: Column(
                              children: [
                                // Text("Holding" , textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.w100, fontSize: 14 ) ,),
                                Text(project!.holding!.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                                Text(
                                  project!.isUSDT?
                                  "USDT":"XTZ" , textAlign: TextAlign.center, 
                                  style: TextStyle( 
                                    color: project!.isUSDT?Colors.green:Colors.blue,
                                    fontWeight:  project!.isUSDT?FontWeight.w100:FontWeight.w400, fontSize: 16 ) ,),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                    ],
                  ),
                  // SizedBox(width: 14),
                   Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                            Text(
                      project!.name!.length<29?project!.name!:
                      project!.name!.substring(0,25)+".."
                            , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                       Padding(
                        padding: const EdgeInsets.only(top:18.0, left: 12),
                        child: SizedBox(
                          width: 290,
                          child: Text(project!.description!)),
                           ),
                    ],
                  ),
                
                
                ],
              )
          ])
          )
          )
          );
  }
}




class ProjectCard extends StatelessWidget {
  ProjectCard({super.key, this.project});
  Project? project;
  @override
  Widget build(BuildContext context) {
    // project!.holding= project!.contributions.values.fold(0, (a, b) => a! + b);
    return Card(
      elevation: 4,
      child: TextButton(
        onPressed: () {
   Navigator.pushNamed(context, '/projects/${project!.contractAddress}');
        },
        child: SizedBox(
          width: 490,
          height: 260,
          child: Column(
            children: [
             const SizedBox(height: 8),
           Container(
            padding: EdgeInsets.only(top:4,bottom: 4,left:14,right: 14),
          //  decoration: BoxDecoration(
          //  color: Colors.grey.withOpacity(0.2),
          // border: Border.all(width: 0.6,color: Colors.black12)
          //  ),
           child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Text(project!.holding!.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                                SizedBox(width: 9),
                                Text(
                                  project!.isUSDT?
                                  "USDT":Human().chain.nativeSymbol , textAlign: TextAlign.center, 
                                  style: TextStyle( 
                                    color: project!.isUSDT?Colors.green:Colors.blue,
                                    fontWeight:  project!.isUSDT?FontWeight.w100:FontWeight.w400, fontSize: 16 ) ,),
              Spacer(),StatusBox(project: project!)
              
                ],
              ),
              ),
              SizedBox(height: 23),
             SizedBox(height: 55,width: 490,

              child: Row(
                  children: [
                       Padding(
                         padding: const EdgeInsets.only(left:28.0),
                         child: FutureBuilder<Uint8List>(
                                  future: generateAvatarAsync(hashString(project!.contractAddress!)),  // Make your generateAvatar function return Future<Uint8List>
                                  builder: (context, snapshot) {
                                    // Future.delayed(Duration(milliseconds: 500));
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      
                                      
                                      return Container(
                                       
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0)
                                        ),
                                        width: 50.0,
                                        height:50.0,
                                        color: Theme.of(context).canvasColor,
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
                       ),
                      const SizedBox(width: 10),
                             Text(
                      project!.name!.length<29?project!.name!:
                      project!.name!.substring(0,25)+"..",

                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),    
                  ],
              ),
             ) ,
              Padding(
                  padding: const EdgeInsets.only(top:18.0, left: 26),
                  child: SizedBox(
                    width: 390,
                    child: Text(project!.description!)),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(bottom:9),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text("Created: ${DateFormat.yMMMd().format(project!.creationDate!)}",style: const TextStyle(fontSize: 13),),
                    Text(project!.status=="Dispute"?"Expires: ${DateFormat.yMMMd().format(project!.expiresAt!)}":"",style: TextStyle(fontSize: 13)),
                          ]
                         
                      ))
            ],
          ),

        ),
      ),
    );
  }

}


class StatusBox extends StatelessWidget {
   StatusBox({required this.project, super.key});
  Project project;
  @override
  Widget build(BuildContext context) {
    return
    project.status =="ongoing"?
                Container(
                        width: 90,
                    height: 19,
                      decoration: BoxDecoration(
                        color:Color.fromARGB(255, 80, 109, 96),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(project.status! , 
                      style: 
                     
                      TextStyle(color: Color.fromARGB(255, 185, 253, 206), fontWeight: FontWeight.bold, fontSize: 12)
                      ))) 
              :
    project.status =="dispute"?

              Container(
                        width: 90,
                    height: 19,
                      decoration: BoxDecoration(
                        color:Color.fromARGB(255, 109, 80, 80),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(project!.status! , 
                      style:
                  
                      TextStyle(color: Color.fromARGB(255, 253, 185, 185), fontWeight: FontWeight.bold, fontSize: 12))))
                :
                project.status =="open"?
                    Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38,width: 0.01),
                      borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color:Colors.white70,
                        blurRadius: 1.0,
                        spreadRadius: 0.12,
                        offset: Offset(0.1, 0.3),
                      ),
                    ],
                    ),
                    width: 90,
                    height: 19,
                    child:Center(child: Text(
                      project.status.toString(),style: TextStyle(color: Color.fromARGB(255, 8, 29, 9)),
                    ),)
                  ):
                   project.status =="pending"?
                    Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(96, 202, 202, 202),width: 0.01),
                      borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color:Colors.white70,
                        blurRadius: 1.0,
                        spreadRadius: 0.12,
                        offset: Offset(0.1, 0.3),
                      ),
                    ],
                    ),
                    width: 90,
                    height: 19,
                    child:Center(child: Text(
                      project.status.toString(),style: TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                    ),)
                  ):
                      Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38,width: 0.01),
                      borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color:Color.fromARGB(179, 160, 160, 160),
                        blurRadius: 1.0,
                        spreadRadius: 0.12,
                        offset: Offset(0.1, 0.3),
                      ),
                    ],
                    ),
                    width: 90,
                    height: 19,
                    child:Center(child: Text(
                      project.status.toString(),style: TextStyle(color: Color.fromARGB(255, 8, 29, 9)),
                    ),)
                  );                  
       }
}




