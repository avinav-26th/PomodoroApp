// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Pomodoro(),
      ),
    );

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  double percent = 0;
  static int TimeInMinute = 25;
  String btnText = "Start Studying";

  late Timer timer;
  int tapCount = 0, tapCountRed = 0;
  bool visibilityIndex = false;

  resetFunc() {
    setState(() {
      timer.cancel();
      percent = 0;
      TimeInMinute = 25;
      btnText = "Restart";
    });
  }

  _StartTimer() {
    if (tapCount >= 1) {
      resetFunc();
    }
    if (tapCountRed > 0) {
      tapCountRed = 0;
      btnText = "Start Studying";
    } else {
      btnText = "Restart";
    }

    int Time = TimeInMinute * 60;
    double SecPercent = (Time / 100);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (Time > 0) {
          Time--;
          if (Time % 60 == 0) {
            // this means that a minute has passed
            TimeInMinute--;
          }
          if (Time % SecPercent == 0) {
            //we want to see 1% is equal to how many seconds for our progress bar
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          TimeInMinute = 25;
          timer.cancel();
        }
      });
    });
    tapCount++;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff1542bf), Color(0xff51a8ff)],
            begin: FractionalOffset(0.5, 1),
          )),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  'Pomodoro Clock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                  ),
                ),
              ),
              Expanded(
                child: CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 85.0,
                  lineWidth: 10.0,
                  progressColor: Colors.white,
                  center: Text(
                    "$TimeInMinute",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 68.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      'Study Time',
                                      style: TextStyle(
                                        fontSize: 28.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '25',
                                      style: TextStyle(
                                        fontSize: 65.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      'Pause Time',
                                      style: TextStyle(
                                        fontSize: 28.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '5',
                                      style: TextStyle(
                                        fontSize: 65.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TextButton(
                            onPressed: () {
                              visibilityIndex = true;
                              _StartTimer();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                btnText,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 21.0),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Visibility(
                            visible: visibilityIndex,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 30,
                              height: 30,
                              child: ElevatedButton(
                                child: null,
                                onPressed: () {
                                  visibilityIndex = false;
                                  tapCount = 0;
                                  setState(() {
                                    timer.cancel();
                                    percent = 0;
                                    TimeInMinute = 0;
                                  });
                                  tapCountRed++;
                                  _StartTimer();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
