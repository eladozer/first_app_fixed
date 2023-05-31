import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class MyCircularProgressIndicator extends StatefulWidget {
  final double currentProtein;
  final double totalProtein;

  MyCircularProgressIndicator({
    required this.currentProtein,
    required this.totalProtein,
  });

  @override
  _MyCircularProgressIndicatorState createState() =>
      _MyCircularProgressIndicatorState();
}

class _MyCircularProgressIndicatorState
    extends State<MyCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  var _animationController;
  var _animation;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 500), // Set the duration of the animation
    );

    // Create a Tween to define the range of values for the animation
    final double beginValue = 0.0;
    final double endValue = widget.currentProtein / widget.totalProtein;
    final Tween<double> tween = Tween(begin: beginValue, end: endValue);

    // Create the animation using the Tween and the AnimationController
    _animation = tween.animate(_animationController)
      ..addListener(() {
        setState(() {
          _progressValue = _animation.value;
        });
      });

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: _progressValue,
      valueColor: _progressValue >= 1.0
          ? AlwaysStoppedAnimation<Color>(Colors.white)
          : AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }
}

void main() {
  runApp(MyCircularProgressIndicator(currentProtein: 40, totalProtein: 120));
}
