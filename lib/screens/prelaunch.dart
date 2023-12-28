import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trustless/screens/projects.dart';
import 'package:universal_html/html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';
import '../main.dart';
import '../widgets/gameoflife.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:ui';
int caree = 1;
String col = "#7b8c94 9%, #9cb1b8 46%, #7f9191 66%, #63767d 96%";
List<Color> colors = [Color.fromARGB(255, 52, 56, 58), const Color(0xff899dac),const Color(0xff9cb1b8),   Color.fromARGB(255, 162, 164, 173),
  Color.fromARGB(255, 3, 38, 194),];
List<double> stops =[0.01, 0.3, 0.6, 0.8, 0.9];
List<Color> colors1 = [
  Color.fromARGB(178, 116, 118, 126),
  Color.fromARGB(195, 113, 115, 124),
  Color.fromARGB(188, 121, 120, 133),
  Color.fromARGB(190, 107, 115, 134),
  Color.fromARGB(192, 107, 122, 134),
];
List<double> stops1 = [0.0, 0.3, 0.6, 0.8, 0.9];
List<Color> colors2 = [
 Color.fromARGB(255, 185, 209, 219),
 Color(0xff899dac),
 Color.fromARGB(255, 157, 180, 197),
 Color.fromARGB(255, 172, 192, 216),
 Color.fromARGB(255, 192, 209, 241)
];
List<Color> the_colors = [
  Color.fromARGB(255, 163, 170, 177),
  Color.fromARGB(255, 155, 158, 170),
  Color.fromARGB(255, 160, 158, 175),
  Color.fromARGB(255, 107, 115, 134),
  Color.fromARGB(255, 100, 100, 114),
];
List<double> stops2 = [0.0, 0.14, 0.5, 0.8, 0.9];

class Prelaunch extends StatefulWidget {
  Prelaunch({Key? key, }) : super(key: key);
  bool loading = false;
  bool sevede0 = false;
  bool sevede1 = false;
  bool sevede2 = false;
  bool requesting = false;
  bool requested = false;
  bool captcha = false;
  
  String email = "";
  String ethaddress = "";
  String message = "";
  @override
  State<Prelaunch> createState() => _PrelaunchState();
}

