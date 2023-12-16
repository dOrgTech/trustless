
import 'dart:js_util';
import 'dart:math';
import 'package:trustless/entities/token.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import '../main.dart';
import 'org.dart';

var orgs=[];


class Human {  
  String? address;
  
  bool metamask=true;
  Human._internal();
  // Singleton instance
  static final Human _instance = Human._internal();
  // Factory constructor to return the singleton instance
  factory Human() {
    return _instance;
  }
  signIn()async{
    
  //   try{
  //      var cevine= await promiseToFuture(
  //     ethereum!.request(
  //         RequestParams(method: 'eth_requestAccounts'),
  //       ),
  //     );
  //  }
  //  catch(e){
  //     print(e);
  //     return "nogo";
  //  }
  // address=ethereum?.selectedAddress.toString();
  Future.delayed(Duration(seconds: 1));
  address="TZ122pd87ahiufh3piuf";
  
  }

}
