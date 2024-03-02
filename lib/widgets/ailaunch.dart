import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Prelaunch extends StatefulWidget {
  @override
  _PrelaunchState createState() => _PrelaunchState();
}

class _PrelaunchState extends State<Prelaunch> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;
  bool isRequesting = false;
  TextEditingController ethAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_opacityController);
    _opacityController.forward();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    ethAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          _animatedBackground(),
          Center(
            child: isRequesting ? _requestForm() : _splashScreen(),
          ),
        ],
      ),
    );
  }

  Widget _animatedBackground() {
    // Implement your background animation
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(color: Colors.black),
    );
  }

  Widget _splashScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'TRUSTLESS BUSINESS ENVIRONMENT',
                textStyle: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
                speed: const Duration(milliseconds: 200),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => setState(() => isRequesting = true),
          child: Text("REQUEST BETA ACCESS", style: GoogleFonts.pressStart2p(fontSize: 15, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _requestForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Request Beta Access",
          style: GoogleFonts.pressStart2p(fontSize: 22, color: Colors.white),
        ),
        SizedBox(height: 20),
        TextField(
          controller: ethAddressController,
          decoration: InputDecoration(
            labelText: "Your ETH Address",
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Implement your logic to handle the request submission
            print("ETH Address: ${ethAddressController.text}");
          },
          child: Text("SUBMIT", style: GoogleFonts.pressStart2p(fontSize: 18, color: Colors.white)),
        ),
      ],
    );
  }
}
