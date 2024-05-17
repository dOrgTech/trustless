import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trustless/entities/contractFunctions.dart';
import 'package:trustless/screens/landing.dart';
import 'package:trustless/screens/poll.dart';
import 'package:trustless/screens/prelaunch.dart';
import 'package:trustless/screens/profile.dart';
import 'package:trustless/screens/projects.dart';
import 'package:trustless/screens/users.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/utils/scripts.dart';
import 'package:trustless/widgets/chat.dart';
import 'package:trustless/widgets/projectDetails.dart';
import 'package:trustless/widgets/setParty.dart';
import 'package:trustless/widgets/wrongChain.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'entities/human.dart';
import 'entities/project.dart';
import 'entities/user.dart';
import 'firebase_options.dart';
import 'screens/disputes.dart';
import 'package:provider/provider.dart';
import 'dart:html';
import 'dart:js' as js;

import 'widgets/bubbles.dart';

class OverlayControlNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Hide the overlay when navigating to a new route
    Human().isOverlayVisible=false;
    // Human().botonDeChat.toggleOverlay();
    print("contracting ");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    Human().isOverlayVisible=false;
   print("contracting or something");
  }
}

String? api;
String metamask="https://i.ibb.co/HpmDHg0/metamask.png";
double switchAspect=1.2;
List<Project> projects=[];
List<TTransaction> actions=[];
// List<User> otelezatori=[];
List<User>users=[];
String sourceAddress="";
// int valueInContracts=0;
BigInt nativeEarned=BigInt.zero;
BigInt usdtEarned=BigInt.zero;
// GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// String selectedNetwork='Etherlink Testnet';
ContractFunctions cf=ContractFunctions();
var prelaunchCollection = FirebaseFirestore.instance.collection('prelaunch');
// var voteCollection = FirebaseFirestore.instance.collection('vote');
var statsCollection = FirebaseFirestore.instance.collection('stats');
var projectsCollection;
var transactionsCollection;
var usersCollection;
    void main() async  {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      var apisnap= await statsCollection.doc("system").get();
      if (apisnap.exists){
        api=apisnap.data()!['api'];
      }else{print("could not find system collection;");}
     await persist();
       runApp(
    ChangeNotifierProvider<Human>(
        create: (context) => Human(),
        child: MyApp(),
      ));
      }

  persist()async{
     users=[];projects=[];actions=[];
     projectsCollection=FirebaseFirestore.instance.collection("projects${Human().chain.name}");
      transactionsCollection=FirebaseFirestore.instance.collection("transactions${Human().chain.name}");
      usersCollection=FirebaseFirestore.instance.collection("users${Human().chain.name}");      
      var statsSnapshot = await statsCollection.doc(Human().chain.name).get();
      if (statsSnapshot.exists) {
        sourceAddress=statsSnapshot.data()!['sourceAddress'];
        Human().chainNativeEarnings=statsSnapshot.data()!['native'];
        Human().chainUSDTEarnings=statsSnapshot.data()!['usdt'];
      } else {
        sourceAddress="source_address_not_available_at_the_moment";
      }
      
      print("source address:" +sourceAddress);
      var projectsSnapshot = await projectsCollection.get();
      var transactionsSnapshot = await transactionsCollection.get();
      var usersSnapshot = await usersCollection.get();
      for (var doc in usersSnapshot.docs){
        // nativeEarned = nativeEarned + (doc.data()['nativeEarned'] as int);
        nativeEarned = BigInt.zero;
        print("adding a user");
        List<dynamic> contractor= doc.data()['projectsContracted'];
        List<dynamic> arbiter= doc.data()['projectsArbitrated'];
        List<dynamic> author= doc.data()['projectsAuthored'];
        List<dynamic> backer= doc.data()['projectsBacked'];
        users.add(
          User(address: doc.id.toString(), nativeEarned: doc.data()['nativeEarned'],
          nativeSpent: doc.data()['nativeSpent'],
          usdtEarned: doc.data()['usdtEarned'],
          usdtSpent: doc.data()['usdtSpent'],
          lastActive: (doc.data()['lastActive'] as Timestamp).toDate(),
          projectsContracted: List<String>.from(contractor), 
          projectsArbitrated:  List<String>.from(arbiter),  
          projectsBacked:  List<String>.from(backer),
          name:doc.data()['name'],
          link:doc.data()['link'],
          about:doc.data()['about'],
          projectsAuthored:  List<String>.from(author)
          )
        );
      }

      for(var doc in transactionsSnapshot.docs){ 
        actions.add(TTransaction(
          hash:doc.id.toString(),
          functionName: doc.data()["functionName"],
          params:  doc.data()["params"],
          sender:   doc.data()["sender"],
          contractAddress:doc.data()["contractAddress"],
          time: (doc.data()['time'] as Timestamp).toDate(),
           ));
        }

    for(var doc in projectsSnapshot.docs) {
      Project p =Project(
       isUSDT: doc.data()["isUSDT"],
       name: doc.data()["name"],
       creationDate : (doc.data()['created'] as Timestamp).toDate(),
       description: doc.data()["description"],
       author: doc.data()["author"],
       contractor:doc.data()['contractor'],
       arbiter: doc.data()["arbiter"],
       requirements: doc.data()["specs"],
       repo: doc.data()["repo"],
       status: doc.data()["status"],
       contractAddress: doc.id.toString()
      );
    Map<String, dynamic> fbContributions = doc.data()['contributions'];
    p.contributions = Map<String, String>.from(fbContributions);
    Map<String, dynamic> fbReleasing = doc.data()['contributorsReleasing'];
    p.contributorsReleasing = Map<String, String>.from(fbReleasing);
    Map<String, dynamic> fbDisputing = doc.data()['contributorsDisputing'];
    p.contributorsDisputing = Map<String, String>.from(fbDisputing);
    p.contractAddress=doc.id.toString();
    p.termsHash=doc.data()['termsHash']??"";
    p.hashedFileName=doc.data()['hashedFileName']??"";
    p.arbiterAwardingContractor=doc.data()['arbiterAwardingContractor'];
    p.rulingHash=doc.data()['rulingHash'];
    p.holding=doc.data()['holding'];
    projects.add(p);
    // p.contributions.forEach((key, value) { valueInContracts+=value;});
  }

  // if (projects.length>0) {await createUsers();}
  //   print("greater than zero adding MockTransactions");
  //   var punem= actions.length;
  //   if (punem < mockTansactions.length){
  //     for (int i=0; i< mockTansactions.length - punem; i++){
  //       actions.add(mockTansactions[i]);
  //     }
  // }

  actions.sort((a, b) => b.time.compareTo(a.time));

  await cf.getProjectsCounter();
  // await Human().signIn();
  print("we have this many projects: "+numberOfProjects.toString());

  }

