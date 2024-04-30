import "package:flutter/material.dart";
import "package:trustless/screens/projects.dart";
import "package:trustless/utils/reusable.dart";
import "package:trustless/widgets/footer.dart";

import "../entities/human.dart";
import "../entities/user.dart";
import "../main.dart";
import "../widgets/action.dart";


class Profile extends StatefulWidget {
   Profile({super.key});
   bool done=false;
   bool madeInvolvements=false;
   List<Widget> involvements=[];
   String oldAbout=Human().user!.about??"";
   String oldlink=Human().user!.link??"";
   String oldAlias=Human().user!.name??"";
   bool valuesChanged=false;
   TextEditingController aliasControlla = TextEditingController();
   TextEditingController aboutControlla = TextEditingController();
   TextEditingController linkControlla = TextEditingController();

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
    double h5 = 0;
    double w2 = 20;
    double h3 = 0;
    double w3 = 20;
class _ProfileState extends State<Profile> {
     @override
  void initState() {
    widget.aliasControlla.text=Human().user!.name??"";
    widget.aboutControlla.text=Human().user!.about??"";
    widget.linkControlla.text=Human().user!.link??"";
   if (widget.done==false){
      Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opa0 = 1;
        w1 = 200;
        h1 = 124;
        widget.done=true;
      });
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        w2 = 200;
        h2 = 90;
      });
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        h3 = 124;
        opa2 = 1;
        h5=50;
      });
    });
   }
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        opa3 = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 670), () {
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
              style: const TextStyle(fontSize: 17),
            ),
        const SizedBox(
          height: 12,
        ),
        Text(
          cat,
          style: const TextStyle(
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [   
         Text(
          cat,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "Roboto Mono",
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),     
            Text(
              ce,
              style: const TextStyle(fontSize: 17),
            ),

        const SizedBox(
          height: 5,
        ),
       
        const SizedBox(  width:10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Text("from"),
          const SizedBox(width: 5,),
          TextButton(onPressed: (){}, child: const Text("0 projects",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
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
          length: 5, 
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
             const Tab(text: "OVERVIEW"),
              Tab(text: "AUTHOR (${Human().user!.projectsAuthored.length})"),
              Tab(text: "CONTRACTOR (${Human().user!.projectsContracted.length})"),
              Tab(text: "ARBITER (${Human().user!.projectsArbitrated.length})"),
              Tab(text: "BACKER (${Human().user!.projectsBacked.length})"),
               ])),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:  TabBarView(
                    children: [
                    Scrollbar(child: SingleChildScrollView(child: Column(
                      children: [
                        overview(lumina),
                        const SizedBox(height:130),
                      ],
                    ))),
             Projects(main:false, capacity: "authored",),
             Projects(main:false, capacity: "contracted",),
             Projects(main:false, capacity: "arbitrated",),
             Projects(main:false, capacity: "backed",),
                    ]),
              ),
              Footer(),
              ],),
          )),
    );
  }

List<Widget> allInvolvements(){ 
if (!widget.madeInvolvements){
  List<TTransaction> filteredTransactions = actions.where((transaction) {
      return projects.any((project) =>
          project.author == Human().address ||
          project.contractor == Human().address ||
          project.arbiter == Human().address ||
          project.contributions.keys.contains(Human().address));
    }).toList();
  for (TTransaction t in filteredTransactions){
    widget.involvements.add(ActionItem(action: t, landingPage: true));
  }
  widget.madeInvolvements=true;
  }

return widget.involvements;
}


