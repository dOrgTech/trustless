import 'package:flutter/material.dart';
import 'package:trustless/widgets/action.dart';
import 'package:trustless/widgets/governance.dart';
import 'dart:ui' as ui;

import 'package:trustless/widgets/popTopLeft.dart';
import 'package:trustless/widgets/popTopRight.dart';

import '../utils/scripts.dart';
          // final double scaleFactor = MediaQuery.of(context).size.width * MediaQuery.of(context).size.height < 1600000 ? 0.8 : 1.0;

class CoolAnimationWidget extends StatefulWidget {
  @override
  _CoolAnimationWidgetState createState() => _CoolAnimationWidgetState();
}

class _CoolAnimationWidgetState extends State<CoolAnimationWidget> with TickerProviderStateMixin {
  late AnimationController topLeftController;
  late AnimationController topRightController;
  late AnimationController bottomLeftController;
  
  late Animation<double> topLeftHeightAnimation;
  late Animation<double> topRightHeightAnimation;
  late Animation<double> bottomLeftHeightAnimation;

  late AnimationController shadowAnimationController;
  late Animation<double> blurRadiusAnimation;
  late Animation<double> spreadRadiusAnimation;
  late Animation<Offset> shadowOffsetAnimation;
  late AnimationController textFadeController;
late Animation<double> textOpacityAnimation;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  double _childHeight = 0.0; // Placeholder value
  GlobalKey _childKey = GlobalKey();
  @override
  void initState() {
    super.initState();
 _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    // Controllers for the expansion animations with slightly varied durations
    topLeftController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    topRightController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    bottomLeftController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _heightAnimation = Tween<double>(begin: 0, end: 100).animate(_controller); // Placeholder end value
    _controller.forward();WidgetsBinding.instance.addPostFrameCallback((_) => _updateAnimation());
    topLeftHeightAnimation = Tween<double>(begin: 0, end:120).animate(topLeftController);
    topRightHeightAnimation = Tween<double>(begin: 0, end: 700).animate(topRightController);
    bottomLeftHeightAnimation = Tween<double>(begin: 0, end: 800).animate(bottomLeftController);

    // Shadow animation controller
    shadowAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat(reverse: true);
    blurRadiusAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(CurvedAnimation(parent: shadowAnimationController, curve: Curves.easeInOut));
    spreadRadiusAnimation = Tween<double>(begin: 3.0, end: 5.0).animate(CurvedAnimation(parent: shadowAnimationController, curve: Curves.easeInOut));
    shadowOffsetAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 2)).animate(CurvedAnimation(parent: shadowAnimationController, curve: Curves.easeInOut));

    // Start the expansion animations
    topLeftController.forward();
    topRightController.forward();
    bottomLeftController.forward();
    textFadeController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 150), // Duration for the text fade-in effect
  );

  // Define the opacity animation
  textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(textFadeController);
  }
