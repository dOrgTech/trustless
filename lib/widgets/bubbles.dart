import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';

class Bubbles extends StatefulWidget {
  const Bubbles({super.key});

  @override
  State<Bubbles> createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> {
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
                
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  suffix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: (){},
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