Widget overview(lumina){
   List<ActionItem> activity=[];
    for (TTransaction t in actions){
      if (t.sender==Human().address){
      activity.add(ActionItem(action: t, landingPage: true));
      }
    }
    List<Widget> showing;
    if (timescale==1){
      showing=activity;
    }else{showing=allInvolvements();}
    return
    Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              const SizedBox(height: 60,),
              Container(
                // padding: EdgeInsets.only(left:100),
                height: 360,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                          Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:const [
                       SizedBox(
                        height: 50,
                        child: Center(child: Text("Alias:")),
                      ),
                     SizedBox(height: 40),
                       SizedBox(
                        height: 50,
                        child: Center(child: Text("Description:")),
                      ),
                      SizedBox(height: 120),
                        SizedBox(
                        height: 50,
                        child: Center(child: Text("External Link:")),
                      ),
                    ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                       SizedBox(
                        width: 300,
                        height: 90,
                        child: TextField(
                          controller: widget.aliasControlla,
                          maxLines: 1,
                          maxLength: 25,
                          onChanged: widget.valuesChanged==true?null: (value) {
                           if (!(value==widget.oldAlias)){
                              setState(() {
                                widget.valuesChanged=true;
                              });
                           }
                          },
                          decoration: InputDecoration(
                            hintText: "Set an Alias"
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 450,
                        height: 160,
                        child: TextField(
                         controller: widget.aboutControlla,
                          maxLines: 5,
                          maxLength: 500,
                          onChanged:widget.valuesChanged==true?null:  (value) {
                           if (!(value==widget.oldAbout)){
                             setState(() {
                                widget.valuesChanged=true;
                              });
                           }
                          },
                          decoration: InputDecoration(
                            hintText: "Brief profile description"
                          ),
                        ),
                      ),
                          SizedBox(
                        width: 450,
                        height: 80,
                        child: TextField(
                           controller: widget.linkControlla,
                          maxLines: 1,
                          maxLength: 150,
                          onChanged: widget.valuesChanged==true?null: (value) {
                           if (!(value==widget.oldlink)){
                              setState(() {
                                widget.valuesChanged=true;
                              });
                           }
                          },
                          decoration: InputDecoration(
                            hintText: "https://link-to-additional-context..."
                          ),
                        ),
                      ),
                    ],
                    ),
                      ],
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
                      onPressed: widget.valuesChanged?()async{
                        Human().user!.about=widget.aboutControlla.text;
                        Human().user!.link=widget.linkControlla.text;
                        Human().user!.name=widget.aliasControlla.text;
                        await usersCollection.doc(Human().address).set(Human().user!.toJson());
                        setState(() {
                          widget.valuesChanged=false;
                        });
                    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        // The content of the SnackBar.
        content: Center(
            child: Text(
          'Settings saved',
          style: TextStyle(fontSize: 15),
        )),
        // The duration of the SnackBar.
        duration: Duration(seconds: 2),
      ),
    );
                      }: null
                      , child: 
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
              SizedBox(height: 30),
              Wrap(
                spacing: 57,
                runSpacing: 40,
                children: [
                  AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? const Color(0x54c9c9c9)
                                : const Color(0x432000000),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: const Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "${Human().chain.nativeSymbol} Earned",
                                 Human().user!.nativeEarned.toString()
                                  )),
                        )),  
                  AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? const Color(0x54c9c9c9)
                                : const Color(0x432000000),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: const Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "USDT Earmed",
                                 Human().user!.usdtEarned.toString()
                                  )),
                        )), 
                        AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? const Color(0x54c9c9c9)
                                : const Color(0x432000000),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: const Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "${Human().chain.nativeSymbol} Spent",
                                 Human().user!.nativeSpent.toString()
                                  )),
                        )),  
                   AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 0.9),
                            color: lumina
                                ? const Color(0x54c9c9c9)
                                : const Color(0x432000000),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        height: h1,
                        width: 200,
                        child: AnimatedOpacity(
                          opacity: opa1,
                          duration: const Duration(milliseconds: 800),
                          child: Center(
                              child: balance(
                                  "USDT Spent",
                                 Human().user!.usdtSpent.toString()
                                  )),
                        )),  
                         ],),
                         const SizedBox( height: 30),
                    //      Wrap(
                    //       spacing: 30,
                    //       runSpacing: 20,
                    //       children: [
                    //     AnimatedContainer(
                    //     duration: const Duration(milliseconds: 400),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //             color: Theme.of(context).backgroundColor,
                    //             width: 0.9),
                    //         color: lumina
                    //             ?const Color(0x54c9c9c9)
                    //             : const Color(0x432000000),
                    //             // Color(0x542e2d2d),
                    //         borderRadius: const BorderRadius.all(Radius.circular(8))),
                    //     height: h5,
                    //     width: 400,
                    //     child: AnimatedOpacity(
                    //       opacity: opa2,
                    //       duration: const Duration(milliseconds: 800),
                    //       child: Center(
                    //         child: unclaimed(
                    //           "Unclaimed ${Human().chain.nativeSymbol}", "0.00")),
                    //     )),
                    //  AnimatedContainer(
                    //     duration: const Duration(milliseconds: 400),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //             color: Theme.of(context).backgroundColor,
                    //             width: 0.9),
                    //         color: lumina
                    //             ?const Color(0x54c9c9c9)
                    //             : const Color(0x432000000),
                    //             // Color(0x542e2d2d),
                    //         borderRadius: const BorderRadius.all(Radius.circular(8))),
                    //     height: h5,
                    //     width: 400,
                    //     child: AnimatedOpacity(
                    //       opacity: opa2,
                    //       duration: const Duration(milliseconds: 800),
                    //       child: Center(
                    //         child: unclaimed(
                    //           "Unclaimed USDC", "0.00")),
                    //     )),
                    //       ],
                    //      ), 
                    
             
               const SizedBox(height: 80,),
             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Show actions "  , style: TextStyle(fontSize: 17),),
                    const SizedBox(width: 10),
                      DropdownButton(
                    value: timescale,
                    onChanged: (value) {
                      int numar=value as int;
                      setState(() {
                        timescale=numar;
                        
                        });
                        },
                    items: [
                    const DropdownMenuItem(child: Text("taken by me"),value: 1),
                    const DropdownMenuItem(child: Text("on all my involvements"),value: 2),
                    
                    ])
                ]),
                const SizedBox(height: 10,),
            Container(
              height: 600,
              decoration: const BoxDecoration(
                color: Color(0x23000000),
              ),
            child: ListView(children: showing)
            ),
              
          const SizedBox(height: 20,),
]));
                        
                        }

}

 

