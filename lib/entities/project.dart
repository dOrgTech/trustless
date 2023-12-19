import 'dart:math';

import 'package:trustless/entities/token.dart';



class Project{
  bool isUSDT=false;
  String? contractAddress;
  String? name;
  DateTime? creationDate;
  DateTime? expiresAt;
  String? description;
  String? client;
  String? arbiter="";
  String contractor="";
  String? hashedFileName="";
  String? termsHash;
  String? repo="";
  String? requirements;
  double? amountInEscrow;
  String? status;
  Map<String,int>contributions={};
  List<Token>? acceptedTokens;
  // Constructor with logic
  Project({required this.isUSDT, this.name,  this.creationDate, this.description,this.client, this.arbiter, this.requirements, this.status, this.repo}){
    int random = Random().nextInt(331) + 90;
    amountInEscrow = random * 100;
    creationDate=DateTime.now();
    expiresAt=creationDate!.add(Duration(days: 30));
    acceptedTokens=[
      Token(address: "---", name: "Native", symbol: "XTZ", decimals: 5),
      Token(address: "KT1MzN5jLkbbq9P6WEFmTffUrYtK8niZavzH", name: "Tether", symbol: "USDT", decimals: 5),
      
    ];
  }
  @override
  String toString() {
    // use a StringBuffer to efficiently build the string
    var buffer = StringBuffer();
    // use string interpolation to append the fields
    buffer.write('Name: $name\n');
    buffer.write('Creation date: $creationDate\n');
    buffer.write('Expires at: $expiresAt\n');
    buffer.write('Description: $description\n');
    buffer.write('Client: $client\n');
    buffer.write('Arbiter: $arbiter\n');
    buffer.write('Terms Hash: $termsHash\n');
    buffer.write('Requirements: $requirements\n');
    buffer.write('Amount in escrow: $amountInEscrow\n');
    buffer.write('Status: $status\n');
    // use a loop to append the accepted tokens
    buffer.write('Accepted tokens: ');
   
    // remove the trailing comma and space
    buffer.toString().substring(0, buffer.length - 2);
    // return the string
    return buffer.toString();
  }
  toJson(){
    return {
      'isUSDT':isUSDT,
      'name':name,
      'contractor':contractor,
      'created':DateTime.now(),
      'description':description,
      'hashedFileName':hashedFileName,
      'repo':repo,
      'termsHash':termsHash,
      'status':"open",
      'author':"client",
      'client':client
    };
  }
    
}



