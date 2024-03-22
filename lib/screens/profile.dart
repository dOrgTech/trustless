import "package:flutter/material.dart";
import "package:trustless/utils/reusable.dart";
import "package:trustless/widgets/footer.dart";

import "../entities/human.dart";
import "../entities/user.dart";
import "../main.dart";
import "../widgets/action.dart";


class Profile extends StatefulWidget {
   Profile({super.key});
   bool done=false;
  @override
  State<Profile> createState() => _ProfileState();
}
  double opa0 = 0;
    double opa1 = 0;
    double opa2 = 0;
    double opa3 = 0;
    double h1 = 0;
    double w1 = 20;
    double h2 = 0;
    double w2 = 20;
    double h3 = 0;
    double w3 = 20;
class _ProfileState extends State<Profile> {
     @override
  void initState() {
   if (widget.done==false){
      Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        opa0 = 1;
        w1 = 200;
        h1 = 124;
        widget.done=true;
      });
    });
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        w2 = 200;
        h2 = 90;
      });
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        h3 = 124;
        opa2 = 1;
      });
    });
   }
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        opa3 = 1;
      });
    });
    Future.delayed(Duration(milliseconds: 670), () {
      setState(() {
        opa1 = 1;
      });
    });
    super.initState();
  }

   Widget balance(ce, cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [        
            Text(
              ce,
              style: TextStyle(fontSize: 17),
            ),
        SizedBox(
          height: 12,
        ),
        Text(
          cat,
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Roboto Mono",
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
    Widget unclaimed(ce, cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [        
            Text(
              ce,
              style: TextStyle(fontSize: 17),
            ),

        SizedBox(
          height: 5,
        ),
        Text(
          cat,
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Roboto Mono",
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(  height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("from"),
          SizedBox(width: 5,),
          TextButton(onPressed: (){}, child: Text("0 projects",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
        ],)

      ],
    );
  }
   Map<int,String> timescales={
   1: "24h",
    2:"week",
   3: "month",
   4: "3 months",
    5:"year",
  };
  int timescale=1;
var sc=ScrollController();

  @override
  Widget build(BuildContext context) {
    bool lumina=Theme.of(context).brightness==Brightness.dark;
    
    ScrollController sc=ScrollController();
    return SizedBox(
        //  height: MediaQuery.of(context).size.height,
          child: DefaultTabController(
          initialIndex: 0,
          length: 3, 
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              alignment: Alignment.topLeft,
              height: 50,width: 760,
              child: TabBar(
                labelStyle: TextStyle(color: Theme.of(context).focusColor),
                labelColor:Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black,
                automaticIndicatorColorAdjustment: false,
                // overlayColor:MaterialStateProperty.all(Colors.white),
                unselectedLabelColor: Theme.of(context).hintColor,
                tabs: [
              Tab(text: "OVERVIEW"),
              Tab(text: "AUTHOR OF "+Human().user!.projectsAuthored.length.toString()),
              Tab(text: "CONTRACTOR OF "+Human().user!.projectsContracted.length.toString()),
              Tab(text: "ARBITER OF "+Human().user!.projectsArbitrated.length.toString()),
              Tab(text: "BACKER OF "+Human().user!.projectsBacked.length.toString()),
               ])),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:  TabBarView(
                    children: [
                    Scrollbar(child: SingleChildScrollView(child: Column(
                      children: [
                        overview(lumina),
                        SizedBox(height:130),
                        
                      ],
                    ))),
                    Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  child:Text("Coming soon..."))),
                    
                    Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  child:Text("Working on it..."))),
                   
                    ]),
                
              ),
              Footer(),
              ],),
          )),
      
    );


    return overview(lumina);
  }


