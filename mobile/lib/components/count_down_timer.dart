import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'dart:async';

import 'package:food_app/utils/funcs.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.startTime, required this.totalTime});

  final DateTime startTime;
  final int totalTime;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int _seconds = 10; // Set your countdown time here
  Timer? _timer;
  bool endTimer = false;
  double _percentage = 0;
  bool initialized = false;

  _configureTimer() {
    DateTime startTime = widget.startTime.toLocal();
    DateTime endTime = startTime.add(Duration(minutes: widget.totalTime));
    DateTime timerStart = DateTime.now();
    if (timerStart.isBefore(endTime)) {
      Duration difference = endTime.difference(timerStart);
      setState(() {
        _seconds = difference.inSeconds;
      });
      print("seconds: $_seconds");
      if (_timer != null) {
        _timer!.cancel();
      }
      // percentage = difference(DateTime.now() paidTime)/difference(paidTime endTime)
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
            _percentage = DateTime.now().difference(widget.startTime).inSeconds /
                endTime.difference(widget.startTime).inSeconds;

            initialized = true;
          } else {
            _timer!.cancel();
          }
        });
      });
    } else {
      setState(() {
        endTimer = true;
        _percentage = 1;
        initialized=true;
      });
    }
  }

  @override
  void initState() {
    _configureTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: initialized ? 1 : 0,
      duration: const Duration(milliseconds: 100),
      child: Center(
        child: SizedBox(
          width: dimmension(70, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: dimmension(50, context),
                height: dimmension(50, context),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.timer_outlined,
                        size: dimmension(53, context),
                        color: endTimer ? greenColor : borderColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: dimmension(7.5, context),
                          left: dimmension(3, context),
                        ),
                        child: SizedBox(
                          width: dimmension(35, context),
                          height: dimmension(35, context),
                          child: CircularProgressIndicator(
                            color: greenColor,
                            backgroundColor: borderColor,
                            value: _percentage,
                            strokeCap: StrokeCap.round,
                            strokeWidth: dimmension(4, context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: dimmension(15, context)),
              endTimer
                  ? Container()
                  : Text(
                      formatTime(_seconds),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: yellowColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
