import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _actualTime = 0;
  int _fakeTime = 0;
  int _currentTime = 0;
  bool _done = false;
  TextEditingController _controllerActualTime = TextEditingController();

  TextEditingController _controllerFakeTime = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    if (_fakeTime > 0) {
      Duration oneSec =
          Duration(milliseconds: (1000 * (_actualTime / _fakeTime)).round());
      timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_currentTime == 0) {
            setState(() {
              timer.cancel();
              _done = true;
            });
          } else {
            setState(() {
              _currentTime--;
            });
          }
        },
      );
    }
  }

  void stopTimer() {
    if (timer != null) {
      setState(() => timer!.cancel());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration myDuration = Duration(seconds: _currentTime);

    String mins = myDuration.inMinutes.remainder(60).toString();
    if (myDuration.inMinutes.remainder(60) < 10) {
      mins = "0${mins}";
    }
    String secs = myDuration.inSeconds.remainder(60).toString();
    if (myDuration.inSeconds.remainder(60) < 10) {
      secs = "0${secs}";
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(
                    width: 100,
                    child: Text(
                      "Actual Time [s]: ",
                      textAlign: TextAlign.end,
                    )),
                SizedBox(
                  width: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) => setState(() {
                      if (value.isEmpty) {
                        value = "0";
                      }
                      _actualTime = int.parse(value);
                    }),
                    textInputAction: TextInputAction.next,
                    controller: _controllerActualTime,
                  ),
                )
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    "Fake Time [s]: ",
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) => setState(() {
                      if (value.isEmpty) {
                        value = "0";
                      }
                      _fakeTime = int.parse(value);
                      _currentTime = _fakeTime;
                    }),
                    textInputAction: TextInputAction.done,
                    controller: _controllerFakeTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _done
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text("DONE",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 108,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                : Wrap(
                    children: [
                      //Minutes
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            Text(mins, style: const TextStyle(fontSize: 108)),
                      ),
                      //Seconds
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            Text(secs, style: const TextStyle(fontSize: 108)),
                      ),
                    ],
                  ),
            _done
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTime = _fakeTime;
                        _done = false;
                      });
                    },
                    child: const Text("Reset timer",
                        style: TextStyle(fontSize: 32)),
                  )
                : Wrap(
                    children: [
                      TextButton(
                        onPressed: startTimer,
                        child:
                            const Text("Start", style: TextStyle(fontSize: 32)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 7,
                      ),
                      TextButton(
                        onPressed: stopTimer,
                        child: const Text("Stop",
                            style: TextStyle(fontSize: 32, color: Colors.red)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
