import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:provider/provider.dart';
import 'package:trustless/entities/contractFunctions.dart';
import 'package:trustless/screens/landing.dart';
import 'package:trustless/screens/poll.dart';
import 'package:trustless/screens/prelaunch.dart';
import 'package:trustless/screens/profile.dart';
import 'package:trustless/screens/projects.dart';
import 'package:trustless/screens/users.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/projectDetails.dart';
import 'package:web3dart/web3dart.dart';
import 'entities/human.dart';
import 'entities/project.dart';
import 'firebase_options.dart';
import 'screens/disputes.dart';

double switchAspect=1.2;
List<Project> projects=[];
List<Voter> voters=[];
String sourceAddress="";
int valueInContracts=0;
int usdtStored=0;
int xtzStored=0;
int totalXTZpaid=0;
int totalUSDTpaid=0;
// String selectedNetwork='Etherlink Testnet';
ContractFunctions cf=ContractFunctions();
var projectsGoerli = FirebaseFirestore.instance.collection('projectsGoerli');
var prelaunchCollection = FirebaseFirestore.instance.collection('prelaunch');
var voteCollection = FirebaseFirestore.instance.collection('vote');
var statsCollection = FirebaseFirestore.instance.collection('stats');
var projectsCollection;

    void main() async  {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      projectsCollection=FirebaseFirestore.instance.collection("projects${Human().chain.name}");
      var statsSnapshot = await statsCollection.doc(Human().chain.name).get();
      if (statsSnapshot.exists) {
          sourceAddress=statsSnapshot.data()!['sourceAddress'];
      } else {
        sourceAddress="source_address_not_available_at_the_moment";
      }
      print("source address:" +sourceAddress);
      var querySnapshot = await projectsCollection.get();
  // Iterate through the documents and print their data
    for(var doc in querySnapshot.docs) {
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
    p.contributions = Map<String, int>.from(fbContributions);
    Map<String, dynamic> fbReleasing = doc.data()['contributorsReleasing'];
    p.contributorsReleasing = Map<String, int>.from(fbReleasing);
    Map<String, dynamic> fbDisputing = doc.data()['contributorsDisputing'];
    p.contributorsDisputing = Map<String, int>.from(fbDisputing);
    p.contractAddress=doc.id.toString();
    p.termsHash=doc.data()['termsHash']??"";
    p.hashedFileName=doc.data()['hashedFileName']??"";
    p.arbiterAwardingContractor=doc.data()['arbiterAwardingContractor'];
    projects.add(p);
    p.contributions.forEach((key, value) { valueInContracts+=value;});
  }

  
  await cf.getProjectsCounter();
  print("we have this many projects: "+numberOfProjects.toString());
      runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ));
    }

class MyApp extends StatelessWidget {
  // Create a global variable for the overlay entry
  OverlayEntry? _overlayEntry;
  @override
  Widget build(BuildContext context) {
      if (ethereum==null){
       print("n-are metamask");
        Human().metamask=false;
    }else{
      print("are metamask");
        Human().metamask=true;
    }
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Trustless Business',
              theme: theme.getTheme(),
              initialRoute: '/',
            onGenerateRoute: (settings) {
          WidgetBuilder builder;
          if (settings.name == '/') {
            builder = (_) => 
            // ProjectDetails(project: projects[0]);
            Prelaunch();
            // Poll();
            //  BaseScaffold(selectedItem: 0, body: Profile(), title: "Profile");
            // BaseScaffold(selectedItem: 1,body: Projects(), title: "Projects");
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
          else if (settings.name == '/trials') {
            builder = (_) => BaseScaffold(selectedItem: 2, body: Trials(), title: "Trials");
            } else if (settings.name == '/stats') {
            builder = (_) => BaseScaffold(selectedItem: 0, body: Landing(), title: "Stats");
          } else if (settings.name == '/users') {
            builder = (_) => BaseScaffold(selectedItem: 3,body: Users(), title: "Users");
          } else {
            // Handle other routes or unknown routes
            builder = (_) =>  BaseScaffold(
              selectedItem: 0,
              title: "Not a valid URL",
              body: Center(child:Text("This is nothing.", style: TextStyle(fontSize: 40),)),);
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
            ),
      ),
    );
  }
}
class AppState extends ChangeNotifier {
  bool _ignoreInput = false;
  bool _showDialog = false; // Add this line

