import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustless/widgets/fundProject.dart';
import 'package:trustless/widgets/somethingsWrong.dart';
import 'package:trustless/widgets/waiting.dart';
import '../entities/human.dart';
import '../entities/project.dart';
import '../main.dart';


const String escape = '\uE00C';

class Arbitrate extends StatefulWidget {
  final Project project;
  String stage="main";
  // ignore: use_key_in_widget_constructors
  Arbitrate({required this.project});

  @override
  _ArbitrateState createState() => _ArbitrateState();
}

class _ArbitrateState extends State<Arbitrate> {
  bool _useSlider = true;
  double _sliderValue = 0;
  TextEditingController _awardToContractorController = TextEditingController();
  bool _canSubmit = false;

  @override
  void dispose() {
    _awardToContractorController.dispose();
    super.dispose();
  }
  int percentage=0;
   String _hash = '';
  String _fileName = '';
    Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      _fileName = result.files.first.name; // Store the file name
      
      var digest = sha256.convert(fileBytes);
      setState(() {
        widget.project.hashedFileName=_fileName;
        _hash = digest.toString();
        widget.project.rulingHash=_hash;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
return main();
  }

 Widget main(){
      switch (widget.stage) {
          case "main":
            return stage0();
          case "waiting":
            return SizedBox(height:450,child: WaitingOnChain());
          case "error":
            return SomethingWentWrong(project:widget.project);
          default:       
            return stage0();
      }
  }

Widget stage0(){
    double onePercent = ((int.parse( widget.project.holding) - 200) /100) ;
    double awardToBackers = _useSlider ? 
    (int.parse( widget.project.holding) - 200) - _sliderValue * onePercent
    : 
    (int.parse( widget.project.holding) - 200) - (double.tryParse(_awardToContractorController.text) ?? 0);
    
    double awardToContractor = _useSlider ?
     _sliderValue  * onePercent
    :
     (double.tryParse(_awardToContractorController.text) ?? 0);
    bool isNegative = awardToBackers < 0 || awardToContractor < 0;
    return 
  //   ! (Human().address==widget.project.arbiter) ? 
  //  const SizedBox(
  //     child: Text("You are not signed in as the designated Arbiter.")
  //   ) 
    
  //   :
    
    Container(
      width: 750,
      padding: const EdgeInsets.all( 60),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: 0.3,
        ),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Arbitrate",  style: Theme.of(context).textTheme.headline5!,),
          const SizedBox(height: 20),
          Text("Amount in Escrow: ${(int.parse( widget.project.holding) - 200)}",
               style: Theme.of(context).textTheme.subtitle1!,
          ),
         const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 const Text("Input Field"),
                  Switch(
                    value: _useSlider,
                    onChanged: null,
                    // (value) {
                    //   setState(() {
                    //     _useSlider = value;
                    //     _canSubmit = false;
                    //   });
                    // }, 
                    activeColor: Colors.grey[300],
                    inactiveTrackColor: Theme.of(context).disabledColor,
                    inactiveThumbColor: Colors.grey[300],
                  ),
                  const Text("Slider"),
                ],
              ),
              const SizedBox(height: 20),
              _useSlider
                  ? Slider(
                    divisions: 100,
                      value: _sliderValue,
                      min: 0,
                      max:100,
                      // max: widget.project.holding!,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                          percentage = ((value /100) * 100).round();
                          _canSubmit = true;
                        });
                      },
                    )
                  : TextFormField(
                      controller: _awardToContractorController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(100|[1-9]?\d)$'))],
                      decoration:const  InputDecoration(
                        labelText: "Award to Contractor",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _canSubmit = _hash.length>8 && double.tryParse(value) != null && double.parse(value) <= (int.parse( widget.project.holding) - 200);
                        });
                      },
                    ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Reimburse Backers",
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${awardToBackers.toStringAsFixed(2)} (${(100-_sliderValue).toStringAsFixed(0)}%)",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: isNegative ? Colors.red : null),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Award to Contractor",
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
                  const SizedBox(height: 10),
                  Text( 
                    "${awardToContractor.toStringAsFixed(2)} (${_sliderValue.toStringAsFixed(0)}%)",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: isNegative ? Colors.red : null),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
             SizedBox(
                  // width:600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Select File', textAlign: TextAlign.center,),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent, // Transparent background
              // White text color
                shadowColor: Colors.transparent, // No shadow
                side: const BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 2.0), // Visible border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Square shape
                ),
                fixedSize: const Size(100, 100), // Square size
              ),
            ),    
            const SizedBox(width: 48),
            const SizedBox(
                  width: 460,
                  child: Text("Select the RULING.md file. This should explain the reasoning you applied in your decision as well as the facts and resources you considered. A hash of this file will be stored on-chain for future reference."
                  ,textAlign: TextAlign.justify,
                  )),
                ],
                ),
                ),
                Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:38.0),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Text(_fileName.isNotEmpty ? 'File hash: ':"")
                  ),
                Text('$_hash', style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w100),),
              ],
            ),
          )),
      ],
    ),
          Padding(
            padding: const EdgeInsets.only(top:28.0),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       SizedBox(height: 30,width: 150,
                    child: Opacity(
                      opacity: 0.6,
                      child: TextButton(
                        style: ButtonStyle(
                          // overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                          // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).indicatorColor),
                          elevation: MaterialStateProperty.all(0.0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                        ),
                          onPressed:
                        (){
                        Navigator.of(context).pop();
                        },
                          child: const Center(
                        child: Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      )),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _canSubmit
                      ? () async{
                          setState(() {widget.stage="waiting";});
                        print("Signing contract");
                        String cevine = await cf.arbitrate(widget.project, percentage, _hash);
                          print("dupa cevine");
                            if (cevine.contains("nu merge")){
                            print("nu merge din setParty");
                            setState(() { widget.stage="error";});
                            return;
                          }
                          // next line failing with Uncaught (in promise) Error: FormatException: Invalid double
                          // widget.project.arbiterAwardingContractor=double.parse( _awardToContractorController.text.toString());
                          // widget.project.arbiterAwardingContractor=double.parse( _awardToContractorController.text.toString());
                          widget.project.arbiterAwardingContractor=(percentage*onePercent).toString();
                          widget.project.status='closed';
                          await projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                           try{
                              String oldEarned = Human().user!.nativeEarned;
                              String newEarned=oldEarned;
                              cf.getNativeEarned( Human().user!.address).then((value){
                                newEarned=value;
                                if (BigInt.parse(newEarned) > BigInt.parse( oldEarned) ){
                                  print("avem diferente");
                                   Human().user!.nativeEarned=newEarned;
                                  usersCollection.doc(Human().user!.address).set(Human().user!.toJson());}
                              });
                        }catch (Exception) 
                        {if (kDebugMode) {
                          print("helo");
                        }}
                          Navigator.of(context).pushNamed("/projects/${widget.project.contractAddress}");
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}

}