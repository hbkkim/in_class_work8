import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin{
  final AudioPlayer _player = AudioPlayer();
  Random random = Random();
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Repeatedly randomize the positions of the images
    Timer.periodic(Duration(seconds: 1), (timer) {
      _randomizePositions();
    });
  }

  void _playBackgroundMusic() async {
    await _player.setLoopMode(LoopMode.one); // Loop the music
    await _player.setAsset('assets/creepy-party.mp3');
    _player.play();
  }

  void _playSound() async {
    try {
      await _player.setAsset('assets/correct.mp3'); // Load the sound asset
      await _player.play(); // Play the sound
      _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player.stop(); // Stop the player after sound finishes playing
      }
      });
    } catch (e) {
      print("Error loading sound: $e");
    }
  }
  
  double xPosition1 = 0;
  double yPosition1 = 0;
  double xPosition2 = 0;
  double yPosition2 = 0;

  @override

  // Function to randomize the positions of the images
  void _randomizePositions() {
    setState(() {
      xPosition1 = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
      yPosition1 = random.nextDouble() * (MediaQuery.of(context).size.height - 200);

      xPosition2 = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
      yPosition2 = random.nextDouble() * (MediaQuery.of(context).size.height - 200);
    });

    // Restart the animation each time the position changes
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _player.dispose(); // Dispose the player when not needed
    _controller.dispose();
    super.dispose();
  }

  // Initial positions for the images
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Halloween.png'), // Background image asset
                  fit: BoxFit.cover, // Covers the entire background
                ),
              ),
            ),
            AnimatedPositioned(
              left: xPosition1,
              top: yPosition1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: _playSound,
                child: Image.asset(
                  'assets/pumpkin.png', // Replace with your image asset
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            AnimatedPositioned(
              left: xPosition1,
              top: yPosition1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: _playSound,
                child: Image.asset(
                  'assets/pumpkin.png', // Replace with your image asset
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
