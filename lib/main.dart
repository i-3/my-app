import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

void main() {
  // print('Let\'s go!');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class MyAppState with ChangeNotifier {
  String _name = '';
  var selectedIndex = 0;
  get getName => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pass = '';
    return Scaffold(
        appBar: AppBar(
          title: const Text('AuthScreen'),
        ),
        body: Center(
          child: SizedBox(
            width: 200,
            height: 600,
            child: Column(
              children: [
                const SizedBox(height: 48),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name (not empty)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: appState.setName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password (123)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    pass = value;
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: Container(
                    alignment: Alignment.center,
                    width: 96,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: Colors.blue[100],
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  onPressed: () {
                    if (appState._name != '' && pass == '123') {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${appState._name}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 550) {
            return Column(
              children: [
                Expanded(
                  child: appState.selectedIndex == 0
                      ? const TicTacToe()
                      : FlutterMap(
                          options: const MapOptions(
                            initialCenter: LatLng(56.95, 24.1),
                            initialZoom: 12.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              tileProvider: CancellableNetworkTileProvider(),
                            ),
                          ],
                        ),
                ),
                SafeArea(
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.grid_3x3),
                        label: 'TicTacToe',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.map),
                        label: 'Map',
                      ),
                    ],
                    currentIndex: appState.selectedIndex,
                    onTap: (value) {
                      appState.setIndex(value);
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.grid_3x3),
                        label: Text('TicTacToe'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.map),
                        label: Text('Map'),
                      ),
                    ],
                    selectedIndex: appState.selectedIndex,
                    onDestinationSelected: (value) {
                      appState.setIndex(value);
                    },
                  ),
                ),
                Expanded(
                  child: appState.selectedIndex == 0
                      ? const TicTacToe()
                      : FlutterMap(
                          options: const MapOptions(
                            initialCenter: LatLng(56.95, 24.1),
                            initialZoom: 12.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              tileProvider: CancellableNetworkTileProvider(),
                            ),
                          ],
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});
  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

getDefault() {
  var l = [];
  for (var i = 0; i < 9; i++) {
    l.add(['', '']);
  }
  return l;
}

class _TicTacToeState extends State<TicTacToe> {
  var grid = getDefault();
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
                grid[id][1] = 'X';
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
                grid[id][1] = 'O';
              }
            });
          }
        }
      }
      setState(() {
        grid[i][0] = count.isOdd ? 'X' : 'O';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      color:
                          grid[i][1] == '' ? Colors.white : Colors.green[100],
                    ),
                    child: Center(
                      child: Text(
                        grid[i][0],
                        style:
                            const TextStyle(fontSize: 50, color: Colors.grey),
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
                      grid = getDefault();
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
    );
  }
}
