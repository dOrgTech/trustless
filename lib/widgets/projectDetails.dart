import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/entities/user.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/action.dart';
import 'package:trustless/widgets/arbitrate.dart';
import 'package:trustless/widgets/dispute.dart';
import 'package:trustless/widgets/footer.dart';
import 'package:trustless/widgets/projectCard.dart';
import 'package:trustless/widgets/proposalDetails.dart';
import 'package:trustless/widgets/reclaimFee.dart';
import 'package:trustless/widgets/reimburse.dart';
import 'package:trustless/widgets/release.dart';
import 'package:trustless/widgets/sendfunds.dart';
import 'package:trustless/widgets/setParty.dart';
import 'package:intl/intl.dart';
import 'package:trustless/widgets/sign.dart';
import 'package:trustless/widgets/updateSpendings.dart';
import 'package:trustless/widgets/usercard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import '../entities/project.dart';
import '../main.dart';
import '../widgets/withdraw.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

import 'coolOff.dart';

class ProjectDetails extends StatefulWidget {
  ProjectDetails({super.key, required this.project});
  Project project;
  bool cooling=false;
  bool refreshingBalance=false;
  Duration? remainingTime;
  List<Widget> projectActivity=[];
  @override
  State<ProjectDetails> createState() => ProjectDetailsState();
}

class ProjectDetailsState extends State<ProjectDetails> {
  
  MarkdownStyleSheet getMarkdownStyleSheet(BuildContext context) {
  return MarkdownStyleSheet.fromCupertinoTheme(
    CupertinoThemeData(
      brightness: Theme.of(context).brightness,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontSize: Theme.of(context).textTheme.bodyText1?.fontSize ?? 20,
        ),
      ),
    ),
  );
}