class _PrelaunchState extends State<Prelaunch>with SingleTickerProviderStateMixin  {
  late WebViewXController webviewController;
     AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<double>? _blurAnimation;
  @override
  void initState() {
  
    _controller = AnimationController(
      duration: const Duration(milliseconds: 860), // Total duration for both animations
      vsync: this,
    );


    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn), // Opacity for first half
      ),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut), // Blur for second half
      ),
    );

    _controller!.forward(); // Start the animation on build
  

    Future.delayed(const Duration(milliseconds: 440), () {
      setState(() {
        widget.sevede0 = true;
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        widget.sevede1 = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 3400), () {
      setState(() {
        widget.sevede2 = true;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
       color: Colors.transparent,
        // color: Color.fromARGB(255, 155, 155, 155),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Expanded(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
               Positioned(
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.only(left:260,top:140,bottom:70),
                    decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors2, stops: stops2)
                  ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Text(""))),
              Opacity(
                opacity: 0.05,
                child: GameOfLife()),

              Positioned(
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.only(left:320,top:180,bottom:130),
                  
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: 
                      AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return FadeTransition(
              opacity: _opacityAnimation!,
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: _blurAnimation!.value,
                  sigmaY: _blurAnimation!.value,
                ),
                child: Pattern1(),
              ),
            );
          },
        )
                      


                      )),
                
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 4,
                ),
                child: Align(
                    alignment: Alignment.topRight,
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: widget.sevede0
                            ? MediaQuery.of(context).size.height
                            : 0,
                        width: widget.requesting ? 600 : 480,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: colors1,
                          stops: stops1,
                        )),
                        // color:Color.fromARGB(255, 27, 27, 27),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: widget.requesting ? form() : splash(),
                        ))),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: MediaQuery.of(context).size.width / 4),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 34,
                          width: 34,
                          child: TextButton(
                            onPressed: () {
                              launch("https://github.com/dorgtech");
                            },
                            child: Image.network(
                              "https://i.ibb.co/qWf3xck/github.png",
                              color: Color.fromARGB(255, 196, 196, 196),
                            ),
                          )),
                      SizedBox(
                          height: 34,
                          width: 34,
                          child: TextButton(
                            onPressed: () {
                              launch("https://discord.gg/DtdHV2wWqt");
                            },
                            child: Image.network(
                              "https://i.ibb.co/Nr7Psjm/discord.png",
                              color: Color.fromARGB(255, 196, 196, 196),
                            ),
                          )),
                      SizedBox(
                          height: 34,
                          width: 34,
                          child: TextButton(
                            onPressed: () {
                              launch("https://twitter.com/dorg_tech");
                            },
                            child: Image.network(
                              "https://i.ibb.co/sR4CWcJ/twitter-solid.png",
                              color: Color.fromARGB(255, 196, 196, 196),
                            ),
                          )),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 32,
                        child: Center(
                          child: Text(
                            "dOrg © ${DateTime.now().year}",
                            style: const TextStyle(
                                fontSize: 9, color: Colors.white60),
                          ),
                        ),
                      ),
                      SizedBox(width: 150),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  form() {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Request beta access",
            style: GoogleFonts.pressStart2p(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                widget.ethaddress = value;
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Your TEZ address',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          
          const SizedBox(
            height: 90,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: ButtonStyle(
                    // elevation: MaterialStateProperty.all(0.4),
                    ),
                child: SizedBox(
                  height: 38,
                  width: 100,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_back),
                        Text(
                          '  Back',
                          style: TextStyle(
                              fontFamily: 'Ubuntu Mono',
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.requesting = false;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0.4),
                ),
                child: SizedBox(
                  height: 38,
                  width: 100,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.send_rounded),
                        Text(
                          '  SEND',
                          style: TextStyle(
                              fontFamily: 'Ubuntu Mono',
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: widget.email.length > 3 &&
                        widget.ethaddress.length > 3 &&
                        widget.message.length > 3
                    ? () async {
                        String message = "New messaage on dorg.ml: \n\nemail " +
                            widget.email +
                            "\n" +
                            "ETH address: " +
                            widget.ethaddress +
                            "\n" +
                            "Message: " +
                            widget.message +
                            "\n-------------------";
                        // await send(message);
                        await sendfb();
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  final interestedRef = null;
  String webhook =
      "https://discord.com/api/webhooks/993530794788270080/lZlmlVgnlgMnfZegKEfhYYh1FKj5kFxTP9FID9OHMZlXAfJJV-1fJIcc-GLuJ5TVaL8B";

  sendfb() async {
    await interestedRef.add({
      "email": widget.email,
      "ethaddress": widget.ethaddress,
      "message": widget.message,
      "date": DateTime.now().toString()
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 50,
          alignment: Alignment.topRight,
          child:
              const Center(child: Text("Thanks! We'll get back to you soon.")),
        ),
      ),
    );
    setState(() {
      widget.requested = true;
      widget.requesting = false;
    });
  }

  send(message) async {
    var content = {"content": message};
    var headers = {"content-type": "application/json"};
    var uri = Uri.parse(webhook);
    var resp =
        await http.post(uri, body: json.encode(content), headers: headers);
    print(resp.toString());
    setState(() {
      widget.requested = true;
      widget.requesting = false;
    });
  }

  splash() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: SizedBox(
                height: 230,
                child: TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  pause: const Duration(seconds: 4),
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 31),
                  text: const ["TRUSTLESS \nBUSINESS"],
                  textStyle: GoogleFonts.pressStart2p(
                      height: 1.5,
                      color: Color.fromARGB(255, 253, 253, 253),
                      fontSize: 23),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 11,
        ),
        // AnimatedOpacity(
        //   duration: const Duration(seconds: 1),
        //   opacity: widget.sevede1 ? 1.0 : 0,
        //   curve: Curves.easeIn,
        //   child: TextButton(
        //     onPressed: () => showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //               contentPadding: const EdgeInsets.all(0),
        //               content: Container(
        //                   width: MediaQuery.of(context).size.width * 0.7,
        //                   child: Container(
        //                       color: Colors.blue,
        //                       child: Text("SOMETHING HERE"))),
        //             )),
        //     child: Text(
        //       "WATCH VIDEO",
        //       style: GoogleFonts.pressStart2p(
        //           height: 1.5,
        //           color: const Color.fromARGB(255, 196, 196, 196),
        //           fontSize: 15),
        //     ),
        //   ),
        // ),
        widget.requested
            ? const Text(" ")
            : AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: widget.sevede1 ? 1.0 : 0,
                curve: Curves.easeIn,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      widget.requesting = !widget.requesting;
                    });
                  },
                  child: Text(
                    "REQUEST BETA ACCESS",
                    style: GoogleFonts.pressStart2p(
                        height: 1.5,
                        color: const Color.fromARGB(255, 196, 196, 196),
                        fontSize: 15),
                  ),
                ),
              ),
        const SizedBox(
          height: 11,
        ),
       SizedBox(
            width: 158,
            height: 33,
            child: widget.loading
                ? const Center(
                    child:
                        SizedBox(height: 3, child: LinearProgressIndicator()),
                  )
                : TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(75, 0, 0, 0)),
                    ),
                    onPressed: () async {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => BaseScaffold(selectedItem:1, body:Projects(), title: 'Projects',))
                     ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.password),
                        SizedBox(width: 6),
                        Placeholder(
                          color: Color.fromARGB(255, 192, 192, 192),
                          child: SizedBox(height: 24),
                        ),

                        const Text(" ENTER CODE",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                      ],
                    )),
          )
       
      ],
    );
  }

  sainin(om) async {
    print("Signing into the thing");
    if (om.metamask) {
      setState(() {
        widget.loading = true;
      });
      String sainin = await om.signIn("andsaihdihaiduharei", context);
      print("sainin $sainin");
      if (sainin == "norep") {
        setState(() {
          widget.loading = false;
        });
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: SizedBox(
                      width: 400,
                      height: 100,
                      child: Center(
                          child: Text(
                              "You don't have any dOrg rep tokens on this account."))),
                ));
      }
      setState(() {
        widget.loading = false;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                height: 240,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Text(
                      "You need the Metamask wallet to sign into d0rg.",
                      style: TextStyle(fontFamily: "OCR-A", fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Placeholder(
                          color: Colors.grey,
                          child: SizedBox(width: 100),
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Placeholder(
                          color: Colors.grey,
                          child: SizedBox(height: 100),
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Download it from ",
                          style: TextStyle(fontFamily: "OCR-A", fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              launch("https://metamask.io/");
                            },
                            child: const Text(
                              "https://metamask.io/",
                              style:
                                  TextStyle(fontFamily: "OCR-A", fontSize: 16),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}

class Pattern1 extends StatefulWidget {
  @override
  _Pattern1State createState() => _Pattern1State();
}

class _Pattern1State extends State<Pattern1> with TickerProviderStateMixin {
  late AnimationController _controller1, _controller2, _sizeController, _positionController;
  late Animation<double> _opacity1, _opacity2, _blur1, _blur2, _size;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sizeController = AnimationController(
      duration: const Duration(milliseconds:810),
      vsync: this,
    )..repeat(reverse: true);

    _opacity1 = Tween<double>(begin: 0.1, end: 0.4).animate(_controller1);
    _blur1 = Tween<double>(begin: 0.0, end: 3.5).animate(_controller1);

    _opacity2 = Tween<double>(begin: 0.6, end: 0.7).animate(_controller2);
    _blur2 = Tween<double>(begin: 0.0, end: 2.0).animate(_controller2); // More subtle effect

    _size = Tween<double>(begin: 0.99, end: 1.001).animate(_sizeController); // S

    _positionController = AnimationController(
      duration: const Duration(milliseconds: 50), // Rapid changes for glitch effect
      vsync: this,
    )..repeat();

   _positionController.addListener(() {
      if (_positionController.isCompleted || _positionController.isDismissed) {
        // Randomizing both the duration and the end offset for a more glitch-like effect
        _positionController.duration = Duration(milliseconds: math.Random().nextInt(50) + 20);
        _position = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(math.Random().nextDouble() * 0.05, math.Random().nextDouble() * 0.05), // Smaller, random movements
        ).animate(_positionController);
        _positionController.forward(from: 0); // Restart the animation from the beginning
      }
    });

   _position = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.02, 0.02),
    ).animate(_positionController);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
         AnimatedBuilder(
          animation: _controller2,
          builder: (context, child) {
            return Opacity(
              opacity: 1,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: _blur2.value, sigmaY: _blur2.value),
                child: Image.asset("assets/tgri.png"),
              ),
            );
          },
        ),
        // AnimatedBuilder(
        //   animation: Listenable.merge([_controller1, _sizeController]),
        //   builder: (context, child) {
        //     return 
        //     Transform.scale(
        //       scale: _size.value,
        //       child: Opacity(
        //         opacity: _opacity1.value,
        //         child: ImageFiltered(
        //           imageFilter: ImageFilter.blur(sigmaX: _blur1.value, sigmaY: _blur1.value),
        //           child: Image.asset("assets/taur.png"),
        //         ),
        //       ),
        //     );
        //   },
        // ),

         AnimatedBuilder(
          animation: Listenable.merge([_sizeController, _positionController]),
          builder: (context, child) {
            return Transform.translate(
              offset: _position.value,
              child: Transform.scale(
                scale: _size.value,
                child: Opacity(
                  opacity: _opacity1.value,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: _blur1.value, sigmaY: _blur1.value),
                    child: Image.asset("assets/taur.png"),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _sizeController.dispose();
    _positionController.dispose();
    super.dispose();
  }
}




class Pattern extends StatefulWidget {
  @override
  _PatternState createState() => _PatternState();
}

class _PatternState extends State<Pattern> with TickerProviderStateMixin {
  late AnimationController _controller1, _controller2, _sizeController;
  late Animation<double> _opacity1, _opacity2, _blur1, _blur2, _size;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 810),
      vsync: this,
    )..repeat(reverse: true);

    _opacity1 = Tween<double>(begin: 0.1, end: 0.4).animate(_controller1);
    _blur1 = Tween<double>(begin: 0.0, end: 6.5).animate(_controller1);

    _opacity2 = Tween<double>(begin: 0.6, end: 0.7).animate(_controller2);
    _blur2 = Tween<double>(begin: 0.0, end: 4.0).animate(_controller2); // More subtle effect

    _size = Tween<double>(begin: 0.99, end: 1.001).animate(_sizeController); // Subtle size change
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        
        AnimatedBuilder(
          animation: _controller2,
          builder: (context, child) {
            return Opacity(
              opacity: 1,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: _blur2.value, sigmaY: _blur2.value),
                child: Image.asset("assets/tgri.png"),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: Listenable.merge([_controller1, _sizeController]),
          builder: (context, child) {
            return 
            Transform.scale(
              scale: _size.value,
              child: Opacity(
                opacity: _opacity1.value,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: _blur1.value, sigmaY: _blur1.value),
                  child: Image.asset("assets/taur.png"),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _sizeController.dispose();
    super.dispose();
  }
}




class AnimatedImages extends StatefulWidget {
  @override
  _AnimatedImagesState createState() => _AnimatedImagesState();
}

class _AnimatedImagesState extends State<AnimatedImages>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController flickerController;
  late AnimationController blurController;
  late AnimationController translationController;
  late Animation<Offset> animation;
  final random = Random();
  Offset translation = Offset(0, 0);
  @override
  void initState() {
    super.initState();
    blurController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    translationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<Offset>(
      begin: Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5),
      end: Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5),
    ).animate(
      CurvedAnimation(
        parent: translationController,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          translationController.reset();
          animation = Tween<Offset>(
            begin: Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5),
            end: Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5),
          ).animate(
            CurvedAnimation(
              parent: translationController,
              curve: Curves.linear,
            ),
          );
          translationController.forward();
        }
      });

    translationController.forward();

    controller1 = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);

    controller2 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    controller3 = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat(reverse: true);

    flickerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          flickerController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          flickerController.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    flickerController.dispose();
    blurController.dispose();
    translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildAnimatedBlur(blurController),
          alternate(),
          Opacity(
              opacity: 0.6,
              child: Container(
                color: Colors.black,
              )),
          Opacity(
              opacity: 0.7,
              child:
                  buildFlickeringImage(flickerController, 'assets/doar.png')),
        ],
      ),
    );
  }

  Widget smaller(Widget bigger) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 900,
        height: 900,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget,
            SizedBox(
              width: 400,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedImage(AnimationController controller, String asset) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: controller.value,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2,
                bottom: MediaQuery.of(context).size.height / 2,
                right: MediaQuery.of(context).size.width / 4,
                left: MediaQuery.of(context).size.width / 6,
              ),
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Image.asset(
                  asset,
                  height: 340,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget alternate() {
    return FittedBox(
      fit: BoxFit.cover,
      child: Padding(
          padding: EdgeInsets.all(200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/fara.png"),
              SizedBox(
                width: 500,
              )
            ],
          )),
    );
  }

  Widget buildAnimatedBlur(AnimationController controller) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, animation]),
      builder: (BuildContext context, Widget? child) {
        return FractionalTranslation(
          translation: animation.value,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.4, sigmaY: 2),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.white.withOpacity(0.0)
                      ],
                      stops: [0.0, 0.1, 0.9],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFlickeringImage(AnimationController controller, String asset) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(0.05 * controller.value)
            ..rotateY(0.04 * controller.value),
          alignment: FractionalOffset.center,
          child: Opacity(
            opacity: 0.3 +
                random.nextDouble() *
                    0.12, // Random opacity between 0.5 and 1.0
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.2 * controller.value),
                  BlendMode.softLight), // Increase brightness
              child: FittedBox(
                fit: BoxFit.cover,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2,
                    right: MediaQuery.of(context).size.width / 4,
                    bottom: MediaQuery.of(context).size.height / 2,
                  ),
                  child: Image.asset(
                    asset,
                    height: 400,
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
