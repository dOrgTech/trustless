

import 'dart:isolate';
import 'dart:html' as html;
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustless/widgets/waiting.dart';
import 'package:url_launcher/url_launcher.dart';
import '../entities/human.dart';
import '../entities/project.dart';
import '../main.dart';
const String escape = '\uE00C';

class SetParty extends StatefulWidget {
bool loading=false;
bool done=false;
bool error=false;
Project project;
bool waiting=false;
// ignore: use_key_in_widget_constructors
SetParty({required this.project}) ;
TextEditingController arbiterControlla = TextEditingController();
TextEditingController contractorControlla = TextEditingController();
  @override
  SetPartytate createState() => SetPartytate();
}
int pmttoken=0;
class SetPartytate extends State<SetParty> {
  
  @override
  Widget build(BuildContext context) {
 
    return
    Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
    child: widget.waiting?WaitingOnChain():stage1());
  }

  bool pressedName = false;
  bool pressedDesc = false;
 String _hash = '';
  String _fileName = '';
    Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      _fileName = result.files.first.name; // Store the file name
      
      var digest = sha256.convert(fileBytes);
      setState(() {
        widget.project.hashedFileName=_fileName;
        _hash = digest.toString();
        widget.project.termsHash=_hash;
      });
    }
  }
 stage1(){
     bool isButtonActive = widget.project.contractor!.length > 2 &&
                      widget.project.arbiter!.length > 2 &&
                      widget.project.termsHash!.length > 4;
    return Container(
      key: const ValueKey(1),
      constraints: const BoxConstraints(minHeight: 500,maxWidth: 1200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
             const Opacity(
            opacity: 0.9,
            child: Text("Set Parties",style: TextStyle(fontSize: 22),)),
          const SizedBox(height: 25),
  RichText(
  text: TextSpan(
    style: DefaultTextStyle.of(context).style, // Set default text style from the theme
    children: <TextSpan>[
      const TextSpan(
        text: "If you already have already reached an arrangement with someone for the work specified in this Project, add their wallet or contract address in the field below. Their participation will be formalized once they sign this Project contract and stake half of the arbitration fee. You also need to specify the Arbiter at this point. Please refer to ",
      ),
      TextSpan(
        text: 'the docs',
        style: const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Link handling code
            launch("https://your-link-to-the-docs.com");
          },
      ),
      const TextSpan(
        text: " to learn more about the role of the arbiter.",
      ),
    ],
  ),
)
,

          const SizedBox(height: 60),
          Container(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child:  TextField(
                      controller: widget.contractorControlla,
                      onChanged: (value){setState(() {
                        widget.project.contractor=value;
                      });},
                      style: const TextStyle(fontSize: 13),
                      decoration:  const InputDecoration(
                        labelText: "Contractor Address",
                        ),),
                  ),
          const SizedBox(height: 40),
         Container(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: TextField(
                      controller: widget.arbiterControlla,
                       onChanged: (value){setState(() {
                        widget.project.arbiter=value;
                      });},
                      style: const TextStyle(fontSize: 13),
                      decoration:  const InputDecoration(
                        labelText: "Arbiter Address",
                        ),),
                  ), 
                const SizedBox(height: 39),
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
            // White text color
              shadowColor: Colors.transparent, // No shadow
              side: const BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 2.0), // Visible border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Square shape
              ),
              fixedSize: const Size(100, 100), // Square size
            ),
          ),    
          const SizedBox(width: 38),
          const SizedBox(      
            child: SizedBox(
                    width: 500,
                    child: Text("Select the TERMS.md file. This should not be modified throughout the life cycle of the project. A hash of its content will be immutably stored in the contract."
                    ,textAlign: TextAlign.justify,
                    ),
                  )),
                ],
                ),
                ),
              const SizedBox(height: 24),
                  Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:38.0),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Text(_fileName.isNotEmpty ? 'File hash: ':"",)
                  ),
                Text('$_hash', style:  const TextStyle(fontWeight: FontWeight.w100, color:Color.fromRGBO(253, 251, 231, 1), backgroundColor: Colors.black),),
              ],
            ),
          )),
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal:80.0),
            child: Text("The Contractor will need to sign this Project contract before the funds are locked in Escrow. Make sure they agree with the terms as well as the designated Arbiter."),
          ),
              const Spacer(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       SizedBox(height: 30,width: 150,
                    child: Opacity(
                      opacity: 0.6,
                      child: TextButton(
                        style: ButtonStyle(
                          // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                          // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                          elevation: MaterialStateProperty.all(0.0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                        ),
                          onPressed:
                        (){
                        Navigator.of(context).pop();
                        },
                          child: const Center(
                        child: Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      )),
                    ),
                  ),
                      SizedBox(
                        child: SizedBox(
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
                        onPressed: isButtonActive ? () async {
                        if (Human().address?.toString() != widget.project.author?.toString()) {
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              content: SizedBox(height: 100, width: 400, child: Center(child: Text("You are not signed in as the Author of this Project.", textAlign: TextAlign.center,))),
                            ),
                          );
                        } else {
                          // Proceed with the transaction if the user is the author
                             setState(() {
                                widget.waiting=true;
                              });
                          String cevine = await cf.setNativeParties(widget.project, this);
                          if (cevine.contains("nu merge")){
                            print("nu merge din setParty");
                            return;
                          }
                          widget.project.status = "pending";
                          await projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                          Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                        }
                      } : null,
                          
                          child: const Center(
                        child: Text("SUBMIT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.black),),
                      ))
                      ),
                              ),
                    ],
                  ),
                        ) 
                    ],
                  ),
                );
              }



            
            }