String extractGitHubPath(String? repoUrl) {
  if (repoUrl == null) {
    return 'default/fallback/path'; // Provide a default path or handle as needed
  }
  // Check if the URL contains "github.com/"
  int startIndex = repoUrl.indexOf('github.com/');
  if (startIndex == -1) {
    return 'default/fallback/path'; // Provide a default path or handle as needed
  }
  // Extract the part after "github.com/"
  String path = repoUrl.substring(startIndex + 'github.com/'.length);
    return path.isEmpty ? 'default/fallback/path' : path; // Ensure the path is not empty
  }

  Widget profileButton(Widget what, User user){
    return TextButton(onPressed: (){
      showDialog(context: context, builder: 
      (context)=>AlertDialog(
        content: Container(
          height: 700,width: 640,
          padding:EdgeInsets.only(top:20,right:10, bottom:10), child: 
          UserDetails(human: user)
        ,)
      )
      );
    }, child: what);
  }

  @override
  Widget build(BuildContext context) {
   if (widget.project.status=="pending") {
  final filteredTransactions = actions.where(
  (transaction) =>
    (transaction.functionName == 'setParties' ||
     transaction.functionName == 'createProject') &&
    transaction.contractAddress == widget.project.contractAddress,
  ).toList();
    filteredTransactions.sort((a, b) => b.time.compareTo(a.time));
    print("filtered transactions ${filteredTransactions}");
    final latestSetPartiesTransaction = filteredTransactions.first;
    print("latest ${latestSetPartiesTransaction}");
    Duration elapsed=DateTime.now().difference(latestSetPartiesTransaction.time);
    widget.remainingTime=Duration(minutes: 5) - elapsed;
    print("remaining time ${widget.remainingTime}");
    if ( widget.remainingTime!.inMinutes>0){
      setState(() {
        widget.cooling=true;
      });
    }else{
      setState(() {
        widget.cooling=false;
      });
    }
   } 

    List<Widget> openProjectFunctions = [
      functionItem("Send Funds to Project", "Anyone", SendFunds(project: widget.project)),
      functionItem("Set Parties", "Author", SetParty(project: widget.project)),
      functionItem("Withdraw", "Backers", Withdraw(project: widget.project)),
    ];
    
    List<Widget> ongoingProjectFunctions = [
      functionItem("Dispute Project", "Contractor or Backers", Dispute(project: widget.project)),
      functionItem("Release Funds to Contractor", "Backers", Release(project: widget.project)),
      functionItem("Reinburse Backers", "Contractor`", Reimburse(project: widget.project)),
    ];

    List<Widget> disputedProjectFunctions = [
      // const Text("Implementing... ", style: TextStyle(fontSize: 25),),
      functionItem("Arbitrate", "Arbiter", Arbitrate(project: widget.project)),
    ];

    List<Widget> closedProjectFunctions = [
      functionItem("Withdraw as Backer", "Backers", Withdraw(project: widget.project)),
      functionItem("Withdraw as Contractor", "Contractor", WidthdrawAsContractor(project: widget.project)),
      widget.project.arbiterAwardingContractor==null?
      functionItem("Reclaim Arbitration Fee", "Contractor and/or Author", ReclaimFee(project: widget.project)):Text(""),
      functionItem("Update Spendings", "Backers", UpdateSpendings(project: widget.project)),
    ];

    List<Widget> pendingProjectFunctions = [
      functionItem("Send Funds to Project", "Anyone", SendFunds(project: widget.project)),
      functionItem("Withdraw", "Backers", Withdraw(project: widget.project)),
      functionItem("Change Parties", "Author", SetParty(project: widget.project)),
      widget.cooling?
      Container(
        margin:const EdgeInsets.all(1),
        width: 410,
        height: 146,
        decoration: BoxDecoration(
            color: const Color.fromARGB(46, 37, 37, 37),
            borderRadius:const BorderRadius.all(Radius.circular(3.0)),
            border: Border.all(
              width: 3, color: const Color.fromARGB(19, 39, 39, 39))),
        padding: const EdgeInsets.all(10),
        child: Center(child: Countdown(duration:widget.remainingTime!, projectDetailsState: this))
      ):
      functionItem("Sign Contract", "Contractor", Sign(project: widget.project)),
      // functionItem("Set Parties", "Author", SetParty(project: widget.project)),
    ];
     var human = Provider.of<Human>(context);
      List<TTransaction> filteredTransactions = [];
      widget.projectActivity=[];
      for (TTransaction t in actions){
        if (t.contractAddress==widget.project.contractAddress){
          filteredTransactions.add(t);
          widget.projectActivity.add(ActionItem(action: t, landingPage: true));
        }
      }


  User? arbiter = users.firstWhere((user) => user.address.toLowerCase() == widget.project.arbiter!.toLowerCase(), orElse: () {
      return User(
        lastActive: DateTime.now(),
        address: widget.project.arbiter!,
        nativeEarned: "0",
        usdtEarned: "0",
        usdtSpent: "0",
        nativeSpent: "0",
        projectsContracted: [],
        projectsArbitrated: [],
        projectsBacked: [],
        projectsAuthored: [],
      );
    });
     User? contractor = users.firstWhere((user) => user.address.toLowerCase() == widget.project.contractor!.toLowerCase(), orElse: () {
      return User(
        lastActive: DateTime.now(),
        address: widget.project.contractor!,
        nativeEarned: "0",
        usdtEarned: "0",
        usdtSpent: "0",
        nativeSpent: "0",
        projectsContracted: [],
        projectsArbitrated: [],
        projectsBacked: [],
        projectsAuthored: [],
      );
    });
    return BaseScaffold(
      selectedItem: 1,
      title: "Project",
      body: 
      MediaQuery.of(context).size.aspectRatio>1?
      // =========================================== START IF WIDE ================================
      Container(
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true, // Set this property to true
            children: [
              const SizedBox(height: 30),
              Column(
                  // Start of Column
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Set this property to center the items horizontally
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize
                      .min, // Set this property to make the column fit its children's size vertically
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      // height: 240,
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                         FutureBuilder<Uint8List>(
                                future: generateAvatarAsync(hashString(widget.project.contractAddress!)),  // Make your generateAvatar function return Future<Uint8List>
                                builder: (context, snapshot) {
                                  // Future.delayed(Duration(milliseconds: 500));
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    
                                    
                                    return Container(
                                     
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                          color: Theme.of(context).canvasColor,
                                      ),
                                      width: 50.0,
                                      height:50.0,
                                    
                                    );
                                  } else if (snapshot.hasData) {
                                    
                                    return Container(width: 50,height: 50,  
                                     decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                    child: Image.memory(snapshot.data!));
                                    
                                  } else {
                                    return Container(
                                      width: 50.0,
                                      height: 50.0,
                                      color: Theme.of(context).canvasColor,  // Error color
                                    );
                                  }
                                },
                              ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.project!.name!.toString(),
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                    SizedBox(
                                      height: 35,
                                      width: 500,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Created: ${DateFormat.yMMMd().format(widget.project.creationDate!)}    ",
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                            widget.project.status == "Dispute"
                                                ? Text(
                                                    "Expires: ${DateFormat.yMMMd().format(widget.project.expiresAt!)}",
                                                    style: const TextStyle(fontSize: 13))
                                                : const Text(""),
                                            StatusBox(project: widget.project)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 450,
                                      ),
                                      padding: const EdgeInsets.all(18.0),
                                      child:  Text(
                                        widget.project.description!,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text("Contract Address: "),
                                           Padding(
                                               padding: const EdgeInsets.only(top:4.0),
                                              child: Text(
                                                widget.project.contractAddress!,
                                                style:  TextStyle(fontSize: 11,color:Theme.of(context).textTheme.displayMedium!.color),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            TextButton(
                                                onPressed: ()async {
                                                  copied(context,widget.project.contractAddress!);
                                                },
                                                child: const Icon(Icons.copy)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             Text("Author: ", style:  TextStyle(
                                                    color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.author!.toLowerCase()?
                                                      Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,)),
                                          profileButton(
                                             Padding(
                                                 padding: const EdgeInsets.only(top:4.0),
                                                 child: Text(
                                                   MediaQuery.of(context).size.aspectRatio>1?
                                                 widget.project.author!:
                                                 getShortAddress(widget.project.author!),
                                                  style:  TextStyle(
                                                    fontSize: 11,
                                                    color: !(human.address == null) && human.address!.toLowerCase()==widget.project.author!.toLowerCase()?
                                                        Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color
                                                    ),
                                                                                           ),
                                               ), users.firstWhere((user) => user.address==widget.project.author),
                                           ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  copied(context,widget.project.author!);
                                                },
                                                child: const Icon(Icons.copy)),
                                              ],
                                            ),
                                          ),
                                          ),
                                          widget.project.contractor!.length>3?
                                           SizedBox(
                                      height: 35,
                                      child: Center(
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             Text("Contractor: ", style:  TextStyle(
                                                    color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.contractor!.toLowerCase()?
                                                      Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,)),
                                             
                                            profileButton(
                                               Padding(
                                                 padding: const EdgeInsets.only(top:4.0),
                                                 child: Text(
                                                     MediaQuery.of(context).size.aspectRatio>1?
                                                 widget.project.contractor!:
                                                 getShortAddress(widget.project.contractor!)
                                                 ,
                                                  style:  TextStyle(
                                                      color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.contractor!.toLowerCase()?
                                                        Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,
                                                    fontSize: 11),                              ),
                                               ),
                                             contractor
                                             ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            
                                            widget.project.contractor!.length<3?const SizedBox(width:54):
                                            TextButton(
                                                onPressed: () {
                                                  copied(context, widget.project.contractor);
                                                },
                                                child: const Icon(Icons.copy)),
                                              ],
                                            )
                                          ),
                                          ):const Text(""),
                                          widget.project.arbiter!.length>3?
                                            SizedBox(
                                      height: 35,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             Text("Arbiter: ", style:  TextStyle(
                                                    color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.arbiter!.toLowerCase()?
                                                      Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,)),
                                             
                                          profileButton(
                                               Padding(
                                                 padding: const EdgeInsets.only(top:4.0),
                                                 child: Text(
                                                     MediaQuery.of(context).size.aspectRatio>1?
                                                 widget.project.arbiter!:
                                                 getShortAddress(widget.project.arbiter!)
                                                 ,
                                                  style:  TextStyle(
                                                      color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.arbiter!.toLowerCase()?
                                                        Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,
                                                    fontSize: 11),
                                                                                           ),
                                               ),
                                              arbiter
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ), widget.project.arbiter!.length<3?const SizedBox(width:54):
                                            TextButton(
                                                onPressed: () {
                                                  copied(context, widget.project.arbiter);
                                                },
                                                child: const Icon(Icons.copy)),
                                              ],
                                            ),
                                          ),
                                          ):const Text(""),
                                      SizedBox(
                                      height: 35,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             const Text("Repository: "),
                                            Padding(
                                               padding: const EdgeInsets.only(top:4.0),
                                               child: Text(
                                               fit(widget.project.repo!),
                                                style:  TextStyle(fontSize: 11,color:Theme.of(context).textTheme.displayMedium!.color),
                                                                                         ),
                                             ),
                                             const SizedBox(
                                              width: 2,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  launch(widget.project.repo!);
                                                },
                                                child: const Icon(Icons.open_in_new)),
                                              ],
                                            ),
                                          ),
                                      ), 
                                  ],
                                )
                              ],
                            ),
                           const SizedBox(height: 25),
                            !(widget.project.status=="open")
                            ? 
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 850,
                              ),
                              height: 33,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.1 , color: Theme.of(context).indicatorColor ),
                                color: Theme.of(context).dividerColor.withOpacity(0.1)
                              ),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Opacity(opacity: 0.8, child: Text("Hash of Terms:")),
                                  const SizedBox(width: 10),
                                  Text(widget.project.termsHash??"" , style: const TextStyle(backgroundColor: Colors.black54, color: Colors.white70), ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                      onPressed: () {copied(context, widget.project.termsHash??"");},
                                      child: const Icon(Icons.copy)),
                                ],
                              )
                            ): const SizedBox(),
                            const SizedBox(height: 15),
                             (widget.project.status=="closed") &&
                             !(widget.project.arbiterAwardingContractor==null) &&
                            BigInt.parse( widget.project.arbiterAwardingContractor!) > BigInt.zero

                            ? Container( 
                               constraints: const BoxConstraints(
                                maxWidth: 850,
                              ),
                              height: 83,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                 
                                  Text("Dispute resolved with ${cf.weiToEth(widget.project.arbiterAwardingContractor.toString()) } ${widget.project.isUSDT? "USDC": Human().chain.nativeSymbol} awarded to Contractor",style: const TextStyle(fontSize: 20),),
                                 Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Opacity(opacity: 0.8, child: Text("Hash of Ruling:")),
                                  const SizedBox(width: 10),
                                  Text(widget.project.rulingHash??"" , style: const TextStyle(fontSize:12 , backgroundColor: Colors.black54, color: Colors.white70), ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                      onPressed: () {copied(context, widget.project.rulingHash??"");},
                                      child: const Icon(Icons.copy)),
                                ],
                              )
                                ],
                              ),
                            ):
                            const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height:  20),
                    Container(
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 1200,
                      ),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 1200,
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                         
                                          Padding(
                                            padding:
                                              const EdgeInsets.only(left: 28.0),
                                            child: Text(
                                              widget.project.status == "open" ||
                                              widget.project.status == "pending" ||
                                              widget.project.status == "closed"
                                                  ? 
                                                  "Funds in Contract"
                                                  :
                                                  "Funds in Escrow",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                           SizedBox(
                                            width: 29,
                                             child: TextButton(child: Center(child: Icon(Icons.refresh)), 
                                              onPressed: ()async {
                                                setState(() {
                                                  widget.refreshingBalance=true;
                                                });
                                                 String newBalance = await cf.getNativeBalance(widget.project.contractAddress!);
                                                if (!(widget.project.holding==newBalance)){
                                                  print("not the same balance");
                                                  widget.project.holding=newBalance;
                                                  await projectsCollection.doc(widget.project.contractAddress)
                                                      .set(widget.project.toJson());
                                                }else{print("same balance");}
                                                setState(() {
                                                  widget.refreshingBalance=false;
                                                });
                                              } ),
                                           )
                                        ],
                                      ),

                                      // before 857.4335 XTZ
                                      //contribution - 2
                                      //dispute percentage: 50

                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        height: 35,
                                        padding:
                                            const EdgeInsets.only(left: 28.0),
                                        child: 
                                        widget.refreshingBalance?Container(
                                          constraints: BoxConstraints(maxHeight: 3),
                                          width:35, height: 35, child: CircularProgressIndicator(strokeWidth: 2,))
                                        :
                                        Row(
                                          children: [
                              Text(
                                cf.weiToEth(widget.project.holding)
                                ,style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal),
                                    ),
                                  Text(
                                    widget.project.isUSDT?" USDT":" "+ Human().chain.nativeSymbol,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDialog(context: context, builder: ((context) => 
                                      AlertDialog(content: BackersList(project: widget.project),)));
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                          Text(
                                          widget.project.contributions.length.toString(),
                                          style: const TextStyle(
                                              fontSize: 27,
                                              fontWeight:
                                                  FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Backers",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .indicatorColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ],
                                ),
                              ),
                              ! (widget.project.status == "open")    &&
                              ! (widget.project.status == "pending")
                              ?
                                Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                      const EdgeInsets.only(left: 0),
                                    child: Text(
                                      "Voting to release",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .indicatorColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),  
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 28.0),
                                    child: Row(
                                      children: [
                                        Text(
                                        cf.weiToEth("${
                                            widget.project.contributorsReleasing.values.fold(BigInt.zero, (sum, value) {
                                                return sum + BigInt.parse(value);
                                              })
                                              
                                          } "),
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          widget.project.isUSDT?"USDT" :" "+Human().chain.nativeSymbol,
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ):const Text("")
                              ,
                              ! (widget.project.status == "open")     &&
                              ! (widget.project.status == "pending")
                              ?
                                Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                      const EdgeInsets.only(left: 0),
                                    child: Text(
                                      "Voting to dispute",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .indicatorColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 28.0),
                                    child: Row(
                                      children: [
                                        Text(
                                        cf.weiToEth(  "${
                                           widget.project.contributorsDisputing.values.fold(BigInt.zero, (sum, value) {
                                                return sum + BigInt.parse(value);
                                              })
                                            } "),
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          widget.project.isUSDT?" USDT":" "+Human().chain.nativeSymbol,
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ):const Text("")
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Opacity(
                              opacity: 0.1,
                              child: Divider(
                                thickness: 6,
                                height: 18,
                              )),
                        ),
                        const SizedBox(
                          height: 37,
                        ),
                        Wrap(
                            runAlignment: WrapAlignment.center,
                            spacing: 40,
                            runSpacing: 40,
                            children: widget.project.status == "ongoing"
                                ? ongoingProjectFunctions
                                : widget.project.status == "open"
                                    ? openProjectFunctions
                                    : widget.project.status == "closed"
                                        ? closedProjectFunctions
                                        : widget.project.status ==
                                                "pending"
                                            ? pendingProjectFunctions
                                            : disputedProjectFunctions),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                  DefaultTabController(
                    initialIndex: 0,
                    length:2,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,height: 35,
                          child: TabBar(
                             labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                            tabs: [Tab(text: "README.md"),Tab(text: "Activity"),])),
                        SizedBox(
                              height: 700,
                              width: 1200,
                          child: TabBarView(
                            children: [
                              Container(
                            
                              decoration: BoxDecoration(
                                
                                color:Theme.of(context).brightness==Brightness.light?const Color.fromARGB(255, 223, 223, 223):Colors.black,
                                border: Border.all(width: 0.5)
                              ),
                                    padding: const EdgeInsets.all(50),
                                    child: 
                                    
                                    FutureBuilder(
                                      future: http.get(
                                        Uri.https(
                                          'raw.githubusercontent.com',
                                          '${extractGitHubPath(widget.project.repo)}/master/README.md',
                                        ),
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return const Align( 
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 13,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return SizedBox(
                                            height: 700,
                                            width: 1100,
                                            child: Markdown(
                                              styleSheet:
                                                  getMarkdownStyleSheet(context),
                                              data: (snapshot.data as http.Response)
                                                  .body
                                                  .toString(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                          Container(
              height: 600,
              
              decoration: const BoxDecoration(
                color: Color(0x23000000),
              ),
            child: 
            // Text("")
            ListView(children: widget.projectActivity)
            ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                Footer()
                  ]),
            ],
          )):
      // 💩💩💩💩💩 T A L L  💩💩💩💩💩
      
       MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
        child: Container(
            alignment: Alignment.topCenter,
            child: ListView(
              shrinkWrap: true, // Set this property to true
              children: [
                const SizedBox(height: 30),
                Column(
                    // Start of Column
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Set this property to center the items horizontally
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize
                        .min, // Set this property to make the column fit its children's size vertically
                    children: [
      
                  const SizedBox(height: 9),
                       Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                           FutureBuilder<Uint8List>(
                                  future: generateAvatarAsync(hashString(widget.project.contractAddress!)),  // Make your generateAvatar function return Future<Uint8List>
                                  builder: (context, snapshot) {
                                    // Future.delayed(Duration(milliseconds: 500));
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                            color: Theme.of(context).canvasColor,
                                        ),
                                        width: 50.0,
                                        height:50.0,
                                      );
                                    } else if (snapshot.hasData) {
                                      return Container(width: 50,height: 50,  
                                       decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0)
                                        ),
                                      child: Image.memory(snapshot.data!));
                                    } else {
                                      return Container(
                                        width: 50.0,
                                        height: 50.0,
                                        color: Theme.of(context).canvasColor,  // Error color
                                      );
                                    }
                                  },
                                ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            widget.project!.name!.toString(),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                      SizedBox(
                                        height: 35,
                                        width: 500,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Created: ${DateFormat.yMMMd().format(widget.project.creationDate!)}    ",
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                              widget.project.status == "Dispute"
                                                  ? Text(
                                                      "Expires: ${DateFormat.yMMMd().format(widget.project.expiresAt!)}",
                                                      style: const TextStyle(fontSize: 13))
                                                  : const Text(""),
                                              StatusBox(project: widget.project)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 450,
                                        ),
                                        padding: const EdgeInsets.all(18.0),
                                        child:  Text(
                                          widget.project.description!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                    DefaultTabController(
                      initialIndex: 0,
                      length:4,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 35,
                            child: TabBar(
                               labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                              tabs: [
                                Tab(text: "Overview"),
                                Tab(text: "Functions"),
                                Tab(text: "README.md"),
                                Tab(text: "Activity"),
                                
                                ])),
                          SizedBox(
                              height:1200,
                               
                               
                            child: TabBarView(
                              children: [
                                Column(children:[
                                  Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        // height: 240,
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                 
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text("Contract Address: "),
                                             Padding(
                                                 padding: const EdgeInsets.only(top:4.0),
                                                child: Text(
                                           getShortAddress(widget.project.contractAddress!),
                                                  style:  TextStyle(fontSize: 11,color:Theme.of(context).textTheme.displayMedium!.color),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              TextButton(
                                                  onPressed: ()async {
                                                    copied(context,widget.project.contractAddress!);
                                                  },
                                                  child: const Icon(Icons.copy)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 35,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                               Text("Author: ", style:  TextStyle(
                                                      color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.author!.toLowerCase()?
                                                        Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,)),
                                            profileButton(
                                               Padding(
                                                   padding: const EdgeInsets.only(top:4.0),
                                                   child: Text(
                                                  getShortAddress( widget.project.author!),
                                                    style:  TextStyle(
                                                      fontSize: 11,
                                                      color: !(human.address == null) && human.address!.toLowerCase()==widget.project.author!.toLowerCase()?
                                                          Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color
                                                      ),
                                                                                             ),
                                                 ), users.firstWhere((user) => user.address==widget.project.author),
                                             ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    copied(context,widget.project.author!);
                                                  },
                                                  child: const Icon(Icons.copy)),
                                                ],
                                              ),
                                            ),
                                            ),
                                            widget.project.contractor!.length>3?
                                             SizedBox(
                                        height: 35,
                                        child: Center(
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                               Text("Contractor: ", style:  TextStyle(
                                                      color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.contractor!.toLowerCase()?
                                                        Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,)),
                                               
                                              profileButton(
                                                 Padding(
                                                   padding: const EdgeInsets.only(top:4.0),
                                                   child: Text(
                                                    getShortAddress( widget.project.contractor!),
                                                    style:  TextStyle(
                                                        color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.contractor!.toLowerCase()?
                                                          Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,
                                                      fontSize: 11),                              ),
                                                 ),
                                               contractor
                                               ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              
                                              widget.project.contractor!.length<3?const SizedBox(width:54):
                                              TextButton(
                                                  onPressed: () {
                                                    copied(context, widget.project.contractor);
                                                  },
                                                  child: const Icon(Icons.copy)),
                                                ],
                                              )
                                            ),
                                            ):const Text(""),
                                            widget.project.arbiter!.length>3?
                                              SizedBox(
                                        height: 35,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                               Text("Arbiter: ", style:  TextStyle(
                                                      color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.arbiter!.toLowerCase()?
                                                        Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,)),
                                               
                                            profileButton(
                                                 Padding(
                                                   padding: const EdgeInsets.only(top:4.0),
                                                   child: Text(
                                                   getShortAddress(  widget.project.arbiter!),
                                                    style:  TextStyle(
                                                        color: !(human.address == null) &&  human.address!.toLowerCase()==widget.project.arbiter!.toLowerCase()?
                                                          Theme.of(context).indicatorColor:Theme.of(context).textTheme.displayMedium!.color,
                                                      fontSize: 11),
                                                                                             ),
                                                 ),
                                                arbiter
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ), widget.project.arbiter!.length<3?const SizedBox(width:54):
                                              TextButton(
                                                  onPressed: () {
                                                    copied(context, widget.project.arbiter);
                                                  },
                                                  child: const Icon(Icons.copy)),
                                                ],
                                              ),
                                            ),
                                            ):const Text(""),
                                        SizedBox(
                                        height: 35,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                               const Text("Repository: "),
                                              Padding(
                                                 padding: const EdgeInsets.only(top:4.0),
                                                 child: Text(
                                                 getShortAddress( widget.project.repo!),
                                                  style:  TextStyle(fontSize: 11,color:Theme.of(context).textTheme.displayMedium!.color),
                                                ),
                                               ),
                                               const SizedBox(
                                                width: 2,
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    launch(widget.project.repo!);
                                                  },
                                                  child: const Icon(Icons.open_in_new)),
                                                ],
                                              ),
                                            ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                             const SizedBox(height: 25),
                              !(widget.project.status=="open")
                              ? 
                              Container(
                                
                                
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.1 , color: Theme.of(context).indicatorColor ),
                                  color: Theme.of(context).dividerColor.withOpacity(0.1)
                                ),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(opacity: 0.8, child: Text("Hash of Terms:")),
                                    const SizedBox(width: 10),
                                    Text( !(widget.project.termsHash==null)?
                                    getShortAddress(widget.project.termsHash!)
                                    :""
                                     , style: const TextStyle(backgroundColor: Colors.black54, color: Colors.white70), ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                        onPressed: () {copied(context, widget.project.termsHash??"");},
                                        child: const Icon(Icons.copy)),
                                  ],
                                )
                              ): const SizedBox(),
                              const SizedBox(height: 15),
                               (widget.project.status=="closed") &&
                               !(widget.project.arbiterAwardingContractor==null) &&
                              BigInt.parse( widget.project.arbiterAwardingContractor!) > BigInt.zero
                              ? Container( 
                                 constraints: const BoxConstraints(
                                  maxWidth: 850,
                                ),
                                
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     MediaQuery.of(context).size.aspectRatio<1?const SizedBox(height:30):Text(""),
                                    Text("Dispute resolved with ${cf.weiToEth(widget.project.arbiterAwardingContractor.toString()) }  ${widget.project.isUSDT? "USDC": Human().chain.nativeSymbol} awarded to Contractor",
                                     textAlign:TextAlign.center,
                                     style: const TextStyle(fontSize: 20),),
                                  const SizedBox(height:20),
                                   Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Opacity(opacity: 0.8, child: Text("Hash of Ruling:")),
                                    const SizedBox(width: 10),
                                    Text(
                                      !(widget.project.rulingHash==null)?
                                      getShortAddress(widget.project.rulingHash!):""
                                       , style: const TextStyle(fontSize:12 , backgroundColor: Colors.black54, color: Colors.white70), ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                        onPressed: () {copied(context, widget.project.rulingHash??"");},
                                        child: const Icon(Icons.copy)),
                                  ],
                                ),
                                const SizedBox(height:30),
                               const Divider(),
                                const SizedBox(height:30),
                          SizedBox(
                          width: double.infinity,
                        
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                   
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      
                                           
                                            Padding(
                                              padding:
                                                const EdgeInsets.all( 8.0),
                                              child: Text(
                                                widget.project.status == "open" ||
                                                widget.project.status == "pending" ||
                                                widget.project.status == "closed"
                                                    ? 
                                                    "Funds in Contract"
                                                    :
                                                    "Funds in Escrow",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Theme.of(context)
                                                        .indicatorColor,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          height: 35,
                                          padding:
                                              const EdgeInsets.only(left: 28.0),
                                          child: 
                                          widget.refreshingBalance?Container(
                                            constraints: BoxConstraints(maxHeight: 3),
                                            width:35, height: 35, child:const CircularProgressIndicator(strokeWidth: 2,))
                                          :
                                          Row(
                                            children: [
                                Text(
                                  cf.weiToEth(widget.project.holding)
                                  ,style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal),
                                      ),
                                    Text(
                                      widget.project.isUSDT?" USDT":" "+ Human().chain.nativeSymbol,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),  SizedBox(
                                              width: 29,
                                               child: TextButton(child: Center(child: Icon(Icons.refresh)), 
                                                onPressed: ()async {
                                                  setState(() {
                                                    widget.refreshingBalance=true;
                                                  });
                                                   String newBalance = await cf.getNativeBalance(widget.project.contractAddress!);
                                                  if (!(widget.project.holding==newBalance)){
                                                    print("not the same balance");
                                                    widget.project.holding=newBalance;
                                                    await projectsCollection.doc(widget.project.contractAddress)
                                                        .set(widget.project.toJson());
                                                  }else{print("same balance");}
                                                  setState(() {
                                                    widget.refreshingBalance=false;
                                                  });
                                                } ),
                                             )
                            ],
                          ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        showDialog(context: context, builder: ((context) => 
                                        AlertDialog(content: BackersList(project: widget.project),)));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                            Text(
                                            widget.project.contributions.length.toString(),
                                            style: const TextStyle(
                                                fontSize: 27,
                                                fontWeight:
                                                    FontWeight.normal),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Backers",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .indicatorColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ],
                                  ),
                                ),
                                  const  SizedBox(height:20),
                                ! (widget.project.status == "open")    &&
                                ! (widget.project.status == "pending")
                                ?
                                
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                
                                    Text(
                                      "Voting to release   ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .indicatorColor,
                                          fontWeight: FontWeight.normal),
                                    ),  
                                    const SizedBox( height: 18),
                                    Row(
                                      children: [
                                        Text(
                                        cf.weiToEth("${
                                            widget.project.contributorsReleasing.values.fold(BigInt.zero, (sum, value) {
                                                return sum + BigInt.parse(value);
                                              })
                                              
                                          } "),
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          widget.project.isUSDT?"USDT" :" "+Human().chain.nativeSymbol,
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ],
                                ):const Text("")
                                ,
                                  const  SizedBox(height:20),
                                ! (widget.project.status == "open")     &&
                                ! (widget.project.status == "pending")
                                ?
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                        const EdgeInsets.only(left: 0),
                                      child: Text(
                                        "Voting to dispute",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Row(
                                        children: [
                                          Text(
                                          cf.weiToEth(  "${
                                             widget.project.contributorsDisputing.values.fold(BigInt.zero, (sum, value) {
                                                  return sum + BigInt.parse(value);
                                                })
                                              } "),
                                            style: const TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            widget.project.isUSDT?" USDT":" "+Human().chain.nativeSymbol,
                                            style: const TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ):const Text("")
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Opacity(
                                opacity: 0.1,
                                child: Divider(
                                  thickness: 6,
                                  height: 18,
                                )),
                          ),
                          const SizedBox(
                            height: 37,
                          ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    
                  ),
                                  ],
                                ),
                              ):
                              const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                                ]),
      
                                Padding(
                                  padding: const EdgeInsets.only(top:38.0),
                                  child: Column(
                                                            
                                                            children: widget.project.status == "ongoing"
                                    ? [ const SizedBox(height:55), ...ongoingProjectFunctions]
                                    : widget.project.status == "open"
                                        ?[const SizedBox(height:55), ... openProjectFunctions]
                                        : widget.project.status == "closed"
                                            ? closedProjectFunctions
                                            : widget.project.status ==
                                                    "pending"
                                                ? [const SizedBox(height:55), ... pendingProjectFunctions]
                                                : [const SizedBox(height:55), ...disputedProjectFunctions]),
                                ),
      
                                Container(
                              
                                decoration: BoxDecoration(
                                  
                                  color:Theme.of(context).brightness==Brightness.light?const Color.fromARGB(255, 223, 223, 223):Colors.black,
                                  border: Border.all(width: 0.5)
                                ),
                                      padding: const EdgeInsets.all(50),
                                      child: 
                                      
                                      FutureBuilder(
                                        future: http.get(
                                          Uri.https(
                                            'raw.githubusercontent.com',
                                            '${extractGitHubPath(widget.project.repo)}/master/README.md',
                                          ),
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState !=
                                              ConnectionState.done) {
                                            return const Align( 
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 20),
                                                child: SizedBox(
                                                  width: 120,
                                                  height: 120,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 13,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              height: 700,
                                              width: 1100,
                                              child: Markdown(
                                                styleSheet:
                                                    getMarkdownStyleSheet(context),
                                                data: (snapshot.data as http.Response)
                                                    .body
                                                    .toString(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                            Container(
                height: 600,
                
                decoration: const BoxDecoration(
                  color: Color(0x23000000),
                ),
              child: 
              // Text("")
              ListView(children: widget.projectActivity)
              ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // const SizedBox(height: 30),
                  Footer()
                    ]),
              ],
            )),
      ),    
      
      
    );
  }
  fit(text){
    if (text.length<33){
      return text;
    }
    else {
      return text.toString().substring(0,33)+"...";
      }
  }

  Widget functionItem(String title, String access, target) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      customBorder: Border.all(),
      hoverColor: const Color.fromARGB(37, 182, 182, 182),
      onTap: () {
        Human().address==null?
         showDialog(
         
            context: context,
            builder: (context) => const AlertDialog(
                  content: SizedBox(height:100, width: 400,child:Center(child: 
                  Text("Connect your wallet to call functions.")
                  )),
                ))
        : 
        showDialog(
           barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  content:target,
                ));
      },
      child: Container(
        margin:const EdgeInsets.all(1),
        width: 410,
        height: 146,
        decoration: BoxDecoration(
            color: const Color.fromARGB(46, 37, 37, 37),
            borderRadius:const BorderRadius.all(Radius.circular(3.0)),
            border: Border.all(
              width: 3, color: const Color.fromARGB(19, 39, 39, 39))),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(
                width: 360,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Can be called by: ",
                    style: TextStyle(
                      fontSize: 13,
                    )),
                Text(
                  access,
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).indicatorColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BackersList extends StatefulWidget {
  Project project;
  User? selectedUser;
  bool main=true;
  BackersList({super.key, required this.project});
  @override
  State<BackersList> createState() => _BackersListState();
}

class _BackersListState extends State<BackersList> {
  List<Widget> rows = [];
  @override
  Widget build(BuildContext context) {
    rows.clear();
    widget.project.contributions.forEach((key, value) {
        User? user = users.firstWhere((user) => user.address.toLowerCase() == key.toLowerCase(), orElse: () {
      return User(
        lastActive: DateTime.now(),
        address: widget.project.arbiter!,
        nativeEarned: "0",
        usdtEarned: "0",
        usdtSpent: "0",
        nativeSpent: "0",
        projectsContracted: [],
        projectsArbitrated: [],
        projectsBacked: [],
        projectsAuthored: [],
      );
    });
    
  rows.add(
    Container(
      margin: const EdgeInsets.all(4),
      color:Theme.of(context).canvasColor,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width:60, child:
          widget.project.contributorsReleasing.containsKey(key) && BigInt.parse (widget.project.contributorsReleasing[key]!) > BigInt.zero  ?
          const Icon(Icons.lock_open, color: Colors.green)
          :
          widget.project.contributorsDisputing.containsKey(key) &&  BigInt.parse (widget.project.contributorsDisputing[key]!) > BigInt.zero ?
          Image.asset('assets/scale2.png', height:25, color:Colors.red) 
          
          :
          
          const Text("")),
              TextButton(
                onPressed: (){
                  widget.selectedUser=user;
                  setState(() {
                    widget.main=false;
                  });
                },
                child: SizedBox(
                  width: 160,
                  child: Center(child: Text( getShortAddress( "$key")))),
              ),
            ],
          ),
          const Spacer(), // Adjust as needed
          Padding(
            padding: const EdgeInsets.only(right:88.0),
            child: Text(cf.weiToEth( value)),
          ),
        ],
      ),
    ),
  );
});

  switch (widget.main) {
          case true:
          return stage0();
          default: return stage1(widget.selectedUser!);
      }
  }

 Widget stage0(){
  return SizedBox(
     height:570,
      width: 600,
    child: Center(child: SizedBox(
        height:570,
        width: 600,
          child: ListView(
            children:[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
               SizedBox(width: 40,),  Text("Address"),  Spacer(),  Text("Amount (" + Human().chain.nativeSymbol.toString() +")"),
               const SizedBox(width: 10,) 
              ],),
              const SizedBox(height: 10),
              ...rows,
              ]
          ),
        ),
      ),
  );
 }


 Widget stage1(User user){
  return SizedBox(
      height:570,
      width: 600,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(onPressed: (){
                setState(() {
                  widget.main=true;
                });
              }, child:const Opacity(
                opacity: 0.7,
                child:  Text("< BACK")))
            ],),
          SizedBox(
          height:500,
          width: 600,
            child: UserDetails(human: user))
        ],
      )
      );
  }
}


copied(context, text) async{
    await Clipboard.setData(
          ClipboardData(text:text)
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        // The content of the SnackBar.
        content: Center(
            child: Text(
          'Item copied to clipboard',
          style: TextStyle(fontSize: 15),
        )),
        // The duration of the SnackBar.
        duration: Duration(seconds: 2),
      ),
    );
  }