
import 'dart:math';

import 'package:trustless/utils/reusable.dart';

import '../entities/user.dart';

List<User>users=[];

createUsers(){
  for (int i = 0; i < 150; i++) {
    String address = generateWalletAddress();
  
      users.add(User(address: address, earned: Random().nextInt(15400).toString(),
       spent: Random().nextInt(15400).toString(), 
       projectsContracted: [], projectsArbitrated: [], projectsBacked: []));
    }
}


