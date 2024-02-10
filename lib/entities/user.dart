import 'package:trustless/widgets/usercard.dart';

class User{
  User({required this.address,required this.earned,
  required this.spent,required this.projectsContracted,
  required this.projectsArbitrated,required this.projectsBacked});
  List<Action>actions=[];
  String address;
  String earned;
  String spent;
  List<String>projectsContracted;
  List<String>projectsArbitrated;
  List<String>projectsBacked;

   UserCard getCard() {
    return UserCard(user: this);
  } 

}

List<String>possibleActions=["createProject", "setParties","fundProject","withdraw","voteToRelease","voteToDispute","arbitrate","reimburse"];


class Action{
  Action({required this.user,required this.name,required this.contract,required this.params, required this.hash});
  User user;
  String name;
  String contract;
  String params;
  String hash;
}



