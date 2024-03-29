

import 'dart:convert';
import 'dart:js';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../main.dart';
//https://docs.google.com/spreadsheets/d/1hHE1HXEXXr3Abmj47CUogAJKmsqSKNqqPGS-BeI9IEo/edit#gid=0
//



var chains={
 "0x5": Chain(id:5, name: "Goerli", nativeSymbol: "WEI", decimals:0, rpcNode: "https://goerli.infura.io/v3/1081d644fc4144b587a4f762846ceede"),
//  "0xaa36a7": Chain(id:11155111, name: "Sepolia", nativeSymbol: "WEI", decimals:0, rpcNode: "https://sepolia.infura.io/v3/1081d644fc4144b587a4f762846ceede"),
//  "0x1f47b": Chain(id:128123, name: "Etherlink-Testnet", nativeSymbol: "XTZ", decimals:18, rpcNode: "https://node.ghostnet.etherlink.com", ),
};


class Human extends ChangeNotifier{
  bool busy=false;
  bool beta=false;
  bool wrongChain=false;
  int chainID=5;
  String? address;
  Chain chain=chains["0x5"]!;
  bool metamask=true;
  bool allowed=false;
  Web3Provider? web3user;
  bool voting=false;
  bool voted=false;
  Human._internal(){
    _setupListeners();
  }
  // Singleton instance
  static final Human _instance = Human._internal();
  // Factory constructor to return the singleton instance
  factory Human() {
    return _instance;
  }
 


  void _setupListeners() {
    // Ensure Ethereum is available
    if (ethereum != null) {
      // Listen for account changes
      ethereum!.on('accountsChanged', allowInterop((accounts) {
        if (accounts.isEmpty) {
          // Handle wallet disconnection
          print("Wallet disconnected");
          address = null;
        } else {
          // Handle account change
          address = ethereum!.selectedAddress.toString();
          print("Account changed: $address");
        }
        notifyListeners(); // Notify listeners about the change
      }));

      // Listen for chain changes
      ethereum!.on('chainChanged', allowInterop((chainId) {
        print("Chain changed: $chainId");
        if (!chains.keys.contains(chainId)){
          print("schimbam la nimic");
          wrongChain=true;
          chain=Chain(id: 0, name: 'N/A', nativeSymbol: '', decimals: 0, rpcNode: '');
          
          notifyListeners();
          return "nogo";
        }else{
          wrongChain=false;
          chain=chains[chainId]!;
          }
        
        // Optionally update the chain information here
        notifyListeners(); // Notify listeners about the change
      }));
    }
  }


  signIn()async{    
   try {
      var accounts = await promiseToFuture(
        ethereum!.request(
          RequestParams(method: 'eth_requestAccounts'),
        ),
      );
      address = ethereum?.selectedAddress.toString();
      var chainaidi = ethereum?.chainId;
      if (!chains.keys.contains(chainaidi)){
          print("schimbam la nimic");
          wrongChain=true;
          chain=Chain(id: 0, name: 'N/A', nativeSymbol: '', decimals: 0, rpcNode: '');
          
          notifyListeners();
          return "nogo";
        }else{
          wrongChain=false;
          chain=chains[chainaidi]!;
          }
      web3user = Web3Provider(ethereum!);
      notifyListeners(); // Notify listeners that signIn was successful
      return "ok";
    } catch (e) {
      print(e);
      return "nogo";
    }
  
  }

}

class Chain{
  Chain({required this.id, required this.name, required this.nativeSymbol, required this.decimals, required this.rpcNode});
  int id;
  String name;
  int decimals;
  String nativeSymbol;
  String rpcNode;
  var fbCollection;
}
