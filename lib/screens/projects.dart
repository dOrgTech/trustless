import "package:flutter/material.dart";

import "../entities/project.dart";
import "../main.dart";
import "../widgets/footer.dart";
import "../widgets/hovermenu.dart";
import "../widgets/projectCard.dart";

List<Widget> projectCards=[];
String? selectedStatus = 'All';
String? selectedNewProject="Open to proposals";
  final List<String> statuses = ['All', 'Open', 'Ongoing','Dispute',"Pending","Closed"];
  final List<String> projectTypes = ['Open to proposals', 'Set parties','Import project'];

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
   @override
  void initState() {
    projectCards=[];
    super.initState();
     for (Project p in projects){
      print("making a project card from "+p.name!);
      projectCards.add(ProjectCard(project:p));   
    }

    if (projects.length<4){
      for (int i=0;i < 5-projects.length;i++){
        projectCards.add(SizedBox( width: 490,
          height: 260,));
      }
      
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return  Container(
          alignment: Alignment.topCenter,
          child: ListView( // Start of ListView
            shrinkWrap: true, // Set this property to true
            children: [
              Column( // Start of Column
                crossAxisAlignment: CrossAxisAlignment.center, // Set this property to center the items horizontally
                mainAxisSize: MainAxisSize.min, // Set this property to make the column fit its children's size vertically
                children: [
            const  SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                       height: 46, 
                       width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 1200),
                       child:  MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: SizedBox(
                                width: 
                                MediaQuery.of(context).size.width>1200?
                                500:
                                MediaQuery.of(context).size.width * 0.5,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                         borderSide: BorderSide(width: 0.1),
                                      ),
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Search project',
                                    // other properties
                                  ),
                                  // other properties
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Text("Status:"),
                                        const SizedBox(width: 10),
                                         DropdownButton<String>(
                                               value: selectedStatus,
                                               focusColor: Colors.transparent,
                                               items: statuses.map((String value) {
                                       return DropdownMenuItem<String>(
                                         value: value,
                                         child: Text(value),
                                       );
                                               }).toList(),
                                               onChanged: (String? newValue) {
                                       setState(() {
                                         selectedStatus = newValue;
                                       });
                                           },
                                             ),
                                             SizedBox(width: 20),
                                Padding(
                                  padding:  EdgeInsets.only(right:8.0),
                                  child: Row(
                                    children:   [
                                     Text(" Projects"),
                                      SizedBox(width: 60),
                        HoverExpandWidget(),


                      
                      SizedBox(
                        width: 10,
                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            ],
                           ),
                      )),
                    SizedBox(height: 24,),
                   Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 1200),
                     child: Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      alignment: WrapAlignment.start,
                      children: projectCards,
                     ),
                   ), 
                  const SizedBox(height: 64),
                   Footer()
                ],
              ), // End of Column
            ],
          ), // End of ListView
        );
  }
}