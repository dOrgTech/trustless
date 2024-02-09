import 'package:trustless/widgets/usercard.dart';

class User{
  User({required this.address,required this.earned,
  required this.spent,required this.projectsContracted,
  required this.projectsArbitrated,required this.projectsBacked});

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