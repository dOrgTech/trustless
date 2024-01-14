import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustless/entities/human.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/arbitrate.dart';
import 'package:trustless/widgets/dispute.dart';
import 'package:trustless/widgets/footer.dart';
import 'package:trustless/widgets/projectCard.dart';
import 'package:trustless/widgets/proposalDetails.dart';
import 'package:trustless/widgets/release.dart';
import 'package:trustless/widgets/sendfunds.dart';
import 'package:trustless/widgets/setParty.dart';
import 'package:intl/intl.dart';
import 'package:trustless/widgets/sign.dart';
import 'package:url_launcher/url_launcher.dart';
import '../entities/project.dart';
import '../main.dart';
import '../widgets/withdraw.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class ProjectDetails extends StatefulWidget {
  ProjectDetails({super.key, required this.project});
  Project project;
  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
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
  @override
  Widget build(BuildContext context) {
    widget.project.holding= widget.project.contributions.values.fold(0, (a, b) => a! + b);

    List<Widget> openProjectFunctions = [
      functionItem("Send Funds to Project", "Anyone", SendFunds(project: widget.project)),
      functionItem("Set Parties", "Author", SetParty(project: widget.project)),
      functionItem("Withdraw", "Anyone", Withdraw(project: widget.project)),
    ];
    List<Widget> ongoingProjectFunctions = [
      functionItem("Initiate Dispute", "Parties", Dispute()),
      functionItem("Release Funds to Contractor", "Backers", Release(project: widget.project)),
      functionItem("Reinburse Backers", "Contractor", Release(project: widget.project)),
    ];
    List<Widget> disputedProjectFunctions = [
      functionItem("Arbitrate", "Arbiter", Arbitrate(project: widget.project)),
    ];
    List<Widget> closedProjectFunctions = [
      functionItem("Withdraw", "Anyone", Withdraw(project: widget.project)),
    ];

    List<Widget> pendingProjectFunctions = [
      functionItem("Send Funds to Project", "Anyone", SendFunds(project: widget.project)),
      functionItem("Withdraw", "Anyone", Withdraw(project: widget.project)),
      functionItem("Sign Contract", "Contractor", Sign(project: widget.project)),
      functionItem("Set Parties", "Author", SetParty(project: widget.project)),
    ];
    return BaseScaffold(
      selectedItem: 1,
      title: "Project",
      body: Container(
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.project!.name!.toString(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                            Text(
                                             widget.project.contractAddress!,
                                              style: const TextStyle(fontSize: 11),
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
                                            const Text("Author: "),
                                             Text(
                                             widget.project.author!,
                                              style: const TextStyle(fontSize: 11),
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
                                           SizedBox(
                                      height: 35,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text("Contractor: "),
                                              widget.project.contractor!.length>3?
                                             Text(
                                             widget.project.contractor!,
                                              style: const TextStyle(fontSize: 11),
                                            ):const SizedBox(width:235,child: Text("N/A")),
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
                                            ),
                                          ),
                                          ),
                                            SizedBox(
                                      height: 35,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text("Arbiter: "),
                                             widget.project.arbiter!.length>3?
                                             Text(
                                             widget.project.arbiter!,
                                              style: const TextStyle(fontSize: 11),
                                            ):const SizedBox(width:235,child: Text("N/A")),
                                            const SizedBox(
                                              width: 2,
                                            ), widget.project.contractor!.length<3?const SizedBox(width:54):
                                            TextButton(
                                                onPressed: () {
                                                  copied(context, widget.project.arbiter);
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
                                             const Text("Repository: "),
                                             Text(
                                             fit(widget.project.repo!),
                                              style: const TextStyle(fontSize: 11),
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
                            !(widget.project.status=="open")? 
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
                                  Opacity(opacity: 0.8, child: Text("Hash of ${widget.project.hashedFileName??""} :")),
                                  const SizedBox(width: 10),
                                  Text(widget.project.termsHash??"" , style: const TextStyle(backgroundColor: Colors.black54, color: Colors.white70), ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                      onPressed: () {copied(context, widget.project.termsHash??"");},
                                      child: const Icon(Icons.copy)),
                                ],
                              )
                            ):SizedBox(),
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
                                      Padding(
                                        padding:
                                          const EdgeInsets.only(left: 28.0),
                                        child: Text(
                                          widget.project.status == "Pending" ||
                                                  widget.project.status ==
                                                      "pending"
                                              ? "Funds in Contract"
                                              : "Funds in Escrow",
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
                                              "${widget.project.holding!} ",
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            Text(
                                              widget.project.isUSDT?"USDT":"XTZ",
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
                                      const SizedBox(
                                        width: 70,
                                      ),
                                      
                                      ],
                                    ),
                                  ),
                                  widget.project.status == "ongoing"?
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
                                              "${
                                                widget.project.contributorsReleasing.values.fold(0, (a, b) => a + b)
                                              } ",
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            Text(
                                              widget.project.isUSDT?"USDT":"XTZ",
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ):Text(""),
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
                                  '${widget.project.repo?.split('github.com/')[1]}/master/README.md',
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
                   const SizedBox(height: 30),
                   Footer()
                  ]),
            ],
          )),
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
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      customBorder: Border.all(),
      hoverColor: Color.fromARGB(37, 182, 182, 182),
      onTap: () {
        Human().address==null?
         showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: SizedBox(height:100, width: 400,child:Center(child: 
                  Text("Connect your wallet to call functions.")
                  )),
                ))
        : 
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: target,
                ));
      },
      child: Container(
        margin:EdgeInsets.all(1),
        width: 410,
        height: 146,
        decoration: BoxDecoration(
            color: Color.fromARGB(46, 37, 37, 37),
            borderRadius:BorderRadius.all(Radius.circular(3.0)),
            border: Border.all(
            
              width: 3, color: Color.fromARGB(19, 39, 39, 39))),
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

class BackersList extends StatelessWidget {
  Project project;
   BackersList({super.key, required this.project});
  List<Widget> rows = [];
  @override
  Widget build(BuildContext context) {
    project.contributions.forEach((key, value) {
  rows.add(
    Container(
      padding:const EdgeInsets.all(5),
      margin: const EdgeInsets.all(2),
      color:Theme.of(context).canvasColor,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              SizedBox(
                width: 160,
                child: Center(child: Text( getShortAddress( "$key")))),
              TextButton(onPressed: (){
               copied(context, key);
              }, child: Icon(Icons.copy))
            ],
          ),
          SizedBox(width: 70), // Adjust as needed
          Text("$value"),
        ],
      ),
    ),
  );
});

    return Container(
      height:600,
      width: 500,
      child: Center(
        child: ListView(
          children:[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            SizedBox(width: 40,), Text("Address"), SizedBox(width: 210,), Text("Amount"),SizedBox(width: 10,) 
            ],),
            SizedBox(height: 10),
            ...rows,
          
            
            ]
        ),
      ),
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