void listenForConsoleInputs() {
  // Listen for the custom event
  window.addEventListener('consoleInput', (event) {
    final CustomEvent customEvent = event as CustomEvent;
    final input = customEvent.detail;
    print('Received input from console: $input');
    // Here, you can call your chat function with the input
    String response = chatFunction(input);
    print(response); // This will log the response back to the console
  });
}


String chatFunction(String prompt) {
  // This function simulates chat interaction. Replace with actual functionality.
  return "Responding to '$prompt'.";
}


class MyApp extends StatelessWidget {
  // Create a global variable for the overlay entry
  OverlayEntry? _overlayEntry;
  
  MyApp({super.key, });
  @override
  Widget build(BuildContext context) {
      if (ethereum==null){
       print("n-are metamask");
        Human().metamask=false;
    }else{
      print("are metamask");
        Human().metamask=true;
    }
    return  MaterialApp(
      navigatorKey: Human().navigatorKey,
      navigatorObservers: [OverlayControlNavigatorObserver()],
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              title: 'Trustless Business',
               theme: lightTheme,
               darkTheme: darkTheme, 
              initialRoute: '/',
            onGenerateRoute: (settings) {
          WidgetBuilder builder;
          if (settings.name == '/') {
            builder = (_) => 
            // BaseScaffold(body: Bubbles(), title: "title",  selectedItem: 0);
            // ProjectDetails(project: projects[0]);
            // Prelaunch();
            // Poll();  
            
            // Scaffold(body: SetParty(project: projects[0]));
            //  BaseScaffold(selectedItem: 0, body: const Users(), title: "Users");
             Human().beta ?  BaseScaffold(
              selectedItem: 0, body: Landing(), title: "Trustless Business") : Prelaunch();
            // BaseScaffold(selectedItem: 1,body: Projects( main: true, capacity: ""), title: "Projects");
          } else if (settings.name!.startsWith('/projects/')) {
            final projectId = settings.name!.replaceFirst('/projects/', '');
            Project? project;
            try {
              project = projects.firstWhere(
            (proj)=>proj.contractAddress == projectId
              );
              
            } catch (e) {
              project = null;
            }
            if (project != null) {
              builder = (context) => ProjectDetails(project: project!);
            } else {
              builder = (context) => const Text("Project not found");
            }
          }
            else if (settings.name == '/chat') {
            builder = (_) => BaseScaffold(selectedItem: 5, title: "Chat" ,
            body:  Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 800
                ),
                
                child: Bubbles(),
              ),
            ), );
            } 
          else if (settings.name == '/users') {
            builder = (_) => BaseScaffold(selectedItem: 3, body: const Users(), title: "Users");
            } else if (settings.name == '/') {
            builder = (_) => BaseScaffold(selectedItem: 0, body: Landing(), title: "Trustless Business");
          } else if (settings.name == '/projects') {
            builder = (_) => BaseScaffold(selectedItem: 1, body: Projects(main:true, capacity: "",), title: "Projects");
          } else {
            // Handle other routes or unknown routes
            builder = (_) =>  BaseScaffold(
              selectedItem: 0,
              title: "Not a valid URL",
              body: const Center(child:Text("This is nothing.", style: TextStyle(fontSize: 40),)),);
          }
        
