import "package:flutter/material.dart";
import "package:trustless/utils/reusable.dart";

import "../entities/human.dart";


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
              Tab(text: "AUTHOR"),
              Tab(text: "CONTRACTOR"),
              Tab(text: "ARBITER"),
              Tab(text: "BACKER"),
               ])),
            Container(
              height: MediaQuery.of(context).size.height-185,
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
                  child:Text("secondscredits "))),
                    
                    Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  child:Text("stan md powd "))),
                   
                    ]),
                
              )
              ],),
          )),
      
    );


    return overview(lumina);
  }



Widget overview(lumina){
    
    return
    Container(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              SizedBox(height: 20,),
              Wrap(
                spacing: 57,
                runSpacing: 20,
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
                                  "XTZ Earned",
                                 0.toString()
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
                                 0.toString()
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
                              "Unclaimed XTZ", "0.00")),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("View data for the last ",style: TextStyle(fontSize: 17),),
                    SizedBox(width: 10),
                      DropdownButton(
                    value: timescale,
                    onChanged: (value) {
                      int numar=value as int;
                      setState(() {timescale=numar;});
                        },
                    items: [
                    DropdownMenuItem(child: Text(timescales[1]!),value: 1),
                    DropdownMenuItem(child: Text(timescales[2]!),value: 2),
                    DropdownMenuItem(child: Text(timescales[3]!),value: 3),
                    DropdownMenuItem(child: Text(timescales[4]!),value: 4),
                    DropdownMenuItem(child: Text(timescales[5]!),value: 5),
                    ])
                ]),
          SizedBox(height:20),
            Container(
              decoration: BoxDecoration(
                color: Color(0x23000000),
              ),
              width: MediaQuery.of(context).size.width,
            height: 110,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                      width:400,
                      height:70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,
                          child:Text("A graph showing earnings and expenditure",style: TextStyle(fontWeight: FontWeight.bold),)),
                       
                        ],
                      ),
                    ),
                    const SizedBox(width: 95),
                SizedBox(
                  height:70,
                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                SizedBox(height: 7),
                                Text('Total earnings :', style: TextStyle( fontSize: 17),),
                                SizedBox(height: 3),
                                Text('Total spent:',style: TextStyle(fontSize: 17)),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text("0 ${Human().chain.nativeSymbol}" , style: TextStyle(fontFamily: 'Roboto Mono', fontSize: 17)),
                                SizedBox(height: 2),
                                Text("0 ${Human().chain.nativeSymbol}", style: TextStyle(fontFamily: 'Roboto Mono', fontSize: 17)),
                              ]),
              
                            ]),
                ),
            ],)
            ),
              
          SizedBox(height: 20,),
            Center(
              child: Wrap(
                spacing: 20,
                children: [
            SizedBox(
          width:500,
          child: Column(
            children: [
                Column(
                    children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Dividends from  ", style: TextStyle(fontSize: 17,),),
                            DropdownButton(
                      value: 1,
                      onChanged: (value) {
                            int numar=value as int;
                            setState(() {});
                              },
                      items: [
                      DropdownMenuItem(child: Text("All projects"),value: 1),
                      ]),
                          ],
                        ),
                     
                      
             ] ),
                        ],
                      ),
                    ),
                     SizedBox(
          width:500,
          child: Column(
              children: [
                Column(
                    children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Mining rewards from  ", style: TextStyle(fontSize: 17,),),
                            DropdownButton(
                      value: 1,
                      onChanged: (value) {
                            int numar=value as int;
                            setState(() {});
                              },
                      items: [
                      DropdownMenuItem(child: Text("All nodes"),value: 1),
                      ]),
                          ],
)])]))]))]));
                        
                        }

}

 

