import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trustless/screens/prelaunch.dart';
import '../entities/user.dart';
Map<String, TextStyle> actionStyles = {
  "createProject": GoogleFonts.spaceMono(fontSize: 14, ),
  "setParties": GoogleFonts.spaceMono(fontSize: 14,fontWeight:FontWeight.w500),
  "fundProject": GoogleFonts.robotoMono(fontWeight: FontWeight.w500),
  "withdraw": GoogleFonts.ubuntuMono(fontWeight: FontWeight.w200),
  "voteToRelease": GoogleFonts.b612Mono(fontWeight: FontWeight.w600),
  "voteToDispute": GoogleFonts.b612Mono(fontWeight: FontWeight.w700),
  "arbitrate": GoogleFonts.b612Mono(fontWeight: FontWeight.w400),
  "reimburse": GoogleFonts.b612Mono(fontWeight: FontWeight.w400),
};
Map<String, Icon> actionIcons = {
  "createProject": Icon(Icons.create_new_folder,size: 13,),
  "setParties": Icon(Icons.group_add,size: 13),
  "fundProject": Icon(Icons.account_balance_wallet,size: 13),
  "withdraw": Icon(Icons.money_off,size: 13),
  "voteToRelease": Icon(Icons.how_to_vote,size: 13),
  "voteToDispute": Icon(Icons.gavel,size: 13),
  "arbitrate": Icon(Icons.balance,size: 13),
  "reimburse": Icon(Icons.refresh,size: 13),
};


Map<String, Color> actionColors = {
  "createProject": Colors.blue,
  "setParties": Colors.green,
  "fundProject": Colors.orange,
  "withdraw": Colors.red,
  "voteToRelease": Color.fromARGB(255, 167, 176, 39),
  "voteToDispute": Colors.amber,
  "arbitrate": Colors.teal,
  "reimburse": Color.fromARGB(255, 161, 63, 181),
};
class ActionItem extends StatelessWidget {
  final  action;

  ActionItem({required this.action});

  @override
  Widget build(BuildContext context) {
     // Retrieve the action's base color from the mapping
    Color baseColor = actionColors[action.name] ?? Colors.grey; // Default color if action not found
    // Blend the base color with the theme's canvasColor
    Color blendedColor = Color.alphaBlend(baseColor.withOpacity(0.2), Theme.of(context).textTheme.bodySmall!.color!);
    Color blendedColor1 = Color.alphaBlend(baseColor.withOpacity(0.08), Theme.of(context).textTheme.bodySmall!.color!);
    // return Text(action.name);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Color.fromARGB(12, 0, 0, 0),
      // decoration: BoxDecoration(),
      padding: EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:18.0),
        child: Row(
          children: [
            
            Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.transparent, // Use the blended color as the background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(actionIcons[action.name]?.icon, color: blendedColor), // Use the base color for the icon
          SizedBox(width: 12),
          Text(
            action.name,
            style: TextStyle(color: blendedColor1), // Use the base color for text as well
          ),
          // Add more widgets as needed
        ],
      ),
    ),
            SizedBox(
              width: 200,
              child: Text(action.contract,),
            ),
            SizedBox(
              width: 200,
              child: Text(action.params,), 
            ),
            SizedBox(
              width: 200,
              child: Text(action.hash,),
            ),
          ],
        ),
      ),
    );
  }
}



class ActivityFeed extends StatefulWidget {
  final List<User> users;

  ActivityFeed({required this.users});

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  List<User> displayedUsers = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (displayedUsers.length < widget.users.length) {
        setState(() {
          displayedUsers.add(widget.users[displayedUsers.length]);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          itemCount: displayedUsers.length,
          itemBuilder: (context, index) {
            return ActionItem(action: displayedUsers[index].actions.first); // Assuming you want to display the first action for simplicity.
          },
        ),
      ),
    );
  }
}