          // Implementing the crossfade transition
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => builder(context),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
            opacity: animation,
            child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300), // Adjust duration as needed
          );
        }
              // Remove the 'routes' map if all routes are handled in 'onGenerateRoute'
            );
      
  }
}
// class AppState extends ChangeNotifier {
//   bool _ignoreInput = false;
//   bool _showDialog = false; // Add this line

//   bool get ignoreInput => _ignoreInput;
//   bool get showDialog => _showDialog; // Add this getter

//   void setIgnoreInput(bool ignore) {
//     _ignoreInput = ignore;
//     notifyListeners();
//   }

//   void setShowDialog(bool show) { // Add this method
//     _showDialog = show;
//     notifyListeners();
//   }
// }
// ignore: must_be_immutable


class BaseScaffold extends StatefulWidget {
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
// Call the dispose function


  final Widget body;
  final String title;
  late bool isTrustless;
  late  bool isProjects;
  late  bool isChat;
  late bool isDisputes;
  late bool isUsers;
  late bool isProfile;
  int selectedItem;
  
  BaseScaffold({super.key, required this.body, required this.title, 
  required this.selectedItem} ) {
    isTrustless = selectedItem == 0;
    isProjects = selectedItem == 1;
    isDisputes = selectedItem == 2;
    isChat= selectedItem==5;
    isUsers = selectedItem == 3;
    isProfile = selectedItem==4;
  }

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}


class _BaseScaffoldState extends State<BaseScaffold> {
  Color blendColors(Color color1, Color color2, double amount) {
  amount = amount.clamp(0.0, 1.0);
  return Color.lerp(color1, color2, amount)!;
}

