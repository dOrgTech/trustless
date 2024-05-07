import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphite/graphite.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import 'package:trustless/screens/prelaunch.dart';

class Bubbles extends StatefulWidget {
  Bubbles({super.key});
  List<Widget>allMessages=[];
  @override
  State<Bubbles> createState() => _BubblesState();
}

  final String apiUrl = 'http://127.0.0.1:5001/trustless-fbc30/us-central1/on_request_example'; 
  


class _BubblesState extends State<Bubbles> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
   // To store the result from the API call

  final scrollController = ScrollController();
  Future<void> makeRequest(query) async {
    if (query.length<2){
       bool ready=true;
       isLoading=false;
      return null;}
          setState(() {
        bool ready=false;
      });
    print("started make request");
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 20),
        curve: Curves.easeOut);

        final url = api!;
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'Papplication/json',
          },
          body: jsonEncode({
            'session_id': Human().address??Human().session_id,
            'message': query, 
          }),
        );
        if (response.statusCode == 200) {
          print('Success: ${response.body}');
          Human().chatHistory.add(
            ChatItem(isSender: false, 
            message: response.body.toString(),
            )
          );
        } else {
          print('Error: ${response.statusCode}');
        }

  // await Future.delayed(Duration(seconds: 3));
  
  // String response="somehgoisjoasidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid asidnoas oaisndoiandasoi doasi doasid ";
   bool ready=true;
    setState(() {
        isLoading=false;
        // Human().chatHistory.add(ChatItem(isSender: false, message: response.body.toString()));
        scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 20),
        curve: Curves.easeOut,
      );
      
    });
  
  }


 


Duration duration = new Duration();
Duration position = new Duration();
DateTime now=DateTime.now();
bool isPlaying = false;
bool isLoading = false;
bool isPause = false;

  @override
  Widget build(BuildContext context) {
    widget.allMessages=[];
    for (ChatItem chatItem in Human().chatHistory){
     widget.allMessages.add(
       Container(
         padding: const EdgeInsets.symmetric(vertical:9.0),
         child: BubbleNormal(
          constraints: BoxConstraints(maxWidth: 460),
              text: chatItem.message,
              isSender: chatItem.isSender,
              color: chatItem.isSender?Theme.of(context).colorScheme.onSurface
              :Theme.of(context).canvasColor
              ,
              textStyle: TextStyle(
                color:  chatItem.isSender?Theme.of(context).canvasColor
              :Theme.of(context).colorScheme.onSurface
              ),
              tail: true,
              sent: true,
            ),
       ),
     );
    }
     

    if (isLoading){
      widget.allMessages.add(
        Container(
             padding: EdgeInsets.all(30),
             child:  Center(child: SizedBox(
                  height:30,
                  width: 250,
                  
                  child: Opacity(
                    opacity: 0.5,
                    child: ColorFiltered(
          colorFilter: ColorFilter.mode(Theme.of(context).indicatorColor, BlendMode.srcIn),
          child:  Lottie.asset(
                        
                        "assets/typing.json",fit: BoxFit.fitHeight),
                    )),
                  )))
      );
               
                  setState(() {
                scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 40),
                      curve: Curves.easeOut,
                    );
            });
      }

    return SizedBox(
     
      height: MediaQuery.of(context).size.height-100,
      // height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
           Container(
              height: MediaQuery.of(context).size.height-170,
              child:
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            child: SizedBox(
              width: 594,
              child: Column(
                  children: widget.allMessages,
                ),
            ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: 580,
              // height: 100,
              // height: MediaQuery.of(),
              child: 
              SizedBox(
                child: TextField(
                  
                  controller: messageController,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17.0),

                    ),
                   border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: 

                        () async{
                          setState(() {
                            Human().chatHistory.add(
                              ChatItem(isSender: true, message: messageController.text)
                            );
                           isLoading=true;
                           
                          });
                          String query=messageController.text;
                          messageController.clear();
                          await makeRequest(query);
                          setState(() {
                          scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeOut,
                              );
                          });
              
                        },
                        child: const Icon(Icons.send, size: 24)),
                    ),
                    filled: true,
                    hintText: "Type your message here",
                    fillColor: Theme.of(context).dividerColor,
                  ),
                ),
              )
            ),
          ),
        ],
      // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}