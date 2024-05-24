import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import 'package:trustless/widgets/somethingsWrong.dart';
import 'package:trustless/widgets/waiting.dart';
import '../entities/org.dart';
import '../entities/project.dart';
import '../entities/token.dart';
import 'dart:math';

import '../entities/user.dart';
const String escape = '\uE00C';
class SendFunds extends StatefulWidget {
  bool loading = false;
  bool done = false;
  bool error = false;
  Project project;
  int stage=0;
// ignore: use_key_in_widget_constructors
  SendFunds({required this.project});
  @override
  SendFundsState createState() => SendFundsState();
}
int pmttoken = 0;
class SendFundsState extends State<SendFunds> {
  String? selectedToken;
  String? selectedAddress;
  TextEditingController amountController = TextEditingController();
  String amount = "";
  String token=Human().chain.nativeSymbol;
  @override
  Widget build(BuildContext context) {
      main(){
        switch (widget.stage) {
          case 0:
            return stage0();
          case 1:
            return SizedBox( height:500, child: WaitingOnChain());
          case 2:
            return SomethingWentWrong(project:widget.project);
          default:
            return stage0();
        }
      }
   if (widget.project.isUSDT){token="USDC";}
    return   MediaQuery(
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
            main() as Widget,
          ),
        ),
      ),
    ),
  ));
  }
Widget stage0(){
  return  Container(
        width: 650,
        // width: MediaQuery.of(context).size.width*0.7,
        height: 650,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           const  SizedBox(height: 30),
            const Text(
              "Fund Project",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19),
            ),
             const SizedBox(height:200),
            //  const Text("Your contribution will be stored in the contract.")
              SizedBox(
                width: 200,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: (value) {
                    double calculation = double.parse(value) ;
                    amount = calculation.toString();
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter ${token} amount',
                  ),
                ),
              ),
           const SizedBox(height: 160),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child:  Row(
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
                    height: 40,
                    width: 130,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                         onPressed: () async {
                          setState(() { widget.stage=1; Human().busy=true;});
                           String cevine = await cf.sendFunds(widget.project,amount);
                           print("dupa cevine");
                          if (cevine.contains("nu merge")){
                              print("nu merge din setParty");
                              setState(() { widget.stage=2;});
                              widget.stage=0;
                              return;
                            }
                          bool storeUser=false;
                          
                          if ( widget.project.contributions.containsKey(Human().address!)) {
                                widget.project.contributions[Human().address!] = (BigInt.parse(widget.project.contributions[Human().address!]!) 
                                + 
                               cf.ethToWei(double.parse(amount))
                                ).toString();
                              } else {
                                widget.project.contributions[Human().address!] =cf.ethToWei(double.parse(amount)).toString();
                              }
                          
                          if (!Human().user!.projectsBacked.contains(widget.project.contractAddress)) {
                                Human().user!.projectsBacked.add(widget.project.contractAddress!); 
                                storeUser=true;
                          }
                         
                          if (!users.any((user) => user.address.toLowerCase()==Human().address!.toLowerCase())){
                            users.add(Human().user!);
                            storeUser=true;
                          }

                          if (storeUser){
                            await usersCollection.doc(Human().address).set(Human().user!.toJson());
                          }
                         String newBalance =  await cf.getNativeBalance(widget.project.contractAddress!);
                         widget.project.holding=newBalance;
                         projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                         Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");

                        },
                        child: Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
           const  SizedBox(height: 30),
              ],),
        );
}
}
