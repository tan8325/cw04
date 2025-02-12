import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heartbeat Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const HeartBeatScreen(),
    );
  }
}

class HeartBeatScreen extends StatefulWidget {
  const HeartBeatScreen({super.key});

  @override
  _HeartBeatScreenState createState() => _HeartBeatScreenState();
}

class _HeartBeatScreenState extends State<HeartBeatScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  int _seconds = 30;
  Timer? _timer;
  bool _animationStarted = false;
  String _partnerName = "";
  final TextEditingController _nameController = TextEditingController();

  final List<String> _messages = [
    "Love is in the air!", "Happy Valentine's Day!", "You make my heart race!",
    "Forever and always ❤️", "You are my heartbeat!"
  ];
  int _currentMessageIndex = 0;

  void _startAnimation() {
    if (_partnerName.isEmpty) return;

    setState(() {
      _animationStarted = true;
      _seconds = 30;
    });

    _startHeartbeat();
    _startTimer();
  }

  void _startHeartbeat() {
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) {
        timer.cancel();
      } else {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _seconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
          _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_animationStarted) ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    width: _isExpanded ? 200 : 170,
                    height: _isExpanded ? 200 : 170,
                    child: Image.asset("assets/images/heart.png"),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Time left: $_seconds s",
                    style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "${_messages[_currentMessageIndex]} ${_partnerName.isNotEmpty ? _partnerName : ''}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
                if (!_animationStarted) _buildStartBox(),
              ],
            ),
          ),
          _buildFloatingHearts(),
        ],
      ),
    );
  }

  Widget _buildStartBox() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter your partner's name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _partnerName = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, size: 60, color: Colors.pink),
            onPressed: _startAnimation,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingHearts() {
    return Stack(
      children: List.generate(10, (index) {
        return AnimatedPositioned(
          duration: Duration(seconds: 5 + index),
          left: (index * 40).toDouble(),
          bottom: _isExpanded ? 0 : -100,
          child: Icon(
            Icons.favorite,
            color: Colors.pink.withOpacity(0.6),
            size: 30 + (index % 3 * 10),
          ),
        );
      }),
    );
  }
}