  bool get ignoreInput => _ignoreInput;
  bool get showDialog => _showDialog; // Add this getter

  void setIgnoreInput(bool ignore) {
    _ignoreInput = ignore;
    notifyListeners();
  }

  void setShowDialog(bool show) { // Add this method
    _showDialog = show;
    notifyListeners();
  }
}

class BaseScaffold extends StatefulWidget {
 
  final Widget body;
  final String title;
  late bool isTrustless;
  late  bool isProjects;
  late bool isDisputes;
  late bool isUsers;
  int selectedItem;
  
  BaseScaffold({required this.body, required this.title,
  required this.selectedItem} ) {
    isTrustless = selectedItem == 0;
    isProjects = selectedItem == 1;
    isDisputes = selectedItem == 2;
    isUsers = selectedItem == 3;
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
        widget.isTrustless = position == 0;
        widget.isProjects = position == 1;
        widget.isDisputes = position == 2;
        widget.isUsers = position == 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final chainNames = chains.map((chain) => chain.name).toList();

      final List<String> chainNames = ['Goerli','Etherlink-Testnet'];

  // The current selected value of the dropdown
  // String? selectedValue = 'Etherlink Testnet';
     Widget logo=Image.network('https://i.ibb.co/Tvkq0Mz/trlogomic.png',
   height: widget.isTrustless?27:26,
  );
     Widget logotall=Image.network('https://i.ibb.co/Tvkq0Mz/trlogomic.png',
   height:12,
  );
    print("height ${MediaQuery.of(context).size.height}");
    Color indicatorColor = Theme.of(context).indicatorColor;
    Color textThemeColor = Theme.of(context).textTheme.bodyLarge!.color!;
    Color blendedColor = blendColors(indicatorColor, textThemeColor, 0.5);
    final TextStyle? selectedMenuItem=TextStyle(fontSize: 19, color: blendedColor);
    final TextStyle? nonSelectedMenuItem=TextStyle(fontSize: 16, color: textThemeColor);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    List<Widget>buttall=[
  Padding(
    padding: const EdgeInsets.all(18.0),
    child: SizedBox(
                width:150,
                child: Center(
                  child: Opacity(
                    opacity: widget.isProjects?1:0.6,
                    child: Row(children: [
                      SizedBox(width: 5),
                      Icon(Icons.local_activity,size:30, color:widget.isProjects?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          changeButton(1);
                          Navigator.of(context).pushNamed("/");
                        },
                        child: Text("PROJECTS", style: widget.isProjects?selectedMenuItem:nonSelectedMenuItem))
                    ],),
                  ),
                ),
              ),
  ),
    Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox( width:145,
                  child: Center(
                    child: Opacity(
                      opacity: widget.isDisputes?1:0.6,
                      child: TextButton(onPressed: (){
                        changeButton(2);
                        Navigator.of(context).pushNamed("/trials");
                      }, child: 
                            Row(children:  [
                              Image.asset('assets/scale2.png', height:30, color:widget.isDisputes?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                      SizedBox(width: 8),
                      Text("DISPUTES", style: widget.isDisputes?selectedMenuItem:nonSelectedMenuItem,)
                                ],)
                                ),
                    ),
                  ),
                ),
    ),  
   Padding(
     padding: const EdgeInsets.all(18.0),
     child: SizedBox( width:145,
                    child: TextButton(onPressed: (){
                    changeButton(3);
                     Navigator.of(context).pushNamed("/users");
                    }, child: 
                              Opacity(
                    opacity: widget.isUsers?1:0.6,
                    child: Row(children: [
                      Icon(Icons.gavel_sharp,size:33,color:widget.isUsers?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                      SizedBox(width: 8),
                      Text("ARBITERS", style: widget.isUsers?selectedMenuItem:nonSelectedMenuItem)
                    ],),
                              )
                              ),
                  ),
   ),

    ];

    List<Widget> botoane=[
            Opacity(
              opacity: widget.isTrustless?1:0.6,
              child: SizedBox(
                width:200,
                child: TextButton(onPressed: 
                (){
                   Navigator.pushNamed(context, '/stats');
                 changeButton(0);
                }, child: 
      Theme.of(context).brightness==Brightness.light?
      ColorFiltered(
              colorFilter: ColorFilter.matrix([
                -1.0, 0.0, 0.0, 0.0, 255.0, // red
                0.0, -1.0, 0.0, 0.0, 255.0, // green
                0.0, 0.0, -1.0, 0.0, 255.0, // blue
                0.0, 0.0, 0.0, 1.0, 0.0, // alpha
              ]),
              child:logo,
            ):logo
                ),
              ),
            ),SizedBox(width: 35),
            TextButton(onPressed: (){ 
             changeButton(1);
              Navigator.of(context).pushNamed("/");
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
              SizedBox( width:145,
                child: Center(
                  child: Opacity(
                    opacity: widget.isDisputes?1:0.6,
                    child: TextButton(onPressed: (){
                      changeButton(2);
                      Navigator.of(context).pushNamed("/trials");
                    }, child: 
                              Row(children:  [
                               Image.asset('assets/scale2.png', height:30, color:widget.isDisputes?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                    SizedBox(width: 8),
                    Text("DISPUTES", style: widget.isDisputes?selectedMenuItem:nonSelectedMenuItem,)
                              ],)
                              ),
                  ),
                ),
              ),  
             const SizedBox(width: 19),
              Center(
                child: SizedBox( width:148,
                  child: TextButton(onPressed: (){
                  changeButton(3);
                   Navigator.of(context).pushNamed("/users");
                  }, child: 
                            Opacity(
                  opacity: widget.isUsers?1:0.6,
                  child: Row(children: [
                    Icon(Icons.gavel_sharp,size:33,color:widget.isUsers?Theme.of(context).indicatorColor:Theme.of(context).textTheme.bodyLarge!.color!),
                    SizedBox(width: 8),
                    Text("ARBITERS", style: widget.isUsers?selectedMenuItem:nonSelectedMenuItem)
                  ],),
                            )
                            ),
                ),
              )
          ];
    return   Scaffold(
           appBar: AppBar(
         toolbarHeight: 42,
         elevation: 1.8,
         automaticallyImplyLeading: MediaQuery.of(context).size.aspectRatio < switchAspect,
         title: 
         MediaQuery.of(context).size.aspectRatio >= switchAspect?
         Row(
           children:
         [ 
            ...botoane,]
         ):  null,
          
         actions: <Widget>[
           
           MediaQuery.of(context).size.aspectRatio > switchAspect?
              Padding(
               padding: const EdgeInsets.only(top:0.0),
               child: DropdownButton<String>(
                       value: Human().chain.name,
                       focusColor: Colors.transparent,
                       items: chainNames.map((String value) {
               return DropdownMenuItem<String>(
                 value: value,
                 child: Text(value),
               );
                       }).toList(),
                       onChanged: (String? newValue) {
              // var foundChain = chains.firstWhere((chain) => chain.name ==newValue);
               setState(() {
                 Human().chain=chains[0];
               });
                       },
                     ),
             ):Text(""),
             
             const SizedBox(width: 20 ),
           const WalletBTN(),
           const SizedBox(width: 30),
          
          Switch(
             value: themeNotifier.isDarkMode,
             onChanged: (value) {
               themeNotifier.toggleTheme();
             },
           ),
           const SizedBox(width: 20)
         ],
         
       ),
       body: widget.body,
          drawer: 
          MediaQuery.of(context).size.aspectRatio <= switchAspect?
          Drawer(
         child: ListView(
           padding: EdgeInsets.zero,
           children: <Widget>[
             DrawerHeader(
               child: Theme.of(context).brightness==Brightness.light?
         SizedBox(
           width: 50,
           child: ColorFiltered(
                   colorFilter: ColorFilter.matrix([
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
                         value: Human().chain.name,
                         focusColor: Colors.transparent,
                         items: chainNames.map((String value) {
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value),
                 );
                         }).toList(),
                         onChanged: (String? newValue) {

                  var foundChain = chains.firstWhere((chain) => chain.name ==newValue);
               setState(() {
                 Human().chain=foundChain;
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
    if (_isConnecting) {
          return const SizedBox(
            width: 160,
            height: 7,
            child: Center(
              child: LinearProgressIndicator(
                  minHeight: 2,
                // backgroundColor: Colors.black54,
              ),
            ),
          );
        }
   return 

   Human().address==null?
   
   TextButton(onPressed: ()async{
    // if (Human().metamask==false){
      
    //   showDialog(context: context, builder: (context){return 
    //   const AlertDialog(
    //     content: Text("Metamask not detected.")
    //   );
    //   });
    // }
    setState((){
      _isConnecting=true;
    });

      await Human().signIn();
    setState((){
      _isConnecting=false;
    });
            

   }, child: 
   SizedBox(
    width: 160,
     child: Center(
       child: Text(
        Human().address==null?
        "Connect Wallet":Human().address!),
     ),
   ))
    :
   SizedBox(
      width: 160,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          isExpanded: true,
          value: getShortAddress(Human().address!.toString()),
          icon: const Icon(Icons.arrow_drop_down),
          hint: Text(shortenString(Human().address!.toString())),
          onChanged: (value) {
            // Implement actions based on dropdown selection
            if (value == 'Profile') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) =>
            BaseScaffold(selectedItem: 0, body: Profile(), title: "Profile")
          )
        )
      );
    }
          },
          items: [
            DropdownMenuItem(
              value: getShortAddress(Human().address!.toString()),
              child: Text(shortenString(Human().address!.toString())),
            ),
            DropdownMenuItem(
              value: 'Profile',
              child: const Text('Profile'),
            
            ),
            const DropdownMenuItem(
              value: 'Switch Address',
              child: Text('Switch Address'),
            ),
            const DropdownMenuItem(
              value: 'Disconnect',
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
   }
 }

// import 'package:flutter/material.dart';




class ThemeNotifier with ChangeNotifier {
  late ThemeData _themeData;

  static const Color _lightThemeHighlightColor = Color.fromARGB(255, 124, 112, 93); // For light theme
  static const Color _darkThemeHighlightColor = Color.fromARGB(255, 212, 195, 140); // For dark theme

  // Light Theme
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    canvasColor:Color.fromARGB(255, 235, 235, 235),
    primaryColor: Color.fromARGB(255, 155, 155, 155), // Main background color
    accentColor: _lightThemeHighlightColor, // Primary accent/highlight color
    colorScheme:const  ColorScheme.light(
      primary: _lightThemeHighlightColor,
      onPrimary: Colors.black, // Text on primary color
      secondary: Colors.black, // Icon and other secondary elements
      onSecondary: _lightThemeHighlightColor,
      background: Color.fromARGB(255, 99, 99, 99),
      
      onBackground: Colors.black,
      surface: Color.fromARGB(255, 39, 39, 39), // Card and dialog backgrounds
      onSurface: Color.fromARGB(255, 211, 211, 211), // Text on surface
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),

    buttonTheme:const  ButtonThemeData(
      buttonColor: _lightThemeHighlightColor, // Button background color
      hoverColor: Colors.white,
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Color.fromARGB(255, 20, 20, 20), // Ensuring text color is black and not the highlight color
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
  final ThemeData _darkTheme = ThemeData(
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
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white, // Ensuring text color is white and not the highlight color
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 66, 66, 66),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkThemeHighlightColor),
      ),
    ),
    fontFamily: 'CascadiaCode',
  );

  ThemeNotifier({bool isDarkMode = true}) {
    _themeData = isDarkMode ? _darkTheme: _lightTheme;
  }

  ThemeData getTheme() => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.dark ? _lightTheme : _darkTheme;
    notifyListeners();
  }

  bool get isDarkMode => _themeData.brightness == Brightness.dark;
}









