import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Bubbles extends StatefulWidget {
  const Bubbles({super.key});

  @override
  State<Bubbles> createState() => _BubblesState();
}

  final String apiUrl = 'http://127.0.0.1:5001/trustless-fbc30/us-central1/on_request_example';
class _BubblesState extends State<Bubbles> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  String result = ''; // To store the result from the API call

  Future<void> makeRequest() async {
  final url = apiUrl;
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
       'session_id': "oer3raatever",
      'message': messageController.text, 
    }),
  );

  if (response.statusCode == 200) {
    print('Success: ${response.body}');
  } else {
    print('Error: ${response.statusCode}');
  }
}

  Future<void> _postData() async {
    print("method starts");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': "something name",
          'message': messageController.text,
        }),
      );
      
      print(response.toString());
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          result = 'Success! Response: $responseData';
        });
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      print( "ocatching chasdoiajsd");
      print(e);
      setState(() {
        result = 'Error: $e';
      });
    }
    print("method ends");
  }
Duration duration = new Duration();
Duration position = new Duration();
DateTime now=DateTime.now();
bool isPlaying = false;
bool isLoading = false;
bool isPause = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height-100,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0),
                  child: BubbleNormal(
                    text: "Welcome to Trustless Business! If you have questions about the platform, ask them here.",
                    isSender: false,
                    color: Theme.of(context).colorScheme.surface,
                    
                    tail: true,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white  
                    ),
                  ),
                ),
                BubbleNormal(
                  text: 'bubble normal with tail bubble normal with tailbubble normal with tail',
                  isSender: true,
                  color: Theme.of(context).colorScheme.onSurface,
                  tail: true,
                  sent: true,
                ),
          
              ],
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
                      onPressed: (){
                        print("posting "+messageController.text);
                         makeRequest();
                      },
                      child: Icon(Icons.send, size: 24)),
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