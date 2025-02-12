import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late int duration;
  late Timer periodictimer;
  double _opacity = 0.0;
  String _message = "";
  final TextEditingController _controller = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
      ConfettiController(duration: const Duration(days: 1));
    duration = 1000;
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: duration));
    animation = Tween<double>(begin: 100.0, end: 200.0).animate(controller);
    controller.forward();
    if(controller.isCompleted){
      controller.reverse();
    }
    else{
      controller.forward();
    }
    controller.repeat();
    startTimer();



  }
  int duration_remaining = 1500;
  late Timer _timer;
  void startTimer(){
      _timer = Timer.periodic(Duration(milliseconds: 1500), (timer){
        setState(() {
          if (duration_remaining > 0){
            duration_remaining -= 1;
          }
          else {
            _timer.cancel();
          }
        });

      
      });
  }

  void _triggerConfetti() {
    _confettiController.play();
    Future.delayed(const Duration(seconds: 5), () {
      _confettiController.stop();
    });
  }

  void _showMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _message = _controller.text;
      _opacity = 1.0;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    _controller.clear();
  }




  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: 
      Stack(
        children: <Widget>[
          // Confetti in the background
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2, // Confetti falls down
                maxBlastForce: 20, // Confetti speed
                minBlastForce: 10,
                emissionFrequency: 0.1,
                numberOfParticles: 30,
                gravity: 0.2,
              ),
            ),
      
      Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[          
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacity,
              child: _message.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        _message,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  : const SizedBox(),
            ),
            Text("$duration_remaining"),

            AnimatedBuilder(
                
                animation: animation,

                builder:(context, child) {
                    return Container(
                      width: animation.value,
                      height: animation.value,
                      child:Image.asset("assets/images/heart.png"));
                    
                },

              ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a Valentine's Day Message...",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showMessage,
              child: const Text("Show Message"),
            ),
          ],
        ),
      ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _triggerConfetti,
        tooltip: 'Celebrate',
        child: const Icon(Icons.favorite),
      ),    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
