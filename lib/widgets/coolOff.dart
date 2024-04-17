import 'dart:async';

import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final Duration duration;
  var projectDetailsState;
  Countdown({required this.duration, required this.projectDetailsState});

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final CountdownTimer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = CountdownTimer(duration: widget.duration, onTick: _onTick, onDone: _onDone);
    _countdownTimer.start();
  }

  @override
  void dispose() {
    _countdownTimer.dispose();
    super.dispose();
  }

  void _onTick(Duration remaining) {
    // Handle countdown tick (update UI if needed)
    setState(() {});
  }

  void _onDone() {
    widget.projectDetailsState.setState({widget.projectDetailsState.widget.cooling=false});
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _countdownTimer.remaining;
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes.remainder(60);
    final seconds = remainingTime.inSeconds.remainder(60);

    return Column(
      children: [
        SizedBox(height: 34),
        Text("Signing will be unlocked"),
        SizedBox(height: 20),
        Text(
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).indicatorColor, // Customize the color as desired
          ),
        ),
      ],
    );
  }
}

class CountdownTimer {
  final Duration duration;
  final Function(Duration) onTick;
  final VoidCallback onDone;
  late final Timer _timer;

  CountdownTimer({required this.duration, required this.onTick, required this.onDone});

  Duration get remaining => duration - Duration(seconds: _timer.tick);

  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), _onTimerTick);
  }

  void _onTimerTick(Timer timer) {
    onTick(remaining);
    if (_timer.tick >= duration.inSeconds) {
      _timer.cancel();
      onDone();
    }
  }

  void dispose() {
    _timer.cancel();
  }
}
