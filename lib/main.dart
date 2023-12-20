import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:provider/provider.dart';
import 'package:trustless/screens/projects.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/projectDetails.dart';
import 'entities/human.dart';
import 'entities/project.dart';
import 'firebase_options.dart';


List<Project> projects=[];

var projectsCollection = FirebaseFirestore.instance.collection('projects');
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      var querySnapshot = await projectsCollection.get();
  // Iterate through the documents and print their data
  for (var doc in querySnapshot.docs) {
    print("doc "+doc.data().toString());
      Project p =Project(
       isUSDT: doc.data()["isUSDT"],
       name: doc.data()["name"],
       creationDate: DateTime.now(),
       description: doc.data()["description"],
       client: doc.data()["client"],
       contractor:doc.data()['contractor'],
       arbiter: doc.data()["arbiter"],
       requirements: doc.data()["specs"],
       repo: doc.data()["repo"],
       status: doc.data()["status"],
       contractAddress: doc.id.toString()
      );
    p.contractAddress=doc.id.toString();
    p.termsHash=doc.data()['termsHash'];
    p.hashedFileName=doc.data()['hashedFilename'];
    projects.add(p);
  }
  print("lungimea la proecte "+projects.length.toString());
 
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
          initialRoute: '/projects/KT1662nulp5e3kddtb64quu2sfzekx5eou2k',
    onGenerateRoute: (settings) {
  WidgetBuilder builder;

  if (settings.name == '/') {
    builder = (_) => BaseScaffold(
      body: Projects(), 
      title: "Projects");
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
    builder = (_) => BaseScaffold(body: Trials(), title: "Trials");
  } else {
    // Handle other routes or unknown routes
    builder = (_) =>  BaseScaffold(
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



class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  BaseScaffold({required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 42,
        elevation: 0.8,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            TextButton(onPressed: 
            (){
               Navigator.pushNamed(context, '/');
            }, child: 
            Image.asset(
             "trustless_dark.png",
            height: 27,)
            ),SizedBox(width: MediaQuery.of(context).size.width/13),
            TextButton(onPressed: (){ Navigator.of(context).pushNamed("/");}, child: 
            Row(children: const [
              Icon(Icons.local_activity,size:30),
              SizedBox(width: 8),
              Text("PROJECTS", style: TextStyle(fontSize: 17),)
            ],)
            ),
            const SizedBox(width: 40),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamed("/trials");
              }, child: 
            Row(children:  [
       
             Image.asset('assets/scale2.png', height:30, color: Theme.of(context).textTheme.bodyLarge!.color,),
              SizedBox(width: 8),
              Text("DISPUTES", style: TextStyle(fontSize: 17),)
            ],)
            ),  
            const SizedBox(width: 40),
              TextButton(onPressed: (){}, child: 
            Row(children:const [
              Icon(Icons.gavel_sharp,size:33),
              SizedBox(width: 8),
              Text("ARBITERS", style: TextStyle(fontSize: 17),)
            ],)
            )
          ],
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
      body: body,
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
    colorScheme: ColorScheme.light(
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
    buttonTheme: ButtonThemeData(
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
    inputDecorationTheme: InputDecorationTheme(
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
    colorScheme: ColorScheme.dark(
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








class Trials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Trials'));
  }
}

class Arbiters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Arbiters'));
  }
}

