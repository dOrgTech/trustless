

import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/utils/transitions.dart';
import 'package:trustless/widgets/waiting.dart';
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
Project project=Project(isUSDT: false,
arbiter: "",
contractor: "",
contractAddress: "",
status: "pending"
);
TextEditingController arbiterControlla = TextEditingController();
TextEditingController contractorControlla = TextEditingController();
TextEditingController nameControlla = TextEditingController();
TextEditingController descriptionControlla = TextEditingController();
TextEditingController repoControlla = TextEditingController();
int stage=0;
// ignore: use_key_in_widget_constructors
NewGenericProject( {required this.projectsState}) ;
  @override
  _NewGenericProjectState createState() => _NewGenericProjectState();
}
int pmttoken=0;

class _NewGenericProjectState extends State<NewGenericProject> {
  @override
  void initState() { 
    widget.project.name="";
    widget.project.description="";
    widget.project.arbiter="";
    widget.project.repo="";
    widget.project.hashedFileName="";
    widget.project.termsHash="";
    widget.arbiterControlla.text=widget.project.arbiter!;
    widget.contractorControlla.text=widget.project.contractor!;
    widget.repoControlla.text=widget.project.repo!;
    // TODO: implement initState
    super.initState();
  }
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
            return stage13();
          case 4:
            return stage14();
          case 5:
            return stage2();
          case 6:
            return WaitingOnChain();
          default:
            return stage0();
        }
    }
    return
   MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 
 MediaQuery.of(context).size.height<900? 0.7:0.93
  ),
  child: 
    Container(
            // width:700,
            // height: 800,
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
              child: AnimatedSwitcher(
                switchInCurve:Curves.ease,
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(widget.stage),
            child: 
            // Container(child:Text("this works")),
            main(),
          ),
        ),
      ),
    ),
  ));
  }

  bool pressedName = false;
  bool pressedDesc = false;
  stage2(){
         return Container(
          key: const ValueKey(2),
       constraints: const BoxConstraints(
       ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Deploying ${widget.project.status!.toUpperCase()} Project to the Trustless Business Ecosystem:"),
          const SizedBox(height: 45),
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                SizedBox(height:50, child:Text("")),
                SizedBox(height: 13),
                Text(""),
            ],),
         const SizedBox(width: 60),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                 SizedBox(
                  height: 50,
                   child: Text(widget.project.name!,style: const TextStyle(fontSize: 22,
                   backgroundColor: Colors.black,
                   color: Colors.white,
                   ),),
                 ),
                  SizedBox(
                    width: 470,
                    child: Text(widget.project.description!, style: const TextStyle(  backgroundColor: Colors.black,
                              color: Colors.white,),),
                  ),
            ],)
          ],),
          const SizedBox(height: 30),
             Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Currency:"),
                const SizedBox(height: 8),
                const Text("author (you):"),
                const SizedBox(height: 8),
                const Text("Project Repository:"),
                const SizedBox(height: 8),
                const Text("Terms File:"),
                const SizedBox(height: 8),
                const Text("Terms Hash:"),
                const SizedBox(height: 8),
                const Text("Contractor:"),
                const SizedBox(height: 8),
                const Text("Arbiter:"),
            ],),
         const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.project.isUSDT?"USDT":Human().chain.nativeSymbol, style: const TextStyle( backgroundColor: Colors.black,color: Colors.white),),
                const SizedBox(height: 8),
                Text(Human().address??"3dp317hdqo8we7dhoq873hod827dh" ,style: const TextStyle( backgroundColor: Colors.black,color: Colors.white), ),
                const SizedBox(height: 10),
                Text(widget.project.repo!,style: const TextStyle( backgroundColor: Colors.black,color: Colors.white),),
                const SizedBox(height: 8),
                Text(widget.project.hashedFileName!.length<3?"N/A":widget.project.hashedFileName!,style: const TextStyle( backgroundColor: Colors.black,color: Colors.white),),
                const SizedBox(height: 10),
                Text(widget.project.termsHash!.length<3?"N/A":widget.project.termsHash!,style: const TextStyle(fontSize: 11, backgroundColor: Colors.black,color: Colors.white),),
                const SizedBox(height: 8),
                Text(widget.project.contractor!.length<3?"N/A":widget.project.contractor!, style: const TextStyle( backgroundColor: Colors.black,color: Colors.white),),
                const SizedBox(height: 8),
                Text(widget.project.arbiter!.length<3?"N/A":widget.project.arbiter!, style: const TextStyle( backgroundColor: Colors.black,color: Colors.white),),
            ],)
          ],),
          const SizedBox(height: 45), 
          Text(
            widget.project.status=="pending"?
            "To deploy the Project you must stake your half of the arbitration fee. Until the contractor signs and stakes their half, you will still be able to withdraw this amount. The stake will be released back to the parties if the Project concludes without a dispute."
            :
            "You may deploy this project without staking half of the arbitration fee, but will need to to so later when you set the parties and terms. While the project is open and/or pending, people can send and withdraw funds from it at will. One can only withdraw what they had previously put in."
            ),
          const SizedBox(height: 25),
            Row(children: [
            Padding(
              padding: const EdgeInsets.only(left:178.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("Arbitration fee: "),
                  SizedBox(height: 8),
                  Text("Your half (due now): "),
              ],),
            ),
         const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.project.isUSDT?"160.0 USDT":"200.00 ${Human().chain.nativeSymbol}"),
                const SizedBox(height: 8),
                Text(
                  widget.project.status=="pending"
                         ?
                  widget.project.isUSDT?"80.0 USDT":"100.00 ${Human().chain.nativeSymbol}"
                         :
                 widget.project.isUSDT?"0.00 USDT":"0.00 ${Human().chain.nativeSymbol}"
                ),
            ],),
          ],),
           const SizedBox(height: 60),
           Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                TextButton(onPressed: (){setState(() {
                          widget.stage=1;
                        });}, child: const Text("< Back")),
                          StepProgressIndicator(currentStep: 5),
                SizedBox(
                  height: 40,
                  width: 170,
                  child: 
                  TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Set background color to black
              elevation: MaterialStateProperty.all(1.0),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  side: BorderSide(color: Theme.of(context).indicatorColor, width: 1.0), // Use current indicatorColor for outline
                ),                                                                                                                                                                                
              ),
                shadowColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor), // Optional: Use for shadow
            ),
                  onPressed: () async {
                      widget.project.author = Human().address;
                      setState(() {
                        widget.stage=6;
                      });
                      var address= await cf.createProject(widget.project, widget.projectsState);
                      print("deployed contract with address "+address);
                      widget.project.contractAddress=address;
                      await projectsCollection.doc(widget.project.contractAddress)
                      .set(widget.project.toJson());
                      // await Future.delayed(const Duration(seconds: 13));
                      setState(() {
                        widget.projectsState.setState(() {
                          projects.add(widget.project);
                        });
                      });
                      Navigator.of(context).pushNamed("/projects/$address");
                  },
                  child:  const Center(
                    child: Text(
                      "DEPLOY PROJECT",
                      style: TextStyle(
                         color:Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
             ],
          )
        ],
      ),
    );
  }
  stage14(){
      return Container(
        key: const ValueKey(4),
      width:800,
       constraints: const BoxConstraints(minHeight: 500),
      child: Column(
        children: [
           
          const SizedBox(height: 10),
          const Opacity(
            opacity: 0.9,
            child: Text("Set an Arbiter",style: TextStyle(fontSize: 22),)),
          const SizedBox(height: 40),
           const Text("This is a third party with authority to allocate the funds held in escrow in the event of a dispute. Both you and the Contractor hold the prerogative to initiate a dispute. The address must be of a Smart Contract, not of a User Wallet."),
          const SizedBox(height: 50),
          SizedBox(
                    // width:630,
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
           
          const SizedBox(height: 70),
          const Text("The Arbiter may also be set after deploying the contract. Skip to proceed without a designated Arbiter."),
          const SizedBox(height: 100),
           Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       TextButton(
                        onPressed: (){setState(() {
                                  widget.stage=1;
                                });}, child: const Text("< Back")),
                                 StepProgressIndicator(currentStep: 4),
                      SizedBox(
                        height: 40,
                        width: 170,
                        child: TextButton(
                          style: ButtonStyle(
                            // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                            // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                            elevation: MaterialStateProperty.all(1.0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                            ),
                          ),
                          onPressed: (){
                          setState(() {
                            widget.stage=5;
                          });
                          },
                           child:  Center(
                         child:  widget.project.arbiter!.length<3||widget.project.contractor!.length<3||widget.project.termsHash!.length < 3 ?
                          const Text("   Skip   ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),)
                          :
                          const Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),),
                                                 )),
                      ),
                    ],
                  )
        ],
      ),
    );
  }
  stage13(){
    return Container(
      key: const ValueKey(3),
      width:800,
       constraints: const BoxConstraints(minHeight: 500),
      child: Column(
        children: [
           
          const SizedBox(height: 10),
          const Opacity(
            opacity: 0.9,
            child: Text("Set a Contractor",style: TextStyle(fontSize: 22),)),
          const SizedBox(height: 40),
          const Text("If you already have already reached an arrangement with someone for the work specified in this Project, add their wallet or contract address in the field below. Their participation will be formalized once they sign this Project contract and stake half of the arbitration fee."),
          const SizedBox(height: 50),
          SizedBox(
                    // width:630,
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
           
           
          const SizedBox(height: 70),
          const Text("The Contractor may also be set after deploying the Project on chain. Skip to proceed without a designated Contractor."),
          const SizedBox(height: 100),
           Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       TextButton(onPressed: (){
                        setState(() {
                                  widget.stage=2;
                                });}
                         , child: const Text("< Back")),
                          StepProgressIndicator(currentStep: 3),
                      SizedBox(
                        height: 40,
                        width: 170,
                        child: TextButton(
                          style: ButtonStyle(
                            // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                            // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                            elevation: MaterialStateProperty.all(1.0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                            ),
                          ),
                          onPressed: (){
                          setState(() {
                            widget.stage=1;
                          });
                          },
                           child: Center(
                          child: 
                          widget.project.contractor!.length<3?
                          const Text("   Skip   ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),)
                          :
                          const Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),),
                        )),
                      ),
                    ],
                  )
        ],
      ),
    );
  }
  stage12(){
    
    return Container(
      key: const ValueKey(2),
       constraints: const BoxConstraints(minHeight: 500),
      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Provide a detailed description of the good or service you wish to acquire, to set expectations for the contractor and also to serve as reference during a potential dispute.", textAlign: TextAlign.left, style: TextStyle(fontSize: 17.5),),

                const SizedBox(height: 19),
        RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          const TextSpan(text: "For a smooth arbitration, it's recommended to clone and customize "),
          TextSpan(
            text: 'this template',
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://github.com/dOrgTech/template-project');
              },
          ),
        ],
      ),
    ),
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
   // White text color
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
                  child: Text("Select the TERMS.md file. This should not be modified throughout the life cycle of the project. A hash of its content will be immutably stored in the contract."
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
                      controller: widget.repoControlla,
                      onChanged: (value) {
                        setState(() {
                        widget.project.repo=value;
                        });
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
                                 StepProgressIndicator(currentStep: 2),
                      SizedBox(
                        height: 40,
                        width: 170,
                        child: TextButton(
                    style: ButtonStyle(
                      // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      elevation: MaterialStateProperty.all(1.0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ),
                    onPressed: widget.project.hashedFileName!.length>1
                    && 
                    widget.project.repo!.length>3?
                    (){
                     setState(() {
                       widget.stage=3;
                     });
                    }:null,
                     child: const Center(
                    child: Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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
      key: const ValueKey(1),
      constraints: const BoxConstraints(minHeight: 500),
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
          SizedBox(
                    // width:630,
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
          SizedBox(
                    // width:630,
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
          const Text("The Parties may also be set after deploying the Project on chain. Skip to proceed without a designated Contractor and deploy your contract as Open, allowing potential contractors to compete in proposals."),
          
                        const SizedBox(height: 45),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: (){setState(() {
                                widget.stage=0;
                              });}, child: const Text("< Back")),
                               StepProgressIndicator(currentStep: 1),
                                SizedBox(
                  height: 40,
                  width: 170,
                  child: TextButton(
                    style: ButtonStyle(
                      // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                      elevation: MaterialStateProperty.all(1.0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ),
                     onPressed:
                    (){
                      if(
                      widget.project.contractor!.length > 1
                      && widget.project.arbiter!.length > 1
                      && widget.project.termsHash!.length> 3
                      ){
                      print("pending");
                      widget.project.status="pending";
                      setState(() {
                          widget.stage=2;
                      });
                      }else{
                      print("open");
                     setState(() {
                       widget.stage=2;
                        widget.project.status="open";
                      widget.project.contractor="";
                      widget.project.arbiter="";
                      widget.project.termsHash="";
                      widget.contractorControlla.text="";
                      widget.arbiterControlla.clear();
                      widget.contractorControlla.clear();
                     });
                    }},
                     child:  Center(
                    child: Text(
                       (widget.project.contractor!.length > 1
                      && widget.project.arbiter!.length > 1
                      && widget.project.termsHash!.length> 3
                      ) 
                          ? 
                      "CONTINUE":"Skip"
                    
                    , style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),),
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
      key: const ValueKey(0),
      // constraints: const BoxConstraints(minHeight: 500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        const SizedBox(height: 5),
                        agentName(),
                      const SizedBox(height: 10),

          agentDescription(),
                      // const SizedBox(height: 29),
                      // const Opacity(opacity: 0.9, child:  Text("Select Project Currency:", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
                      const SizedBox(height: 2),
      
                      Container(
                         padding: const EdgeInsets.only(bottom:30),
                         decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          border: Border.all(width: .5,
                          color: 
                             widget.project.isUSDT?
                              const Color.fromARGB(255, 122, 133, 126):
                              const Color.fromARGB(255, 122, 127, 133)
                          )
                        ),
                        child: Column(
                          
                          children: [

                            Container(
                              width:550,
                              color:
                              widget.project.isUSDT?
                              const Color.fromARGB(255, 122, 133, 126):
                              const Color.fromARGB(255, 122, 127, 133)
                              ,
                              
                              height: 30,child:const Center(child: Text("Select Currency", style:TextStyle(color:Colors.white)))),
                            SizedBox(
                              width: 550,
                              child: Padding(
                                padding: const EdgeInsets.only(left:13.0,right:13,top:13,bottom:10),
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
                                          "Native (${Human().chain.nativeSymbol})",
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
                                      activeColor:  Colors.white24,
                                      activeTrackColor: Colors.grey,
                                      inactiveThumbColor: Colors.white24,
                                      inactiveTrackColor:Colors.grey,
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
                            width: 440,
                            child: Opacity(
                              opacity: 0.7,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.project.isUSDT
                                        ? "Stablecoin pegged to the US dollar, offering market stability and widespread acceptance across major exchanges."
                                        : "The token baked into the main consensus protocol of the chain, accounting for the execution of all smart contracts.",
                                    ),
                                    TextSpan(
                                      text: " Learn more",
                                      style: const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        launch(widget.project.isUSDT
                                            ? "https://coinmarketcap.com/currencies/tether/"
                                            : "https://coinmarketcap.com/currencies/tezos/");
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                           ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
      // const Text("Link the project repository. The README.md file should contain a detailed description of the good or service you wish to acquire, to set expectations for your potential contractor.", textAlign: TextAlign.left, style: TextStyle(fontSize: 17.5),),
SizedBox(
  width:560,
  child:   RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
          
          children: <TextSpan>[
            const TextSpan(text: "Link the project repository. The README.md file should contain a detailed description of the good or service you wish to acquire, to set expectations for your potential contractor. "),
            const TextSpan(text: "For a smooth arbitration, it's recommended to clone and customize "),
            TextSpan(
              text: 'this template.',
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch('https://github.com/dOrgTech/template-project');
                },
  
            ),
  
          ],
  
        ),
  
      ),
),
  const SizedBox(height: 12),
       SizedBox(
                    width:550,
                    child: TextField(
                      controller: widget.repoControlla,
                      onChanged: (value) {
                        setState(() {
                        widget.project.repo=value;
                        });
                      },
                      style: const TextStyle(fontSize: 13),
                      decoration:  const InputDecoration(
                        labelText: "Link to your project reposiory",
                        ),),
                  ),
            const SizedBox(height: 30),
                  SizedBox(
        height: 70,
        child: Center(
          child: 
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                //  SizedBox(width: 20),
                  StepProgressIndicator(currentStep: 0),
                   SizedBox(
                          height: 40,
                          width: 170,
                          child: TextButton(
                            style: ButtonStyle(
                              // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                              // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                              elevation: MaterialStateProperty.all(1.0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                              ),
                            ),
                             onPressed: widget.project.name!.length>1
                              && 
                              widget.project.repo!.length>3
                              && 
                              widget.project.description!.length>3?
                            (){
                             setState(() {
                               widget.stage=1;
                             });
                            }:null,
                             child: const Center(
                            child: Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                          )),
                        ),
                 ],
               )
      
           
      ),
      
      
                    
        )])
      ),
    );
    }

  createauthorProject(project,state){print("create project");}
  Widget agentName() {
    return SizedBox(
          width:400,
          height: 90,
          child: TextField(
            onChanged: (value){widget.project.name=value;},
            controller: widget.nameControlla,
              maxLength: 30,
              style: const TextStyle(fontSize: 21),
              decoration: const InputDecoration(
    labelText: 'Set project name', // Use labelText instead of hintText
    border: OutlineInputBorder(), // Optional: Adds an outline border to the TextField
  ),
              
            ),
        );
  }
  Widget agentDescription() {
    return SizedBox(
      height: 110,
      width:530,
      child: TextField(
        onChanged: (value){
          setState(() {  
          widget.project.description=value;
          });
          },
        controller: widget.descriptionControlla,
              maxLength: 200,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Very short description of the project. Include specific technologies that will be used so they may show up if someone searches for them.',
              ),
              
            ),
    );
  }
  }