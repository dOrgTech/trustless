

import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../main.dart';
//https://docs.google.com/spreadsheets/d/1hHE1HXEXXr3Abmj47CUogAJKmsqSKNqqPGS-BeI9IEo/edit#gid=0
//



var chains=[
  Chain(name: "Goerli", nativeSymbol: "WEI", decimals:0, rpcNode: "https://goerli.infura.io/v3/1081d644fc4144b587a4f762846ceede"),
  Chain(name: "Etherlink-Testnet", nativeSymbol: "XTZ", decimals:18, rpcNode: "https://node.ghostnet.etherlink.com", ),
  Chain(name: "Etherlink", rpcNode: "", nativeSymbol: "XTZ", decimals:18,),
  Chain(name: "Tezos", rpcNode: "", nativeSymbol: "XTZ", decimals:18,),
];


class Human extends ChangeNotifier{
  bool busy=false;
  String? address;
  Chain chain=chains[0];
  bool metamask=true;
  bool allowed=false;
  Web3Provider? web3user;
  bool voting=false;
  bool voted=false;
  Human._internal();
  // Singleton instance
  static final Human _instance = Human._internal();
  // Factory constructor to return the singleton instance
  factory Human() {
    return _instance;
  }
  signIn()async{    
    try{
       var cevine= await promiseToFuture(
      ethereum!.request(
          RequestParams(method: 'eth_requestAccounts'),
        ),
      );
   }
   catch(e){
      print(e);
      return "nogo";
   }
  address=ethereum?.selectedAddress.toString();
  web3user= Web3Provider(ethereum!);
  // address="0x75912a4c8D0F1593347D9729006c89d00EF492b0";
  
  }

}

class Chain{
  Chain({required this.name, required this.nativeSymbol, required this.decimals, required this.rpcNode});
  String name;
  int decimals;
  String nativeSymbol;
  String rpcNode;
  var fbCollection;
}
