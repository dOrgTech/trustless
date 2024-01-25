import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entities/human.dart';
import '../entities/project.dart';
import '../main.dart';

const String escape = '\uE00C';

class Arbitrate extends StatefulWidget {
  final Project project;

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

  @override
  Widget build(BuildContext context) {
    double awardToBackers = _useSlider ? widget.project.holding! - _sliderValue : widget.project.holding! - (double.tryParse(_awardToContractorController.text) ?? 0);
    double awardToContractor = _useSlider ? _sliderValue : (double.tryParse(_awardToContractorController.text) ?? 0);
    bool isNegative = awardToBackers < 0 || awardToContractor < 0;
    return 
    
    ! (Human().address==widget.project.arbiter) ? 
   const SizedBox(
      child: Text("You are not signed in as the designated Arbiter.")
    ) 
    
    :
    
    Container(
      width: 650,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: 0.3,
        ),
      ),
      height: 650,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Arbitrate",  style: Theme.of(context).textTheme.headline5!,),
          const SizedBox(height: 20),
          Text("Amount in Escrow: ${widget.project.holding!}",
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
                    onChanged: (value) {
                      setState(() {
                        _useSlider = value;
                        _canSubmit = false;
                      });
                    },
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
                      value: _sliderValue,
                      min: 0,
                      max: widget.project.holding!,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                          _canSubmit = true;
                        });
                      },
                    )
                  : TextFormField(
                      controller: _awardToContractorController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      decoration:const  InputDecoration(
                        labelText: "Award to Contractor",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _canSubmit = double.tryParse(value) != null && double.parse(value) <= widget.project.holding!;
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
                    "Award to Backers",
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${awardToBackers.toStringAsFixed(2)}",
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
                    "${awardToContractor.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: isNegative ? Colors.red : null),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _canSubmit
                ? () async{
                    widget.project.arbiterAwardingContractor=double.parse( _awardToContractorController.text.toString());
                    await projectsCollection.doc(widget.project.contractAddress).set(widget.project.toJson());
                    widget.project.status='closed';
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
    );
  }
}