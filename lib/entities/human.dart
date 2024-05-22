import 'dart:convert';
import 'dart:js';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:http/http.dart';
import 'package:trustless/entities/user.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/chat.dart';
import 'package:web3dart/web3dart.dart';
import '../main.dart';
//https://docs.google.com/spreadsheets/d/1hHE1HXEXXr3Abmj47CUogAJKmsqSKNqqPGS-BeI9IEo/edit#gid=0
//

String prevChain="0x1f47b";
var chains={
 "0x5": Chain(id:5, name: "Goerli", nativeSymbol: "XTZ", decimals:18, rpcNode: "https://goerli.infura.io/v3/1081d644fc4144b587a4f762846ceede"),
 "0xaa36a7": Chain(id:11155111, name: "Sepolia", nativeSymbol: "sETH", decimals:18, rpcNode: "https://sepolia.infura.io/v3/1081d644fc4144b587a4f762846ceede"),
//  "0x1f47b": Chain(id:128123, name: "Etherlink-Testnet", nativeSymbol: "XTZ", decimals:0, rpcNode: "https://node.ghostnet.etherlink.com", ),
 "0x1f47b": Chain(id:128123, name: "Etherlink-Testnet", nativeSymbol: "XTZ", decimals:18, rpcNode: "https://rpc.etherlink-testnet.tz.soap.coffee", ),
};

class Human extends ChangeNotifier{
   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
     GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

 void refreshPage() {
  print("refreshing the page");
    _navigatorKey.currentState?.pushNamed("/");
  }
  bool busy=false;
  bool beta=false;
  bool wrongChain=false;
  String session_id=generateWalletAddress();
  int chainID=5;
  String chainNativeEarnings="0";
  String chainUSDTEarnings="0";
  String? address;
  Chain chain=chains[prevChain]!;
  bool metamask=true;
  bool allowed=false;
  Web3Provider? web3user;
  bool voting=false;
  bool isOverlayVisible = false;
  bool voted=false;
  User? user;
  List<ChatItem> chatHistory=[
    ChatItem(isSender: false, 
    message: "If you have questions about the platform, ask them here. I'm not human but I'll do my best.",
    ),
 
  ];
  Human._internal(){
    _setupListeners();
  }

  // Singleton instancelogo
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
          getUser();
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
           persist().then((value){
            print("users length ${users.length}");
            // navigatorKey.currentState!.pushNamed("/");
            refreshPage();
            print("something");
           });
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
          if (! (chain==chains[prevChain])){
            await persist();
            refreshPage();}
          }
      web3user = Web3Provider(ethereum!);
      // address="0xa9f8f9c0bf3188ceddb9684ae28655187552bae9";
      getUser();
      notifyListeners(); // Notify listeners that signIn was successful
      return "ok";
    } catch (e) {
      print(e);
      return "nogo";
    }
  }

  getUser(){
    print("getting user");
     User us3r;
     for (User u in users){
        if (u.address.toLowerCase()==address!.toLowerCase()){
          print("found user");
          user=u;
          return;
        }}
        print("this is a new user");
        user = User(
        lastActive: DateTime.now(), 
        address: address!, 
        nativeEarned: "0", 
        usdtEarned: "0", 
        usdtSpent: "0",
        nativeSpent: "0",
        projectsContracted: [],
        projectsArbitrated: [],
        projectsBacked:[],
        projectsAuthored: []);
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


class ChatItem{
  ChatItem({required this.isSender, required this.message});
  bool isSender;
  String message;
  
}