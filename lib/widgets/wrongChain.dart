import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/human.dart';

class WrongChain extends StatelessWidget {
  const WrongChain({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget>lanturi=[];
    // ignore: unused_local_variable
    for (Chain c in chains.values){
      lanturi.add(network(c, context));
      lanturi.add(SizedBox(height: 4));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Chain not supported.",style: GoogleFonts.jura(fontSize: 36)),
          const SizedBox(height: 60),
          Text("Switch your wallet to one of these networks:"),
            SizedBox(height: 20),
            Row(children: [SizedBox(width: 80)],),
            ...lanturi

      ]),),
    );
  }
  network(Chain chain, context){
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(width: 0.1 , color: Theme.of(context).indicatorColor ),
            color: Theme.of(context).dividerColor.withOpacity(0.1)
        ),
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(chain.name, style: GoogleFonts.jura(fontSize: 20),),
          SizedBox(width: 34),
          Text("ChainID: ${chain.id}")
        ],
      ),
    );
  }
}