  void changeButton(int position) {
    setState(() { 
        widget.isProjects = position == 0;
        widget.isTrustless = position == 1;
        widget.isDisputes = position == 2;
        widget.isUsers = position == 3;
        widget.isChat = position == 5;
    });
      // butonDechat.createElement().state.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
  final List<String> chainNames =[];
   chains.forEach((key, value) {chainNames.add(value.name); });

  // The current selected value of the dropdown
  // String? selectedValue = 'Etherlink Testnet';
     Widget logo=Image.network('https://i.ibb.co/QnyXWBP/bizlogo.png',
   height: widget.isTrustless?33:32,
  );
     Widget logotall=Image.network('https://i.ibb.co/QnyXWBP/bizlogo.png',
   height:12,
  );
    print("height ${MediaQuery.of(context).size.height}");
    Color indicatorColor = Theme.of(context).indicatorColor;
    Color textThemeColor = Theme.of(context).textTheme.bodyLarge!.color!;
    Color blendedColor = blendColors(indicatorColor, textThemeColor, 0.5);
    final TextStyle selectedMenuItem=TextStyle(fontSize: 19, color: blendedColor);
    final TextStyle nonSelectedMenuItem=TextStyle(fontSize: 16, color: textThemeColor);
    // final themeNotifier = Provider.of<ThemeNotifier>(context);

    List<Widget>buttall=[
 
    ];
    List<Widget>botoane=[
            Opacity(
              opacity: widget.isTrustless?0.85:0.7,
              child: SizedBox(
                width:170,
                child: TextButton(onPressed: 
                (){
                   Navigator.pushNamed(context, '/');
                 changeButton(1);
                            }, child:  logo
                ),
              ),
            ),const SizedBox(width: 35),
            TextButton(onPressed: (){ 
             changeButton(0);
              Navigator.of(context).pushNamed("/projects");
              }, child: 
            SizedBox(
              width:140,
              child: Center(
                child: Opacity(
                  opacity: widget.isProjects?1:0.6,
                  child: Row(children: [
                    Icon(Icons.local_activity,size:30, color:widget.isProjects?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                    const SizedBox(width: 8),
                    Text("PROJECTS", style: widget.isProjects?selectedMenuItem:nonSelectedMenuItem)
                  ],),
                ),
              ),
            )
            ),
            const SizedBox(width: 10),
               Center(
                child: SizedBox( width:148,
                  child: TextButton(onPressed: (){
                  changeButton(3);
                   Navigator.of(context).pushNamed("/users");
                  }, child: 
                            Opacity(
                  opacity: widget.isUsers?1:0.6,
                  child: Row(children: [
                    Icon(Icons.people_alt_outlined,size:33,color:widget.isUsers?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                    const SizedBox(width: 8),
                    Text("USERS", style: widget.isUsers?selectedMenuItem:nonSelectedMenuItem)
                  ],),
                            )
                            ),
                ),
              ), 
          ];
          var human = Provider.of<Human>(context);
          final double scaleFactor = MediaQuery.of(context).size.width * MediaQuery.of(context).size.height < 1600000 ? 0.8 : 1.0;
         
        // final double scaleFactor = MediaQuery.of(context).size.width * MediaQuery.of(context).size.height < 1400000 ? 0.8 : 1.0;
          
          // Apply scale factor to the entire Scaffold
          return Scaffold(
            key:widget._scaffoldKey,

          endDrawer: Drawer(
            semanticLabel: "AI Helper",
            elevation: 10,
            width: 600,
            child: Bubbles()
            
          ),
          // floatingActionButton:ExpandableFAB(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.onError,
            child: const Icon(Icons.contact_support, size: 57,),
            onPressed: (){
           widget. _scaffoldKey.currentState?.openEndDrawer();
          }),
          appBar: AppBar(
           toolbarHeight: 44,
           elevation: 1.8,
           automaticallyImplyLeading: MediaQuery.of(context).size.aspectRatio < switchAspect,
           title: 
           MediaQuery.of(context).size.aspectRatio >= switchAspect?
           Row(
            crossAxisAlignment: CrossAxisAlignment.center,
           children:
           [...botoane,]
           ):  null,
          
           actions: <Widget>[
           
           MediaQuery.of(context).size.aspectRatio > switchAspect?
              Container(
                height: 9,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                                border: Border.all(width: 0.1 , color: Theme.of(context).textTheme.bodyLarge!.color! ),
                                color: Theme.of(context).indicatorColor.withOpacity(0.1)
                              ),
              child: Row(
                children: [
                  Icon(Icons.connect_without_contact_sharp, size: 29,
                  color: Theme.of(context).indicatorColor,
                  ),
                  const SizedBox(width: 12),
                  Text( human.chain.name
                  ,style: GoogleFonts.changa(
                    color: Theme.of(context).indicatorColor,
                    fontSize: 19),
                  )
                ],
              )
             )
             :const Text(""),
             const SizedBox(width: 35 ),
          const SizedBox(width:200, child: WalletBTN()),
           const SizedBox(width: 30),
          
           
           ],
           
                 ),
                 body: ListView(
             children: [
             Human().busy?SizedBox(
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).canvasColor,
                  color: Theme.of(context).indicatorColor,
                )):const SizedBox(height: 0),
               human.wrongChain?const WrongChain():
               widget.body,
             ],
           )
           ,
          drawer: 
          MediaQuery.of(context).size.aspectRatio <= switchAspect 
          ?
          Drawer(
           child: ListView(
           padding: EdgeInsets.zero,
           children: <Widget>[
             DrawerHeader(
               child: Theme.of(context).brightness==Brightness.light?
           SizedBox(
           width: 50,
           child: ColorFiltered(
                   colorFilter: const ColorFilter.matrix([
                     -1.0, 0.0, 0.0, 0.0, 255.0, // red
                     0.0, -1.0, 0.0, 0.0, 255.0, // green
                     0.0, 0.0, -1.0, 0.0, 255.0, // blue
                     0.0, 0.0, 0.0, 1.0, 0.0, // alpha
                   ]),
                   child:logotall,
                 ),
                 )
                 :
                 SizedBox(
           width: 50,
           child: logotall),
             ),
            ...buttall, 
             Padding(
               padding: const EdgeInsets.all(61.0),
               child: SizedBox(
                 width: 60,
                 child: DropdownButton<String>(
                         value: human.chain.name,
                         focusColor: Colors.transparent,
                         items: chainNames.map((String value) {
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value),
                 );
                         }).toList(),
                         onChanged: (String? newValue) {
                  Chain? foundChain;
                  for (Chain cgn in chains.values){
                    if (newValue==cgn.name){
                    foundChain=cgn;
                  }}
              
              foundChain ??= Chain(id: 0, name: 'N/A', nativeSymbol: '', decimals: 0, rpcNode: '');
               setState(() {
                 human.chain=foundChain!;
               });
                   },
                 ),
                 ),
               ),
             ],
           ),
           ):null,
          );
     
  }
}

