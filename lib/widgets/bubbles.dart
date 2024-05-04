import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphite/graphite.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trustless/entities/human.dart';

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

  Future<String> makeRequest() async {
  bool ready=false;
  Widget? content;
  Widget chenar=Padding(padding: EdgeInsets.all(8),
   child:  Padding(
           padding: const EdgeInsets.symmetric(vertical:9.0),
           child: SizedBox(
           width: 200,
          height: 40,
          child: !ready?LinearProgressIndicator():content!   
          ,)
       ),
  );
  
  final url = apiUrl;
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'session_id': Human().address??Human().session_id,
      'message': messageController.text, 
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
  return response.body;
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
       Padding(
         padding: const EdgeInsets.symmetric(vertical:9.0),
         child: BubbleNormal(
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
    return SizedBox(
      height: MediaQuery.of(context).size.height-100,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: widget.allMessages,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: 100,
              // height: MediaQuery.of(),
              child: 
              TextField(
                controller: messageController,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  suffix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async{
                        setState(() {
                          Human().chatHistory.add(
                            ChatItem(isSender: true, message: messageController.text)
                          );
                        });
                         messageController.clear();
                        //  makeRequest();
                      },
                      child: const Icon(Icons.send, size: 24)),
                  ),
                  filled: true,
                  hintText: "Type your message here",
                  fillColor: Theme.of(context).dividerColor,
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