Widget overview(lumina){
   List<ActionItem> activity=[];
    for (TTransaction t in actions){
      activity.add(ActionItem(action: t, landingPage: false));
    }
    return
    Container(
      constraints: BoxConstraints(maxWidth: 1200),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              SizedBox(height: 60,),
              Container(
                // padding: EdgeInsets.only(left:100),
                height: 360,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Row(
                        children: [
                            Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Center(child: Text("Alias:")),
                        ),
                        SizedBox(height: 30),
                         SizedBox(
                          height: 50,
                          child: Center(child: Text("Description:")),
                        ),
                        SizedBox(height: 70),
                          SizedBox(
                          height: 50,
                          child: Center(child: Text("External Link:")),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: TextField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Set an Alias"
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: 450,
                          height: 120,
                          child: TextField(
                            maxLines: 3,
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText: "Brief profile description"
                            ),
                          ),
                        ),
                          
                            SizedBox(
                          width: 450,
                          height: 50,
                          child: TextField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "https://link-to-additional-context..."
                            ),
                          ),
                        ),
                      ],
                    ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      // Return blue when enabled, implicitly use default for other states
      if (!states.contains(MaterialState.disabled)) {
        return Theme.of(context).canvasColor; // Active (enabled) text color
      }
      // Since a Color must always be returned and we don't want to explicitly set a disabled color,
      // we return the default foreground color for the ElevatedButton theme.
      // This approach assumes the theme's default aligns with your desired disabled state appearance.
      return ElevatedButtonTheme.of(context).style?.foregroundColor?.resolve({}) ?? Colors.white;
    }),
                      ),
                      onPressed: (){}, child: 
                    SizedBox(
                      height: 80,
                      width: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.save, size: 20),
                          SizedBox(height: 7),
                          Text("SAVE",style: TextStyle(fontSize: 20)),
                        ],
                      )))
                  ],
                ),
              ),
              Wrap(
                spacing: 57,
                runSpacing: 40,
                children: [
                  AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? Color(0x54c9c9c9)
                                : Color(0x432000000),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "${Human().chain.nativeSymbol} Earned",
                                 Human().user!.nativeEarned.toString()
                                  )),
                        )),  
                  AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? Color(0x54c9c9c9)
                                : Color(0x432000000),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "USDT Earmed",
                                 Human().user!.usdtEarned.toString()
                                  )),
                        )), 
                        AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? Color(0x54c9c9c9)
                                : Color(0x432000000),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "${Human().chain.nativeSymbol} Spent",
                                 Human().user!.nativeSpent.toString()
                                  )),
                        )),  
                  AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? Color(0x54c9c9c9)
                                : Color(0x432000000),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "USDT Spent",
                                 Human().user!.usdtSpent.toString()
                                  )),
                        )),   
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ?Color(0x54c9c9c9)
                                : Color(0x432000000),
                                // Color(0x542e2d2d),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: h3,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa2,
                          duration: Duration(milliseconds: 800),
                          child: Center(
                            child: unclaimed(
                              "Unclaimed ${Human().chain.nativeSymbol}", "0.00")),
                        )),
                         AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ?Color(0x54c9c9c9)
                                : Color(0x432000000),
                                // Color(0x542e2d2d),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: h3,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa2,
                          duration: Duration(milliseconds: 800),
                          child: Center(
                            child: unclaimed(
                              "Unclaimed USDT", "0.00")),
                        )),
              ],),
                SizedBox(height: 60,),
              Text("ACTIVITY:"),
                SizedBox(height: 20,),
          
            Container(
              height: 600,
              width:700,
              decoration: BoxDecoration(
                color: Color(0x23000000),
              ),
              
            
            child: ListView(children: activity)
            ),
              
          SizedBox(height: 20,),
//             Center(
//               child: Wrap(
//                 spacing: 20,
//                 children: [
//             SizedBox(
//           width:500,
//           child: Column(
//             children: [
//                 Column(
//                     children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Dividends from  ", style: TextStyle(fontSize: 17,),),
//                             DropdownButton(
//                       value: 1,
//                       onChanged: (value) {
//                             int numar=value as int;
//                             setState(() {});
//                               },
//                       items: [
//                       DropdownMenuItem(child: Text("All projects"),value: 1),
//                       ]),
//                           ],
//                         ),
                     
                      
//              ] ),
//                         ],
//                       ),
//                     ),
//                      SizedBox(
//           width:500,
//           child: Column(
//               children: [
//                 Column(
//                     children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Mining rewards from  ", style: TextStyle(fontSize: 17,),),
//                             DropdownButton(
//                       value: 1,
//                       onChanged: (value) {
//                             int numar=value as int;
//                             setState(() {});
//                               },
//                       items: [
//                       DropdownMenuItem(child: Text("All nodes"),value: 1),
//                       ]),
//                           ],
// )])]))
// ])
// )
]));
                        
                        }

}

 

