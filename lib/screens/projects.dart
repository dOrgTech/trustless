import "package:flutter/material.dart";
import "package:trustless/widgets/newGenericProject.dart";
import "../entities/project.dart";
import "../main.dart";
import "../widgets/footer.dart";
import "../widgets/hovermenu.dart";
import "../widgets/projectCard.dart";

String? selectedNewProject="Open to proposals";
  final List<String> statuses = ['All', 'Open', 'Ongoing','Dispute',"Pending","Closed"];
  final List<String> projectTypes = ['Open to proposals', 'Set parties','Import project'];

// ignore: must_be_immutable
class Projects extends StatefulWidget {
  String? selectedStatus = 'All';
  Projects({super.key});
  String query="";
  @override
  State<Projects> createState() => ProjectsState();
}

class ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext context) {
    print("projects "+projects.length.toString());
    List<Widget>projectCards=[];
     for (Project p in projects){
      if (
        p.name!.toLowerCase().contains(widget.query.toLowerCase())
      ){
        if (widget.selectedStatus!="All"){
          if(p.status!.toLowerCase()==widget.selectedStatus!.toLowerCase()){
          projectCards.add(ProjectCard(project:p));   
          }
        }
        else{
          projectCards.add(ProjectCard(project:p));   
        }
      }
    }
    if (projectCards.length==0){
      projectCards.add(const Center(child:SizedBox(
        height: 300,
        child: Center(child: Text("No projects match applied filters.",
        style: TextStyle(fontSize: 24, color:Colors.grey),
        )))));
    }
    // return Text("something");
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
                                  onChanged: (value){
                                     setState(() {
                                      widget.query = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                         borderSide: BorderSide(width: 0.1),
                                      ),
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Search project',
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Text("Status:"),
                                        const SizedBox(width: 10),
                                         DropdownButton<String>(
                                               value: widget.selectedStatus,
                                               focusColor: Colors.transparent,
                                               items: statuses.map((String value) {
                                       return DropdownMenuItem<String>(
                                         value: value,
                                         child: Text(value),
                                       );
                                               }).toList(),
                                               onChanged: (String? newValue) {
                                       setState(() {
                                         widget.selectedStatus = newValue;
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
                        HoverExpandWidget(projectsState: this),
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
                    // NewGenericProject(projectsState: this),
                   Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 1200),
                     child: Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      alignment: WrapAlignment.start,
                      children: projectCards,
                     ),
                   ), 
                  SizedBox(
                    height: 
                    projectCards.length<=4?690:
                     64),
                   Footer()
                ],
              ), // End of Column
            ],
          ), // End of ListView
        );
  }
}