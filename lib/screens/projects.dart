import "package:flutter/material.dart";
import "package:trustless/widgets/newGenericProject.dart";
import "../entities/human.dart";
import "../entities/project.dart";
import "../main.dart";
import "../widgets/footer.dart";
import "../widgets/projectCard.dart";

String? selectedNewProject="Open to proposals";
  final List<String> statuses = ['All', 'Open', "Pending",'Ongoing','Dispute',"Closed"];
  final List<String> projectTypes = ['Open to proposals', 'Set parties','Import project'];

// ignore: must_be_immutable
class Projects extends StatefulWidget {
  String? selectedStatus = 'All';
  Projects({super.key, required this.main, required this.capacity});
  bool main;
  String capacity;
  String query="";
  @override
  State<Projects> createState() => ProjectsState();
}

class ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext context) {
    List<Project> projectsToShow =[];
    List<Widget>projectCards=[];
    if (widget.main==false){
      projectsToShow = projects.where((p) {
      return projects.any((project) =>
      widget.capacity=="contracted"? p.contractor!.toLowerCase() == Human().address!.toLowerCase()
        : widget.capacity=="authored"? p.author!.toLowerCase() == Human().address!.toLowerCase()
       
       : widget.capacity=="arbitrated"? p.arbiter!.toLowerCase() == Human().address!.toLowerCase()
       : p.contributions.keys.contains(Human().address)
          );
      }).toList();
    }
    List<Project> items = widget.main? projects : projectsToShow;
     for (Project p in items){
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

    if (projectCards.isEmpty){
      projectCards.add(const Center(child:SizedBox(
        height: 300,
        child: Center(child: Text("No projects match applied filters.",
        style: TextStyle(fontSize: 24, color:Colors.grey),
        )))));
    }
        // return Text("something");
        List<Widget> projectsMenu=[
        Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: SizedBox(
                  width: 
                  MediaQuery.of(context).size.width>1200?
                  500:
                  MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    onChanged: (value){
                        setState(() {
                        widget.query = value;
                      });
                    },
                    decoration: InputDecoration(

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(width: 0.1),
                        ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search project',
                    ),
                  ),
                ),
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      widget.capacity.length<2?
                      "Showing ":
                      "Showing my ${widget.capacity} projects in stage ",
                      style: widget.capacity.length<2? const TextStyle():
                      const TextStyle(fontSize: 18),
                      ),
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
                                const SizedBox(width: 15),
                    Padding(
                      padding:  const EdgeInsets.only(right:8.0),
                      child: Row(
                        children:   [
                           Text(
                          widget.capacity.length<2?" projects":""),
                        
                          const SizedBox(width: 60),
            // HoverExpandWidget(projectsState: this),
            widget.main?
            ElevatedButton(onPressed: (){
                        Human().address==null?
                     showDialog(
                context: context,
                builder: (context) => const AlertDialog(
            
                      content: SizedBox(height:100, width: 400,child:Center(child: 
                      Text("Connect your wallet first.")
                      )),
                    ))
                    : 
                  showDialog(
                    barrierDismissible:  false,
                    context: context, 
                    builder: (context) => AlertDialog(
                      
                      content: SizedBox(
                        width: 900,
                        // height: 500,
                        child: NewGenericProject(projectsState:this)
                      )
                    )
                  );
                            }
                            , child: SizedBox(
                              width:110,
                              height:35,
                              child: Center(
                                child: Text("Add Project",
                                style: TextStyle(
                                  fontSize: 19,
                                  color:Theme.of(context).brightness==Brightness.dark?const Color.fromARGB(255, 0, 0, 0):const Color.fromARGB(255, 255, 255, 255)),
                                
                                ),
                              ),
                            )):Text(""),
              
                      const SizedBox(
                        width: 10,
                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
         ];
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
              MediaQuery.of(context).size.aspectRatio > switchAspect?
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                       height: 46,
                       width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 1200),
                       child:  MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: projectsMenu
                           ),
                      )):
                      Center(
                        child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                         height: 126, 
                         width: double.infinity,
                         
                         child:  MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: projectsMenu
                             ),
                        )),
                      ) 
                      ,
                    const SizedBox(height: 24,),
                    // NewGenericProject(projectsState: this),
                   Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 1200),
                     child: Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      alignment: WrapAlignment.start,
                      children: [...projectCards,
                      ],
                      
                     ),
                   ), 
                  SizedBox(
                    height: 
                    projectCards.length<=4?690:
                     64),
                  widget.main? Footer():Text("")
                ],
              ), // End of Column
            ],
          ), // End of ListView
        );
  }
}

