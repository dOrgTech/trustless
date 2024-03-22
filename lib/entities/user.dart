import 'package:trustless/entities/project.dart';
import 'package:trustless/widgets/usercard.dart';
import 'human.dart';

String workingHash ="0x71436760615bde646197979c0be8a86c1c6179cd17ae7492355e76ff79949bbc";

class User{
  
  User({required this.lastActive,  required this.address,required this.nativeEarned,
  required this.usdtEarned,required this.usdtSpent,required this.nativeSpent,required this.projectsContracted,
  required this.projectsArbitrated,required this.projectsBacked, 
  required this.projectsAuthored});
  List<TTransaction>actions=[];
  String address;
  int nativeEarned;
  int usdtEarned;
  int nativeSpent;
  int usdtSpent;
  String? name;
  List<String>projectsContracted;
  List<String>projectsArbitrated;
  List<String>projectsAuthored;
  List<String>projectsBacked;
  DateTime lastActive;
  UserCard getCard() {
    return UserCard(user: this);
  } 

  Map<String, dynamic> toJson() => {
        'nativeEarned': nativeEarned,
        'usdtEarned': usdtEarned,
        'nativeSpent': nativeSpent,
        'usdtSpent': usdtSpent,
        'name': name,
        'projectsContracted': projectsContracted,
        'projectsArbitrated': projectsArbitrated,
        'projectsAuthored': projectsAuthored,
        'projectsBacked': projectsBacked,
        'lastActive': lastActive,
      };
  }



List<String>possibleActions=["createProject", "setParties","sendFunds","sign","withdraw","voteToRelease","voteToDispute","arbitrate","reimburse"];

class TTransaction{
  TTransaction({
    required this.time,
    required this.sender,
    required this.functionName,
    required this.contractAddress,
    required this.params,
    required this.hash
  })
  {
    blockExplorerUrl= "https://${Human().chain.name}.etherscan.io/tx/${hash}";
  }
  String sender;
  String functionName;
  String contractAddress;
  String params;
  String hash;
  late String blockExplorerUrl;
  DateTime time;

  // Convert a TTransaction instance into a Map.
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'functionName': functionName,
      'contractAddress': contractAddress,
      'params': params,
      'time': time,
    };
  }

  // Create a TTransaction instance from a map (JSON).
  factory TTransaction.fromJson(Map<String, dynamic> json) {
    TTransaction transaction = TTransaction(
      time: DateTime.parse(json['time']),
      sender: json['sender'],
      functionName: json['functionName'],
      contractAddress: json['contractAddress'],
      params: json['params'],
      hash: json['hash'],
    );
    return transaction;
  }

}



