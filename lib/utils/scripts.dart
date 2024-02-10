
import 'dart:math';

import 'package:trustless/utils/reusable.dart';

import '../entities/user.dart';

List<User>users=[];

createUsers(){
  for (int i = 0; i < 150; i++) {
    String address = generateWalletAddress();
      User user=User(address: address, earned: Random().nextInt(15400).toString(),
       spent: Random().nextInt(15400).toString(), 
       projectsContracted: [], projectsArbitrated: [], projectsBacked: []);
      user.actions.add(Action(user: user, name: possibleActions[Random().nextInt(possibleActions.length)] , 
      contract: generateContractAddress(), params: "{}", hash: hashString("j320d8j9f38efjsaidd09j0d9qw")));
      users.add(user);
    }
}


