

import 'dart:convert';
import 'dart:js_util';
import 'package:flutter_web3_provider/ethereum.dart';
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
var abi=
'''
 [ {
    "constant": true,
    "inputs": [
      {
        "name": "_owner",
        "type": "address"
      }
    ],
    "name": "balanceOf",
    "outputs": [
      {
        "name": "balance",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }]'''
;



class Human {  
  String? address;
  bool metamask=true;
    bool allowed=false;
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
  await Future.delayed(const Duration(seconds: 1)).then((value) {
  address="qodjn09djqwod9ijqnw9jdowijndpoqijwnp";


  print("HJumna"+Human().address!);
  for (Voter v in voters){
    print("voted "+v.address);

    if (v.address.toLowerCase()==address!.toLowerCase() &&v.voted==false ){
      print("found adddress");
    allowed=true;
    voteCollection.doc(v.address).set({
      "name":v.name,
      "voted":true});
       break;
    }
   
    }

  });
  
  }

}



