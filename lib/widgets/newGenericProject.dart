

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustless/main.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../entities/project.dart';
import '../screens/projects.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';

const String escape = '\uE00C';
class NewGenericProject extends StatefulWidget {
ProjectsState projectsState;
bool loading=false;
bool done=false;
bool error=false;
Project project=Project(isUSDT: false);
int stage=0;
// ignore: use_key_in_widget_constructors
NewGenericProject( {required this.projectsState}) ;
  @override
  _NewGenericProjectState createState() => _NewGenericProjectState();
}
int pmttoken=0;
class _NewGenericProjectState extends State<NewGenericProject> {
  String _hash = '';
  String _fileName = '';
    Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      _fileName = result.files.first.name; // Store the file name
      var digest = sha256.convert(fileBytes);
      setState(() {
        _hash = digest.toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    DateTime.now().add(const Duration(days:1825 ));
    main(){
         switch (widget.stage) {
    case 0:
      return stage0();
    case 1:
      return stage1();
    case 2:
      return stage2();
    case 3:
      return stage3();
    default:
      return stage0();
  }
    }
    return
    Container(
          padding: const EdgeInsets.symmetric(horizontal:60,vertical: 35),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
              width: 0.3,
            ),
          ),
          // width: MediaQuery.of(context).size.width*0.7,
          // height: MediaQuery.of(context).size.height*0.96,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: main()
          ))
    );
  }

  bool pressedName = false;
  bool pressedDesc = false;
  stage3(){
    return Container(
       constraints: const BoxConstraints(minHeight: 500),
      child: Column(
        children: [
          SizedBox(height: 20),
          const Opacity(
            opacity: 0.9,
            child: Text("Select an Arbiter",style: TextStyle(fontSize: 22),)),

          const SizedBox(height: 60),
           Text("This is an independent third party with authority to allocate the funds in the project escrow in the event of a dispute.",),
           
           
           Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       TextButton(onPressed: (){setState(() {
                                  widget.stage=2;
                                });}, child: const Text("< Back")),
                      SizedBox(
                        height: 40,
                        width: 170,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                            elevation: MaterialStateProperty.all(1.0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                            ),
                          ),
                          onPressed: ()async{
                            widget.project.contractAddress=generateContractAddress();
                            projects.add(widget.project);
                            print("before set state "+projects.length.toString());
                            widget.projectsState.setState(() {});
                            print("after set state"+projects.length.toString());
                            await projectsCollection.doc(widget.project.contractAddress)
                            .set(widget.project.toJson());
                            await Future.delayed(const Duration(milliseconds: 100));
                            Navigator.of(context).pushNamed("/");
                          },
                           child: const Center(
                          child: Text("CREATE PROJECT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                        )),
                      ),
                    ],
                  )
        ],
      ),
    );
  }
  stage2(){
    
    return Container(
       constraints: const BoxConstraints(minHeight: 500),
      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Provide a detailed description of the good or service you wish to acquire, to set expectations for the contractor and also serve as a reference point during any potentioal dispute.", textAlign: TextAlign.left, style: TextStyle(fontSize: 17.5),),

                const SizedBox(height: 19),
                const Text("To ensure a smooth arbitration process we recommend cloning and customizing this template.", textAlign: TextAlign.left),
                     const SizedBox(height: 60,),
                  ],
                ),
                SizedBox(
                  // width:600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                      
                     ElevatedButton(
  onPressed: _pickFile,
  child: const Text('Select File', textAlign: TextAlign.center,),
  style: ElevatedButton.styleFrom(
    primary: Colors.transparent, // Transparent background
    onPrimary: Colors.white, // White text color
    shadowColor: Colors.transparent, // No shadow
    side: const BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 2.0), // Visible border
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0), // Square shape
    ),
    fixedSize: const Size(100, 100), // Square size
  ),
),    
const SizedBox(width: 48),
const SizedBox(
                        width: 460,
                        child: Text("Select the README.md file. This should not be modified throughout the life cycle of the project. A hash of its content will be immutably stored in the contract."
                        ,textAlign: TextAlign.justify,
                        )),
                    ],
                  ),
                ),
                Column(
      children: <Widget>[
      
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:38.0),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Text(_fileName.isNotEmpty ? 'File hash: ':"")
                  ),
                Text('$_hash', style: const TextStyle(fontWeight: FontWeight.w100),),
              ],
            ),
          )),
      ],
    ),
    const SizedBox(height: 30),
    const Center(
      child: Opacity(
        opacity: 0.1,
        child: Divider()),
    ),
    const SizedBox(height: 80),
                  SizedBox(
                    // width:630,
                    child: TextField(
                      onChanged: (value) {
                        widget.project.terms=value;
                      },
                      style: const TextStyle(fontSize: 13),
                      decoration:  const InputDecoration(
                        labelText: "Link to your project reposiory that includes the above hashed file.",
                        ),),
                  ),
                 const SizedBox(height: 107,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       TextButton(onPressed: (){setState(() {
                                  widget.stage=1;
                                });}, child: const Text("< Back")),
                      SizedBox(
                        height: 40,
                        width: 170,
                        child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      elevation: MaterialStateProperty.all(1.0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                    onPressed: (){
                     setState(() {
                       widget.stage=3;
                     });
                    },
                     child: const Center(
                    child: Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                  )),
                      ),
                    ],
                  )
                  ],
                ),
    ); 
  }
  stage1(){
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
           agentName(),
          const SizedBox(height: 30),

          agentDescription(),
                        const SizedBox(height: 175),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: (){setState(() {
                                widget.stage=0;
                              });}, child: const Text("< Back")),
                                SizedBox(
                  height: 40,
                  width: 170,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      elevation: MaterialStateProperty.all(1.0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                    onPressed: (){
                     setState(() {
                       widget.stage=2;
                     });
                    },
                     child: const Center(
                    child: Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                  )),
                )
                            ],
                          ),
                        ) 
        ],
      ),
    );
  }
  stage0(){
    return  Container(
      constraints: const BoxConstraints(minHeight: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 69),
                    const Opacity(opacity: 0.9, child:  Text("Select Project Currency:", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
                    const SizedBox(height: 39),

                    SizedBox(
                      width: 700,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 200,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => widget.project.isUSDT = false),
                                style: TextButton.styleFrom(
                                  primary: Colors
                                      .transparent, // Prevent color change on hover
                                ),
                                child: Text(
                                  "Native (XTZ)",
                                  style: TextStyle(
                                    color: !widget.project.isUSDT
                                        ? const Color.fromARGB(255, 110, 152, 206)
                                        : Colors.grey,
                                    fontSize: !widget.project.isUSDT ? 20 : 16,
                                  ),
                                ),
                              ),
                            ),
                            Switch(
                              value: widget.project.isUSDT,
                              onChanged: (value) =>
                                  setState(() => widget.project.isUSDT = value),
                              activeColor: Theme.of(context).primaryColor,
                              activeTrackColor: Colors.grey,
                              inactiveThumbColor: Theme.of(context).primaryColor,
                              inactiveTrackColor: Colors.grey,
                            ),
                            SizedBox(
                              width:200,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => widget.project.isUSDT = true),
                                style: TextButton.styleFrom(
                                  primary: Colors
                                      .transparent, // Prevent color change on hover
                                ),
                                child: Text(
                                  "Tether (USDT)",
                                  style: TextStyle(
                                    color: widget.project.isUSDT
                                        ? const Color.fromARGB(255, 110, 206, 113)
                                        : Colors.grey,
                                    fontSize: widget.project.isUSDT ? 20 : 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                SizedBox(
  width: 400,
  height: 250,
  child: Center(
    child: Opacity(
      opacity: 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min, // To keep the Row size to a minimum
        children: [
          Flexible(
            child: Text(
              widget.project.isUSDT
                  ? "Stablecoin pegged to the US dollar, offering market stability and widespread acceptance across major exchanges."
                  : "The token baked into the main consensus protocol of the chain, accounting for the execution of all smart contracts.",
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              launch(widget.project.isUSDT
                  ? "https://coinmarketcap.com/currencies/tether/"
                  : "https://coinmarketcap.com/currencies/tezos/");
            },
            child: const Text(
              " Learn more",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const Spacer(),
           SizedBox(
                  height: 40,
                  width: 170,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      elevation: MaterialStateProperty.all(1.0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                    onPressed: (){
                     setState(() {
                       widget.stage=1;
                     });
                    },
                     child: const Center(
                    child: Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                  )),
                )

        ],
      ),
    ),
  ),
)


                  ],
                ),
    );
    }
  UploadPic(){return const SizedBox(
    width: 150,height: 150,
    child: Placeholder());}
  createClientProject(project,state){print("create project");}
  Widget agentName() {
    var whatis =  SizedBox(
          width:400,
          height: 50,
          child: TextField(
              maxLength: 30,
              style: const TextStyle(fontSize: 21),
              decoration: const InputDecoration(hintText: 'Set project name'),
              onChanged: (value) => widget.project.name = value,
            ),
        );
    return SizedBox(
      width: 460,
      height: 50,
      child: widget.project.name == null ||widget.project.name == "N/A"
          ? whatis
          : Text(
              widget.project.name!,
              style: const TextStyle(fontSize: 21),
            ),
    );
  }
  Widget agentDescription() {
    var whatis = TextField(
            maxLength: 200,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Very short description of the project. Include specific technologies that will be used so they may show up if someone searches for them.',
            ),
            onChanged: (value) {
              widget.project.description = value;
            },
          );
    return Container(
      width: 470,
      height: 90,
      margin: const EdgeInsets.only(top: 26),
      child: widget.project.description == null||widget.project.description == "N/A"
          ? whatis
          : Text(
              widget.project.description!,
              style: const TextStyle(fontSize: 17),
            ),
    );
  }
}