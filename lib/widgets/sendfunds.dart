import 'dart:isolate';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/main.dart';
import '../entities/org.dart';
import '../entities/project.dart';
import '../entities/token.dart';

const String escape = '\uE00C';

class SendFunds extends StatefulWidget {
  bool loading = false;
  bool done = false;
  bool error = false;
  Project project;

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
  String token="XTZ";
  @override
  Widget build(BuildContext context) {
   if (widget.project.isUSDT){token="USDC";}
    return Container(
        width: 650,
        padding: const EdgeInsets.symmetric(horizontal: 60),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).highlightColor,
            width: 0.3,
          ),
        ),
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
                    amount = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter ${token} amount',
                  ),
                ),
              ),
      SizedBox(height: 160),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SizedBox(
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
                      if ( widget.project.contributions.containsKey(Human().address!)) {
                            widget.project.contributions[Human().address!] = widget.project.contributions[Human().address!]! + int.parse(amount);
                          } else {
                            widget.project.contributions[Human().address!] = int.parse(amount);
                          }
                     projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                     Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");

                    },
                    child:  Center(
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
            ),
           const  SizedBox(height: 30),
              ],),
            
        );
  }

var humans=[];
String selectedCapacity = 'Individual';
Widget capacity() {
List<String> capacities = ['Individual'];
for (Token token in humans[1].balances!.keys) {
  capacities.add(token.name);
  print("added token " + token.name);
}
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Act as: ",
      ),
      DropdownButton<String>(
        value: selectedCapacity,
        onChanged: (value) {
          setState(() {
            selectedCapacity = value!;
          });
        },
        items: capacities.map((String capacity) {
          return DropdownMenuItem<String>(
            value: capacity,
            child: Text(capacity,
              style: TextStyle(
                color: capacity == 'Individual' ? Theme.of(context).indicatorColor : null,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}
}
