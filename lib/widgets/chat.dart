import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;



class ExpandableFAB extends StatefulWidget {
  @override
  _ExpandableFABState createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animationHeight;
  late Animation<double> animationWidth;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
    animationHeight = Tween<double>(begin: 60, 
    end: 700
    ).animate(controller);
    animationWidth = Tween<double>(begin: 60, 
    end: 600
    ).animate(controller);
    
  }

void toggle() {
  print('Button clicked!');
  if (controller.isCompleted) {
    controller.reverse();
  } else {
    controller.forward();
  }
}


@override
Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height-92;

  return AnimatedBuilder(
    animation: animationHeight,
    builder: (context, child) { // add the child parameter
      return
        AnimatedContainer(
          duration: const Duration(milliseconds: 50),
           height: animationHeight.value > 699
          ? screenHeight+68 // use screenHeight if animation value is greater
          : animationHeight.value,
          
          width: animationWidth.value+13,
 
  child: 
       Stack(
          
          children: [
           Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.onError,
                onPressed: toggle,
                child: const Icon(Icons.contact_support, size: 57,),
              ),
            ),
            Positioned(
              bottom: 60,
              right:8, // position just above the FAB
              child: Container(
                child: const Center(child: Text("here we have something")),
                height: animationHeight.value > 699
          ? screenHeight // use screenHeight if animation value is greater
          : animationHeight.value, // animate the height
                width: animationWidth.value, // match the FAB width
                decoration: BoxDecoration(
                   boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).indicatorColor.withOpacity(0.1),
                      blurRadius: 7.0, // soften the shadow
                      spreadRadius: 0.3, //extend the shadow
                      offset: const Offset(
                        -0.5,
                        1.3,
                      ),
                    )
                  ],
                  border: Border.all(
                    width: 1.2,
                    color: Theme.of(context).indicatorColor.withOpacity(0.4)),
                  color: Theme.of(context).colorScheme.onError.withAlpha(246),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}