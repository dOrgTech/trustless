import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:provider/provider.dart';
import 'package:trustless/screens/landing.dart';
import 'package:trustless/screens/prelaunch.dart';
import 'package:trustless/screens/projects.dart';
import 'package:trustless/screens/users.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/projectDetails.dart';
import 'entities/human.dart';
import 'entities/project.dart';
import 'firebase_options.dart';
import 'screens/disputes.dart';


List<Project> projects=[];
var projectsCollection = FirebaseFirestore.instance.collection('projects');
var prelaunchCollection = FirebaseFirestore.instance.collection('prelaunch');
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      var querySnapshot = await projectsCollection.get();
  // Iterate through the documents and print their data
  for (var doc in querySnapshot.docs) {
      Project p =Project(
       isUSDT: doc.data()["isUSDT"],
       name: doc.data()["name"],
       creationDate : (doc.data()['created'] as Timestamp).toDate(),
       description: doc.data()["description"],
       author: doc.data()["client"],
       contractor:doc.data()['contractor'],
       arbiter: doc.data()["arbiter"],
       requirements: doc.data()["specs"],
       repo: doc.data()["repo"],
       status: doc.data()["status"],
       contractAddress: doc.id.toString()
      );
    p.contractAddress=doc.id.toString();
    p.termsHash=doc.data()['termsHash']??"";
    p.hashedFileName=doc.data()['hashedFileName']??"";
    projects.add(p);
  }
  print("lungimea la proecte "+projects.length.toString());
  // print("primex creation date ${projects[0].creationDate.toString()}");
    runApp( MyApp());
    }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //   if (ethereum==null){
    //    print("n-are metamask");
    //     Human().metamask=false;
    // }else{
    //   print("are metamask");
    //     Human().metamask=true;
    // }
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
    // ProjectDetails(project: projects[0])
    // Prelaunch()
      BaseScaffold(
        selectedItem: 1,
      body: Projects(), 
      title: "Projects")
      ;
  } else if (settings.name!.startsWith('/projects/')) {
    final projectId = settings.name!.replaceFirst('/projects/', '');
    Project? project;
    try {
      project = projects.firstWhere(
        (proj)=>proj.contractAddress == projectId
      );
      print("project "+project.toString());
    } catch (e) {
      project = null;
    }
    if (project != null) {
      builder = (context) => ProjectDetails(project: project!);
    } else {
      builder = (context) => const Text("Project not found");
    }
  } else if (settings.name == '/trials') {
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
    Color indicatorColor = Theme.of(context).indicatorColor;
    Color textThemeColor = Theme.of(context).textTheme.bodyLarge!.color!;
    Color blendedColor = blendColors(indicatorColor, textThemeColor, 0.5);
    final TextStyle? selectedMenuItem=TextStyle(fontSize: 19, color: blendedColor);
    final TextStyle? nonSelectedMenuItem=TextStyle(fontSize: 16, color: textThemeColor);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
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
                Image.asset(
                 "trustless_dark.png",
                height: widget.isTrustless?27:26,)
                ),
              ),
            ),SizedBox(width: MediaQuery.of(context).size.width/13),
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
            const SizedBox(width: 30),
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
             const SizedBox(width: 33),
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 42,
        elevation: 1.8,
        automaticallyImplyLeading: false,
        title: Row(
          children: botoane
        ),

        actions: <Widget>[
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
            width: 180,
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
    if (Human().metamask==false){
      showDialog(context: context, builder: (context){return 
      const AlertDialog(
        content: Text("Metamask not detected.")
      );
      });
    }
    setState((){
      _isConnecting=true;
    });

      await Human().signIn();
    setState((){
      _isConnecting=false;
    });

   }, child: 
   Text(
    Human().address==null?
    "Connect Wallet":Human().address!))
    :
   SizedBox(
      width: 150,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          isExpanded: true,
          value: getShortAddress(Human().address!.toString()),
          icon: const Icon(Icons.arrow_drop_down),
          hint: Text(shortenString(Human().address!.toString())),
          onChanged: (value) {
            // Implement actions based on dropdown selection
          },
          items: [
            DropdownMenuItem(
              value: getShortAddress(Human().address!.toString()),
              child: Text(shortenString(Human().address!.toString())),
            ),
            const DropdownMenuItem(
              value: 'Profile',
              child: Text('Profile'),
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

  static const Color _lightThemeHighlightColor = Color.fromARGB(255, 100, 87, 68); // For light theme
  static const Color _darkThemeHighlightColor = Color.fromARGB(255, 175, 161, 113); // For dark theme

  // Light Theme
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(255, 155, 155, 155), // Main background color
    accentColor: _lightThemeHighlightColor, // Primary accent/highlight color
    colorScheme:const  ColorScheme.light(
      primary: _lightThemeHighlightColor,
      onPrimary: Colors.black, // Text on primary color
      secondary: Colors.black, // Icon and other secondary elements
      onSecondary: _lightThemeHighlightColor,
      background: Color.fromARGB(255, 153, 153, 153),
      onBackground: Colors.black,
      surface: Color.fromARGB(255, 46, 46, 46), // Card and dialog backgrounds
      onSurface: Colors.black, // Text on surface
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    buttonTheme:const  ButtonThemeData(
      buttonColor: _lightThemeHighlightColor, // Button background color
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.black, // Ensuring text color is black and not the highlight color
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 199, 199, 199),
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