void _updateAnimation() {
    // Delay to simulate loading or to wait for layout
    Future.delayed(Duration(milliseconds: 600), () {
      if (_childKey.currentContext != null) {
        final RenderBox renderBox = _childKey.currentContext!.findRenderObject() as RenderBox;
        _childHeight = renderBox.size.height;

        // Update the animation with the actual height
        setState(() {
          _heightAnimation = Tween<double>(
            begin: _heightAnimation.value, // Start from current value to avoid jump
            end: _childHeight,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          );
        });

        _controller
          ..reset()
          ..forward();
      }
    });
  }
  @override
  void dispose() {
    topLeftController.dispose();
    topRightController.dispose();
    bottomLeftController.dispose();
    shadowAnimationController.dispose();
     textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).size.width * MediaQuery.of(context).size.height < 1600000 ? 0.8 : 1.0;

    final screenWidth = MediaQuery.of(context).size.width;
    List<Color> containerColors = [
      Theme.of(context).canvasColor.withOpacity(1),
      Theme.of(context).canvasColor.withOpacity(0.89),
    ];
    List<double> stops = [0.01, 0.59]; 

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
          children: [
      // buildAnimatedContainer(
      //     scaleFactor,
      //      MediaQuery.of(context).size.width/MediaQuery.of(context).size.width/1.6,
      //     AnimatedStatsDisplay(),
      //     MediaQuery.of(context).size.width*0.69 , // 40% of screen width
      //     topLeftHeightAnimation,
      //     containerColors,
      //     stops,
      //     BorderRadius.only(bottomRight: Radius.circular(120)),
      //   ),
  buildTopLeft(
              context,
              scaleFactor,
              AnimatedStatsDisplay(),
              300, // maxwidth
              screenWidth * 0.6,
              topLeftHeightAnimation,
              containerColors,
              stops,
              BorderRadius.only(bottomRight: Radius.circular(150)),
            ),
      
     buildAnimatedContainer(
          scaleFactor,
          MediaQuery.of(context).size.width*0.95, 
          BuyATN(),
          screenWidth * 0.30, // 30% of screen width
          topRightHeightAnimation,
          containerColors,
          stops,
          BorderRadius.only(bottomLeft: Radius.circular(120)),
          isRight: true,
        ),
      buildAnimatedContainer(
        scaleFactor,
        MediaQuery.of(context).size.aspectRatio>1.4?
        MediaQuery.of(context).size.width/MediaQuery.of(context).size.aspectRatio/1.6:
         MediaQuery.of(context).size.width/(MediaQuery.of(context).size.aspectRatio*3.6)
        
        , 
        ActivityFeed(users: users),
        screenWidth * 0.6, // 20% of screen width
        bottomLeftHeightAnimation,
        containerColors,
        stops,
        BorderRadius.only(topRight: Radius.circular(120)),
        isBottom: true,
        additionalBottomOffset: 150, // Start higher by 150px
      ),
          ],
        ),
    );
  }

 Widget buildTopLeft(
  context,
  double scaleFactor,
  Widget ceBagam,

  var maxHeight,
  double width, Animation<double> heightAnimation, List<Color> colors, List<double> stops, BorderRadius borderRadius, {bool isRight = false, bool isBottom = false, double additionalBottomOffset = 0.0}) {
      
    double screenWidth = MediaQuery.of(context).size.width;

    double scale = screenWidth < 1900 ? 1 - (((1900 - screenWidth).ceil() / 190) * 0.1) : 1.0;
    
    Widget childWidget;
    
    return AnimatedBuilder(
      animation: Listenable.merge([heightAnimation, shadowAnimationController, textOpacityAnimation]),
      builder: (_, child) {
        return Positioned(
          top: isBottom ? null : 0,
          bottom: isBottom ? additionalBottomOffset : null,
          left: isRight ? null : 0,
          right: isRight ? 0 : null,
          child: 
          isRight?ceBagam:
          Transform.scale(
            alignment: Alignment.topLeft,
            scale:  scale,
            child: MediaQuery(
              data: MediaQueryData().copyWith(textScaleFactor: 1),
              child: Container(
                constraints: BoxConstraints(maxHeight: maxHeight),
                width: width,
                height: heightAnimation.value,
                decoration: BoxDecoration(
                  
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).indicatorColor.withOpacity(0.2),
                      blurRadius: blurRadiusAnimation.value,
                      spreadRadius: spreadRadiusAnimation.value,
                      offset: shadowOffsetAnimation.value,
                    ),
                    BoxShadow(
                      color: Theme.of(context).canvasColor.withOpacity(0.96),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Container(
                    color: Color.fromARGB(0, 0, 0, 0), // Assuming you want a transparent inner container
                    child: Center(
                      child: AnimatedBuilder(
                        
                        animation: textOpacityAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: textOpacityAnimation.value,
                            child: child,
                          );
                        },
                        child:ceBagam
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
   } );
  }
 

// Widget buildACwithParentSize(
//     Widget child,
//    double maxWidth,

//     Animation<double> animation,
//     List<Color> colors,
//     List<double> stops,
//     BorderRadius borderRadius, {
//     bool isRight = false,
//     bool isBottom = false,
//     double additionalBottomOffset = 0.0,
// }) {
//     return AnimatedBuilder(
//         animation: Listenable.merge([animation, shadowAnimationController, textOpacityAnimation]),
//         builder: (_, widgetChild) {
//             return Positioned(
//                 top: isBottom ? null : 0,
//                 bottom: isBottom ? additionalBottomOffset : null,
//                 left: isRight ? null : 0,
//                 right: isRight ? 0 : null,
//                 child: AnimatedSize(
//                     duration: Duration(milliseconds: 100),
//                     curve: Curves.easeOut,
//                     child: Container(
//                         constraints: BoxConstraints(
//                           maxWidth: maxWidth,
                          
//                           minHeight: animation.value,
//                         ),
//                         decoration: BoxDecoration(
//                             borderRadius: borderRadius,
//                             boxShadow: [
//                                 BoxShadow(
//                                   color: Theme.of(context).indicatorColor.withOpacity(0.2),
//                                   blurRadius: blurRadiusAnimation.value,
//                                   spreadRadius: spreadRadiusAnimation.value,
//                                   offset: shadowOffsetAnimation.value,
//                                 ),
//                                 BoxShadow(
//                                   color: Theme.of(context).canvasColor.withOpacity(0.8),
//                                   blurRadius: 0,
//                                   spreadRadius: 0,
//                                 ),
//                             ],
//                         ),
//                         child: ClipRRect(
//                             borderRadius: borderRadius,
//                             child: child,
//                         ),
//                     ),
//                 ),
//             );
//         },
//     );
// }


Widget buildAnimatedContainer(
    double scaleFactor,
    double maxHeight,
    Widget ceBagam,
    double width,
    Animation<double> heightAnimation,
    List<Color> colors,
    List<double> stops,
    BorderRadius borderRadius, {
    bool isRight = false,
    bool isBottom = false,
    double additionalBottomOffset = 0.0,
  }) {
    // Assuming textFadeController and textOpacityAnimation are initialized in initState

    // Listen to the height animation completion to trigger text fade-in
    heightAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Check to ensure the animation doesn't restart if it's already running or completed
        if (textFadeController.status != AnimationStatus.forward &&
            textFadeController.status != AnimationStatus.completed) {
          textFadeController.forward();
        }
      }
    });

    return AnimatedBuilder(
      animation: Listenable.merge([heightAnimation, shadowAnimationController, textOpacityAnimation]),
      builder: (_, child) {
        return Positioned(
          top: isBottom ? null : 0,
          bottom: isBottom ? additionalBottomOffset : null,
          left: isRight ? null : 0,
          right: isRight ? 0 : null,
          child: 
          isRight?ceBagam:
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            width: width,
            height: heightAnimation.value,
            decoration: BoxDecoration(
              
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).indicatorColor.withOpacity(0.2),
                  blurRadius: blurRadiusAnimation.value,
                  spreadRadius: spreadRadiusAnimation.value,
                  offset: shadowOffsetAnimation.value,
                ),
                BoxShadow(
                  color: Theme.of(context).canvasColor.withOpacity(0.8),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                color: Color.fromARGB(0, 0, 0, 0), // Assuming you want a transparent inner container
                child: Center(
                  child: AnimatedBuilder(
                    
                    animation: textOpacityAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: textOpacityAnimation.value,
                        child: child,
                      );
                    },
                    child:ceBagam
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}









