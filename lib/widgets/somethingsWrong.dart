import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SomethingWentWrong extends StatelessWidget {
   List <String> memes=[
    "https://lh3.googleusercontent.com/proxy/fL5LN9RijNtoXik5kkrjSmQEI996WSbUwBq_qm11l9CE3Rm_WXRWxxB7Pzla5_xmDe4-1CDJoHjfLP_d0KFlBLjUU6o7hGZ6XVu_5TxNEfFdHjRPsK3r8hhjfS5Y-RRO_CEvmxihgLx9qN2K2WSJgdTlyG4BTdKVqWQ",
      "https://i.imgflip.com/3811ub.jpg?a473712",
      "https://media.makeameme.org/created/oops-something-went-5d2365e3cb.jpg",
      "https://media.makeameme.org/created/oops-something-went-bbf91c282f.jpg"
   ];
  SomethingWentWrong({super.key});

  @override
  Widget build(BuildContext context) {
     Random random = Random();
    return  Container(
      height: 300,
      child: Image.network(memes[random.nextInt(memes.length)])
    );
  }
}