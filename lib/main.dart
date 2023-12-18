import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
       arbiter: doc.data()["arbiter"],
       requirements: doc.data()["specs"],
       terms: doc.data()["specs"],
       status: doc.data()["status"],

      );
    p.contractAddress=doc.id.toString();
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
          initialRoute: '/',
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
        (proj) => proj.contractAddress == projectId,
      );
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
        toolbarHeight: 38,
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
              Icon(Icons.local_activity),
              SizedBox(width: 8),
              Text("PROJECTS", style: TextStyle(fontSize: 19),)
            ],)
            ),
            const SizedBox(width: 40),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamed("/trials");
              }, child: 
            Row(children: const [
              Icon(Icons.gavel_sharp),
              SizedBox(width: 8),
              Text("TRIALS", style: TextStyle(fontSize: 19),)
            ],)
            ),  
            const SizedBox(width: 40),
              TextButton(onPressed: (){}, child: 
            Row(children:const [
              Icon(Icons.person_search),
              SizedBox(width: 8),
              Text("ARBITERS", style: TextStyle(fontSize: 19),)
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
                backgroundColor: Colors.black54,
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

class ThemeNotifier with ChangeNotifier {
  late ThemeData _themeData;
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    highlightColor: const Color.fromARGB(255, 43, 43, 43),
    indicatorColor: const Color.fromARGB(255, 68, 68, 68),
    hoverColor: const Color.fromARGB(255, 221, 221, 221),
    accentColor: const Color.fromARGB(255, 190, 190, 190),
    primaryColor: const Color.fromARGB(255, 56, 56, 56),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        onSurface:  Colors.white,
        primary: const Color.fromARGB(255, 59, 59, 59), // Set your desired color for light theme
      ),
    ),
    secondaryHeaderColor: const Color.fromARGB(255, 78, 78, 78),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
    ),
    fontFamily: 'CascadiaCode', // Set default font here
    // Add other light theme customizations
  );
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 194, 194, 194),
    colorScheme: const ColorScheme.dark().copyWith(
    secondary: Colors.grey, // Replace with your desired color
    ),
    indicatorColor: const Color.fromARGB(255, 172, 172, 172),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color.fromARGB(255, 145, 145, 145), // Set your desired color for dark theme
    ),
    splashColor: const Color.fromARGB(255, 37, 37, 37),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: const Color.fromARGB(255, 212, 212, 212), // Set your desired color for light theme
      ),
    ),
    secondaryHeaderColor: const Color.fromARGB(255, 51, 51, 51),
        accentColor: const Color(0xff3bffdb),
        dividerColor: createMaterialColor(const Color(0xffcfc099)),
    hintColor: Colors.white70,
    buttonColor: Colors.grey,
    focusColor: Colors.grey,
    highlightColor: const Color.fromARGB(255, 255, 255, 255),
    primaryColorDark: Colors.grey,

    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 70, 70, 70),
    ),
    fontFamily: 'CascadiaCode', // Set default font here
    // Add other dark theme customizations
  );

  ThemeNotifier({bool isDarkMode = true}) {
    _themeData = isDarkMode ? _darkTheme : _lightTheme;
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

