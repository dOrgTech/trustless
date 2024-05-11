import 'dart:math';

import 'package:trustless/entities/token.dart';



class Project{
  bool isUSDT=false;
  String? contractAddress;
  String? name;
  DateTime? creationDate;
  DateTime? expiresAt;
  String? description;
  String? author;
  String? arbiter="";
  String? contractor="";
  String? hashedFileName="";
  String rulingHash="";
  String? termsHash="";
  String? repo="";
  String? requirements;
  String holding="0";
  String releasing="0";
  String disputing="0";
  String? status;
  String? arbiterAwardingContractor;
  Map<String,String>contributions={};
  Map<String,String>contributorsReleasing={};
  Map<String,String>contributorsDisputing={};
  List<Token>? acceptedTokens;
  // Constructor with logic
  Project({required this.isUSDT,this.contractAddress, this.contractor,this.name,  this.creationDate, this.description,this.author, this.arbiter, this.requirements, this.status, this.repo}){

    releasing = contributorsReleasing.values.fold(
      BigInt.zero, (a, b) => BigInt.parse(a as String) + BigInt.parse(b)
      ).toString();

    disputing = contributorsDisputing.values.fold(
      BigInt.zero, (a, b) => BigInt.parse(a as String) + BigInt.parse(b)
      ).toString();
    creationDate=this.creationDate??DateTime.now();
    expiresAt=creationDate!.add(Duration(days: 30));
    acceptedTokens=[
      Token(address: "---", name: "Native", symbol: "XTZ", decimals: 5),
      Token(address: "KT1MzN5jLkbbq9P6WEFmTffUrYtK8niZavzH", name: "Tether", symbol: "USDT", decimals: 5),
    ];
  }

  // The constructor that takes a JSON string and parses it into an object
fromJson(Map<String, dynamic> json) {
  isUSDT = json['isUSDT'];
  name = json['name'];
  contractor = json['contractor'];
  creationDate = DateTime.parse(json['created']);
  description = json['description'];
  hashedFileName = json['hashedFileName'];
  repo = json['repo'];
  termsHash = json['termsHash'];
  status = json['status'];
  author = json['author'];
  holding=json['holding'];
  contributions = json['contributions'];
  arbiterAwardingContractor = json['arbiterAwardingContractor'];
  rulingHash = json['rulingHash'];
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
    buffer.write('Client: $author\n');
    buffer.write('Arbiter: $arbiter\n');
    buffer.write('Terms Hash: $termsHash\n');
    buffer.write('Requirements: $requirements\n');
    buffer.write('Holding: $holding\n');
    buffer.write('Status: $status\n');
    buffer.write('Accepted tokens: ');
    buffer.toString().substring(0, buffer.length - 2);
    // return the string
    return buffer.toString();
  }

  toJson(){
    return {
      'isUSDT':isUSDT,
      'name':name,
      'holding':holding,
      'contractor':contractor,
      'created':creationDate,
      'description':description,
      'hashedFileName':hashedFileName,
      'repo':repo,
      'termsHash':termsHash,
      'status':status,
      'arbiter':arbiter,
      'author':author,
      'contributions':contributions,
      'rulingHash':rulingHash,
      'contributorsReleasing':contributorsReleasing,
      'contributorsDisputing':contributorsDisputing,
      'arbiterAwardingContractor':arbiterAwardingContractor
    };
  }
}



