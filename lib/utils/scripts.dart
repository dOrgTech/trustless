import 'dart:math';
import 'package:trustless/utils/reusable.dart';
import '../entities/project.dart';
import '../entities/user.dart';
import '../main.dart';

List<User>users=[];
List<TTransaction> mockTansactions=[];


createUsers(){
  for (int i = 0; i < 20; i++) {
    String address = generateWalletAddress();
      User user=User(address: address, earned: Random().nextInt(15400).toString(),
       spent: Random().nextInt(15400).toString(), 
       projectsContracted: [], projectsArbitrated: [], projectsBacked: []);
      users.add(user);

    TTransaction t= TTransaction(
      time: DateTime.now().subtract(Duration(hours: 1+ (Random().nextInt(15)))), 
      sender: users[i].address, 
      functionName: possibleActions[Random().nextInt(possibleActions.length)], 
      contractAddress: projects[Random().nextInt(projects.length)].contractAddress!, 
      params: "{value:0000000000000000000}", 
      hash: workingHash);
    mockTansactions.add(t);

    }
}

buildUsers(){
  for (Project p in projects){

  }

}




