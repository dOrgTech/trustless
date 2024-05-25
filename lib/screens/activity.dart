import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trustless/widgets/action.dart';

class AllActivity extends StatefulWidget {
  const AllActivity({super.key});

  @override
  State<AllActivity> createState() => _AllActivityState();
}

class _AllActivityState extends State<AllActivity> {
  @override
  Widget build(BuildContext context) {
    return Container(
       alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height-65,
          child: ListView(
            children:[ActivityFeed()],
          )
    );
  }
}