import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedStatsDisplay extends StatefulWidget {
  @override
  _AnimatedStatsDisplayState createState() => _AnimatedStatsDisplayState();
}

class _AnimatedStatsDisplayState extends State<AnimatedStatsDisplay> with TickerProviderStateMixin {
  final Map<String, int> data = {
    'Ongoing Disputes': 0,
    'Open Projects': 14,
    'Active Projects': 5,
    'Total XTZ Earned': 44301,
    'Total USDT Earned': 55000,
  };

  List<AnimationController> _numberControllers = [];
  List<Animation<int>> _numberAnimations = [];
  List<AnimationController> _opacityControllers = [];
  List<Color> _valueColors = [];

  @override
  void initState() {
    super.initState();

    int delay = 0;
    data.forEach((key, value) {
      final numberController = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
      );
      final opacityController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );

      _numberControllers.add(numberController);
      _numberAnimations.add(IntTween(begin: 0, end: value).animate(numberController)
        ..addListener(() {
          final int currentValue = _numberAnimations[_numberControllers.indexOf(numberController)].value;
          if (currentValue == value) {
            setState(() {
              _valueColors[_numberControllers.indexOf(numberController)] = Theme.of(context).indicatorColor;
            });
          }
        }));
      _opacityControllers.add(opacityController);
      _valueColors.add(Colors.grey); // Initial color for each value

      Future.delayed(Duration(milliseconds: delay), () {
        opacityController.forward();
        numberController.forward();
      });

      delay += 300; // Increment delay for staggered appearance
    });
  }

  @override
  void dispose() {
    for (var controller in _numberControllers) {
      controller.dispose();
    }
    for (var controller in _opacityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildStatItem(String label, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0), // More space between the stat items
      child: FadeTransition(
        opacity: _opacityControllers[index].drive(CurveTween(curve: Curves.easeOut)),
        child: Padding(
          padding: const EdgeInsets.only(top:38.0,left:20,right:20,bottom:0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8), // More space between label and value
              AnimatedBuilder(
                animation: _numberAnimations[index],
                builder: (_, child) => Text(
                  '${_numberAnimations[index].value}',
                  style: TextStyle(
                    fontSize: 22, // Larger font size for the value
                    color: _valueColors[index], // Color that changes once counting completes
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> statWidgets = List.generate(data.length, (index) {
      String key = data.keys.elementAt(index);
      return _buildStatItem(key, index);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        // bool useVerticalLayout = constraints.maxWidth < 600;
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal:80.0, vertical: 23),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runAlignment: WrapAlignment.center,
            spacing:20, // Horizontal space between items
            runSpacing: 20, // Vertical space between lines
            children: statWidgets,
          ),
        );
      },
    );
  }
}
