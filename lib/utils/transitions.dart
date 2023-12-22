



import 'package:flutter/material.dart';

class SmoothSizeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;

  SmoothSizeTransition({Key? key, required this.child, this.duration = const Duration(milliseconds: 500)}) : super(key: key);

  @override
  _SmoothSizeTransitionState createState() => _SmoothSizeTransitionState();
}

class _SmoothSizeTransitionState extends State<SmoothSizeTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Widget? _oldChild;
  double _oldHeight = 0.0;
  double _newHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _oldChild = widget.child;
  }

  @override
  void didUpdateWidget(SmoothSizeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _oldHeight = _newHeight;
      _oldChild = widget.child;
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.reverse) {
              _newHeight = constraints.maxHeight;
            }
            return SizedBox(
              height: (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.reverse) ? (_oldHeight + (_newHeight - _oldHeight) * _animation.value) : _newHeight,
              child: child,
            );
          },
        );
      },
      child: _oldChild,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class StepProgressIndicator extends StatelessWidget {
  int currentStep; // Current step in the process (1 to 6)

  StepProgressIndicator({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    currentStep =currentStep+ 2; // Adjust the step inside the build method
    return Container(
      
     padding: EdgeInsets.only(left:this.currentStep==2?0:80),
      child: SizedBox(
        width:200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) => _buildStepIndicator(index, context)),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int index, BuildContext context) {
    bool isCompleted = index < currentStep - 1;
    return Expanded(
      child: Container(
       
        height: 4, // Smaller height for a more discrete look
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          
          color: isCompleted ? Theme.of(context).highlightColor.withOpacity(0.3) : Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: Theme.of(context).indicatorColor.withOpacity(0.2), // Adjust the color to match your theme
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}

