import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'painter.dart';

/// Create a Circular Countdown Timer
class CircularCountDownTimer extends StatefulWidget {
  /// Filling Color for Countdown Timer
  final Color fillColor;

  /// Default Color for Countdown Timer
  final Color color;

  final Function on3secondsAgo;

  /// Function which will execute when the Countdown Ends
  final Function onComplete;

  /// Countdown Duration in Seconds
  final int duration;

  /// Width of the Countdown Widget
  final double width;

  /// Height of the Countdown Widget
  final double height;

  /// Border Thickness of the Countdown Circle
  final double strokeWidth;

  /// Text Style for Countdown Text
  final TextStyle textStyle;

  /// true for reverse countdown (max to 0), false for forward countdown (0 to max)
  final bool isReverse;

  CircularCountDownTimer(
      {@required this.width,
      @required this.height,
      @required this.duration,
      @required this.fillColor,
      @required this.color,
      this.isReverse,
      this.on3secondsAgo,
      this.onComplete,
      this.strokeWidth,
      this.textStyle})
      : assert(width != null),
        assert(height != null),
        assert(duration != null),
        assert(fillColor != null),
        assert(color != null);

  @override
  _CircularCountDownTimerState createState() => _CircularCountDownTimerState();
}

class _CircularCountDownTimerState extends State<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  bool flag = true;
  bool on3AgoFlag = true;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    String time =
        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    Duration forwardDuration = Duration(seconds: widget.duration);
    if (widget.isReverse == null || !widget.isReverse) {
      // For Forward Order
      print([duration.inSeconds, forwardDuration.inSeconds - 3, on3AgoFlag]);
      if (duration.inSeconds == forwardDuration.inSeconds - 3 && on3AgoFlag) {
        on3AgoFlag = false;
        if (widget.on3secondsAgo != null) {
          SchedulerBinding.instance
              .addPostFrameCallback((_) => widget.on3secondsAgo());
        }
      }
      if (forwardDuration.inSeconds == duration.inSeconds && flag) {
        flag = false;
        if (widget.onComplete != null) {
          SchedulerBinding.instance
              .addPostFrameCallback((_) => widget.onComplete());
        }
        return time;
      }
      return time;
    } else {
      // For Reverse Order
      if (duration.inSeconds == 3 && on3AgoFlag) {
        on3AgoFlag = false;
        if (widget.on3secondsAgo != null) {
          SchedulerBinding.instance
              .addPostFrameCallback((_) => widget.on3secondsAgo());
        }
      }
      if (controller.isDismissed && flag) {
        flag = false;
        if (widget.onComplete != null) {
          SchedulerBinding.instance
              .addPostFrameCallback((_) => widget.onComplete());
        }
        return '0:00';
      }
      return time;
    }
  }

  @override
  void initState() {
    super.initState();
    setAnimation();
  }

  @override
  void didUpdateWidget(CircularCountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    setAnimation();
  }

  void setAnimation() {
    flag = true;
    on3AgoFlag = true;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    if (widget.isReverse == null || !widget.isReverse) {
      controller.forward(from: controller.value);
    } else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                          animation: controller,
                                          fillColor: widget.fillColor,
                                          color: widget.color,
                                          strokeWidth: widget.strokeWidth)),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Text(
                                    timerString,
                                    style: widget.textStyle ??
                                        TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
