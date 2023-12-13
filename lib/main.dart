import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trustless/screens/projects.dart';
import 'package:trustless/utils/reusable.dart';
import 'package:trustless/widgets/menu.dart';
import 'firebase_options.dart';

var collection = FirebaseFirestore.instance.collection('projects');
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      runApp( MyApp());
      // var querySnapshot = await collection.get();

  // Iterate through the documents and print their data
  // for (var doc in querySnapshot.docs) {
  //   print(doc.data());
  // }
    }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
          
          debugShowCheckedModeBanner: false,
          title: 'Trustless Business',
          theme: theme.getTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => BaseScaffold(body: Projects(), title: "Projects"),
            '/trials': (context) => BaseScaffold(body: Trials(), title: "Section One"),
            '/arbiters': (context) => BaseScaffold(body: Arbiters(), title: "Section One"),
            // More routes
          },
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            TextButton(onPressed: 
            (){}, child: 
            Image.asset(
             "trustless_dark.png"
             ,
            height: 30,)
            ),SizedBox(width: MediaQuery.of(context).size.width/13),
            TextButton(onPressed: (){}, child: 
            Row(children: [
              Icon(Icons.local_activity),
              SizedBox(width: 8),
              Text("PROJECTS", style: TextStyle(fontSize: 23),)
            ],)
            ),
            SizedBox(width: 40),
              TextButton(onPressed: (){}, child: 
            Row(children: [
              Icon(Icons.gavel_sharp),
              SizedBox(width: 8),
              Text("TRIALS", style: TextStyle(fontSize: 23),)
            ],)
            ),  
            SizedBox(width: 40),
              TextButton(onPressed: (){}, child: 
            Row(children: [
              Icon(Icons.person_search),
              SizedBox(width: 8),
              Text("ARBITERS", style: TextStyle(fontSize: 23),)
            ],)
            )
          ],
        ),

        actions: <Widget>[
          SizedBox(
            width:150,
            child: WalletButton()),
        SizedBox(width: 40),
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

class ThemeNotifier with ChangeNotifier {
  late ThemeData _themeData;

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    highlightColor: Color.fromARGB(255, 43, 43, 43),
    indicatorColor: Color.fromARGB(255, 68, 68, 68),
    hoverColor: Color.fromARGB(255, 221, 221, 221),
    accentColor: Color.fromARGB(255, 190, 190, 190),
    primaryColor: Color.fromARGB(255, 56, 56, 56),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        onSurface:  Colors.white,
        primary: Color.fromARGB(255, 59, 59, 59), // Set your desired color for light theme
      ),
    ),
    secondaryHeaderColor: Color.fromARGB(255, 78, 78, 78),
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
    ),
    fontFamily: 'CascadiaCode', // Set default font here
    // Add other light theme customizations
  );



  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 194, 194, 194),
    colorScheme: ColorScheme.dark().copyWith(
    secondary: Colors.grey, // Replace with your desired color
    ),
    indicatorColor: Color.fromARGB(255, 172, 172, 172),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color.fromARGB(255, 145, 145, 145), // Set your desired color for dark theme
    ),
    splashColor: Color.fromARGB(255, 37, 37, 37),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Color.fromARGB(255, 212, 212, 212), // Set your desired color for light theme
      ),
    ),
    secondaryHeaderColor: Color.fromARGB(255, 51, 51, 51),
        accentColor: Color(0xff3bffdb),
        dividerColor: createMaterialColor(Color(0xffcfc099)),
    hintColor: Colors.white70,
    buttonColor: Colors.grey,
    focusColor: Colors.grey,
    highlightColor: Color.fromARGB(255, 255, 255, 255),
    primaryColorDark: Colors.grey,

    appBarTheme: AppBarTheme(
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
    return Center(child: Text('Trials'));
  }
}

class Arbiters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Arbiters'));
  }
}