class WalletBTN extends StatefulWidget {
  const WalletBTN({super.key});

  @override
  State<WalletBTN> createState() => _WalletBTNState();
}

class _WalletBTNState extends State<WalletBTN> {
 bool _isConnecting=false;
  void initState() {
    super.initState();
    // Load existing address
   
  }



  @override
  Widget build(BuildContext context) {
    // Access Human instance using Provider
    var human = Provider.of<Human>(context);

    if (human.busy) {
      return const SizedBox(
        width: 160,
        height: 7,
        child: Center(
          child: LinearProgressIndicator(
            minHeight: 2,
          ),
        ),
      );
    }
    

    return TextButton(
      onPressed: () async {
        if (!human.metamask) {
          showDialog(
            context: context,
            builder: (context) {
              return  AlertDialog(
                content: Container(
                  height:260,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text("You need the a web3 wallet to sign into the app.",style: TextStyle(fontFamily: "Roboto Mono", fontSize: 16),),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(metamask,height: 100,),
                          const Icon(Icons.arrow_right_alt, size: 40,),
                          const SizedBox(width: 14,),
                           Image.network(
                              "https://i.ibb.co/sFqQxYP/Icon-maskable-192.png",
                              height: 70),
                            const SizedBox(width: 13,),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      const Text("Download it from",style: TextStyle(fontFamily: "Roboto Mono", fontSize: 16),),
                      const SizedBox(height: 10,),
                      TextButton(
                        onPressed: (){
                          launch("https://metamask.io/");
                        },
                        child: const Text("https://metamask.io/",style: TextStyle(fontFamily: "Roboto Mono", fontSize: 16),)),
                        
                    ],
                  ),
                
                ),

              );
            },
          );
        } else {
          // Since we're in a StatelessWidget, no need to call setState
        if ( human.address == null)
        {
        setState(() {  
        human.busy=true;
        });
         await human.signIn(); 
        setState(() {
          human.busy=false;
        });
        }
        else{
           Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) =>
            BaseScaffold(
              selectedItem: 0, body: Profile(), title: "Profile")
            )
          )
      );
        }
        }
      },
      child: SizedBox(
        width: 160,
        child: Center(
          child: human.address == null
              ? Row(
                  children: [
                    const SizedBox(width: 4),
                    Image.network(metamask, height: 27), // Adjust the URL
                    const SizedBox(width: 9),
                    const Text("Connect Wallet"),
                  ],
                )
              : Row(
                children: [
                   FutureBuilder<Uint8List>(
                        future: generateAvatarAsync(hashString(human.address!)),  // Make your generateAvatar function return Future<Uint8List>
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: 40.0,
                              height: 40.0,
                              color: Colors.grey,
                            );
                          } else if (snapshot.hasData) {
                            print("generating");
                            return Image.memory(snapshot.data!);
                          } else {
                            return Container(
                              width: 40.0,
                              height: 40.0,
                              color: const Color.fromARGB(255, 116, 116, 116),  // Error color
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                  Text(getShortAddress(human.address!)),
                ],
              ),
        ),
      ),
    );
  }
}




  const Color _lightThemeHighlightColor = Color.fromRGBO(124, 112, 93, 1); // For light theme
  const Color _darkThemeHighlightColor = Color.fromARGB(255, 212, 195, 140); // For dark theme

  // Light Theme
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    canvasColor:const Color.fromARGB(255, 235, 235, 235),
    primaryColor: const Color.fromARGB(255, 155, 155, 155), // Main background color
    accentColor: _lightThemeHighlightColor, // Primary accent/highlight color
    colorScheme:const  ColorScheme.light(
      primary: _lightThemeHighlightColor,
      onPrimary: Colors.black, // Text on primary color
      secondary: Colors.black, // Icon and other secondary elements
      onSecondary: _lightThemeHighlightColor,
      background: Color.fromARGB(255, 99, 99, 99),
      
      onBackground: Colors.black,
      surface: Color.fromARGB(255, 39, 39, 39), // Card and dialog backgrounds
      onSurface: Color.fromARGB(255, 54, 54, 54), // Text on surface
      error: Colors.red,
      onError: Color.fromARGB(255, 228, 228, 228),
      brightness: Brightness.light,
    ),

    buttonTheme:const  ButtonThemeData(
      buttonColor: _lightThemeHighlightColor, // Button background color
      hoverColor: Colors.white,
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: const Color.fromARGB(255, 20, 20, 20), // Ensuring text color is black and not the highlight color
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 226, 226, 226),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    inputDecorationTheme:const  InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightThemeHighlightColor),
      ),
    ),
    fontFamily: 'CascadiaCode',
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[850], // Main background color
    accentColor: _darkThemeHighlightColor, // Primary accent/highlight color
    colorScheme: const ColorScheme.dark(
      primary: _darkThemeHighlightColor,
      onPrimary: Colors.white, // Text on primary color
      secondary: Colors.white, // Icon and other secondary elements
      onSecondary: _darkThemeHighlightColor,
      background: Color.fromARGB(255, 53, 53, 53),
      onBackground: Colors.white,
      surface: Color.fromARGB(255, 37, 37, 37), // Card and dialog backgrounds
      onSurface: Colors.white, // Text on surface
      error: Colors.red,
      onError: Color.fromARGB(255, 31, 31, 31),
      brightness: Brightness.dark,
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white, // Ensuring text color is white and not the highlight color
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 66, 66, 66),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkThemeHighlightColor),
      ),
    ),
    fontFamily: 'CascadiaCode',
  );

 








