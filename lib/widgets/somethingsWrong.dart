import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../entities/project.dart';

class SomethingWentWrong extends StatelessWidget {
  Project project;
   List <String> memes=[
     "https://i.ibb.co/wCq1MZq/image.png",
      "https://i.imgflip.com/3811ub.jpg?a473712",
      "https://media.makeameme.org/created/oops-something-went-5d2365e3cb.jpg",
      "https://media.makeameme.org/created/oops-something-went-bbf91c282f.jpg",
      "https://i.ibb.co/jGg1DZ1/transaction-error1.png",
      "https://i.ibb.co/c2vLbQ3/transaction-error2.png"
   ];
  SomethingWentWrong({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
     Random random = Random();
    return  Container(
      height: 590,
      width: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(memes[random.nextInt(memes.length) ], height: 400,),
            const SizedBox(height:25),
            const Text("The transaction failed. Debug info can be found in the app's dev console or in the block explorer."),
            const SizedBox(height:35),
            ElevatedButton(onPressed: (){
             Navigator.of(context).pop();
            }, child: Text("OK"))
           
          ],
        ),
      )
    );
  }
}