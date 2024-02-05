

import 'dart:convert';
import 'dart:js_util';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../main.dart';


class Voter{
  Voter({required this.name, required this.voted, required this.address});
  String name;
  bool voted;

  String address;
}


var orgs=[];




class Human {  
  String? address;
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

  
  }

}



