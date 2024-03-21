import 'package:flutter/material.dart';
import 'package:trustless/entities/human.dart';

class AnimatedFabWithOverlay extends StatefulWidget {
  @override
  AnimatedFabWithOverlayState createState() => AnimatedFabWithOverlayState();
}

class AnimatedFabWithOverlayState extends State<AnimatedFabWithOverlay> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  OverlayEntry? overlayEntry;
  

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addListener(() {
        overlayEntry?.markNeedsBuild();
      });
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  OverlayEntry createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(builder: (context) {
      return Positioned(
        left: offset.dx - (size.width / 2),
        top: offset.dy - ((MediaQuery.of(context).size.height-190) * animation.value),
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: Container(
            height: (MediaQuery.of(context).size.height-190) * animation.value, // Adjust based on your need
            color: Colors.blue,
          ),
        ),
      );
    });
  }

  void toggleOverlay() {
    if (Human().isOverlayVisible) {
      controller.reverse();
      overlayEntry?.remove();
    } else {
      overlayEntry = createOverlayEntry();
      Overlay.of(context)?.insert(overlayEntry!);
      controller.forward();
    }
    Human().isOverlayVisible = !Human().isOverlayVisible;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: toggleOverlay,
      child: Icon(Human().isOverlayVisible ? Icons.close : Icons.add),
    );
  }

  @override
  void dispose() {
    print("disposing of this");
    if(Human().isOverlayVisible){toggleOverlay();}
    controller.dispose();
    super.dispose();
  }
}
