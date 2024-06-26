import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var map = [
    ['', ''],
    ['', ''],
    ['', ''],
    ['', ''],
    ['', ''],
    ['', ''],
    ['', ''],
    ['', ''],
    ['', ''],
  ];
  var count = 0;
  var x = [];
  var z = [];
  var w = [];
  final win = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];
  onTap(i) {
    if (w.isEmpty && (x.length + z.length) < 9) {
      count++;
      if (count.isOdd) {
        x.add(i);
        if (x.length > 2) {
          var index = 0;
          while (index < win.length && w.isEmpty) {
            var arr = win[index];
            var every = true;
            for (int id in arr) {
              if (!x.contains(id)) every = false;
            }
            if (every) w = arr;
            index++;
          }
          if (w.isNotEmpty) {
            setState(() {
              for (int id in w) {
                map[id][1] = 'X';
              }
            });
          }
        }
      } else {
        z.add(i);
        if (z.length > 2) {
          var index = 0;
          while (index < win.length && w.isEmpty) {
            var arr = win[index];
            var every = true;
            for (int id in arr) {
              if (!z.contains(id)) every = false;
            }
            if (every) w = arr;
            index++;
          }
          if (w.isNotEmpty) {
            setState(() {
              for (int id in w) {
                map[id][1] = 'O';
              }
            });
          }
        }
      }
      setState(() {
        map[i][0] = count.isOdd ? 'X' : 'O';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Tic-tac-toe';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 48.0),
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(colors: [
                      Colors.black,
                      Colors.white,
                    ], radius: 0.6, focal: Alignment.center),
                  ),
                  width: 240,
                  height: 240,
                  child: GridView.count(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                    children: List.generate(
                      9,
                      (i) => GestureDetector(
                        onTap: () {
                          onTap(i);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: map[i][1] == ''
                                ? Colors.white
                                : Colors.green[100],
                          ),
                          child: Center(
                            child: Text(
                              map[i][0],
                              style: const TextStyle(
                                  fontSize: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                x.length + z.length == 0
                    ? const SizedBox(
                        height: 32,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            map = [
                              ['', ''],
                              ['', ''],
                              ['', ''],
                              ['', ''],
                              ['', ''],
                              ['', ''],
                              ['', ''],
                              ['', ''],
                              ['', ''],
                            ];
                            count = 0;
                            x = [];
                            z = [];
                            w = [];
                          });
                        },
                        child: const Text('Start again'),
                      ),
              ],
            ),
          )),
    );
  }
}
