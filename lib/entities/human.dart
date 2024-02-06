

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

var chains=[
  Chain(name: "Goerli", rpcNode: "https://goerli.infura.io/v3/1081d644fc4144b587a4f762846ceede", fbCollection: "projectsGoerli"),
  Chain(name: "Etherlink-Testnet", rpcNode: "https://node.ghostnet.etherlink.com", fbCollection: "projectsEtherlinkTestnet"),
  Chain(name: "Etherlink", rpcNode: "", fbCollection: "projectsEtherlink"),
  Chain(name: "Tezos", rpcNode: "", fbCollection: "projectsTezosMainnet"),
];


class Human {
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
  // web3user= Web3Provider(ethereum!);
  address="0x75912a4c8D0F1593347D9729006c89d00EF492b0";
  
  }

}

class Chain{
  Chain({required this.name, required this.rpcNode, required this.fbCollection});
  String name;
  String rpcNode;
  var fbCollection;
}
