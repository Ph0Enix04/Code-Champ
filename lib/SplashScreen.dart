import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'AuthGate.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _captionController;
  late Animation<double> _captionAnimation;
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();

    // Logo Bounce
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Caption Fade-in
    _captionController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    _captionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _captionController, curve: Curves.easeIn),
    );

    // Bubble Wiggling
    _bubbleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);

    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _captionController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BubbleBackground(controller: _bubbleController), // bubbles background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_logoAnimation.value - 70),
                      child: Image.asset('lib/assets/logo.png', width: 200),
                    );
                  },
                ),
                //SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _captionAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _captionAnimation.value,
                      child: Transform.scale(
                        scale: 0.8 + (_captionAnimation.value * 0.2),
                        child: Transform.translate(
                          offset: Offset(0, -50),
                          child: const Text(
                            "Code, Create, Conquer",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Bubble Background with Wiggling Effect
class BubbleBackground extends StatelessWidget {
  final AnimationController controller;
  final Random random = Random();

  BubbleBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.indigoAccent, Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Wiggling bubbles
        ...List.generate(15, (index) {
          double size = random.nextDouble() * 40 + 20; // 20px - 60px
          double left = random.nextDouble() * MediaQuery.of(context).size.width;
          double top = random.nextDouble() * MediaQuery.of(context).size.height;

          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                left: left + sin(controller.value * 2 * pi) * 5, // left right
                top: top + cos(controller.value * 2 * pi) * 5, // up down
                child: child!,
              );
            },
            child: _buildBubble(size),
          );
        }),
      ],
    );
  }

  // Bubble Styling
  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white60.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.white60.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }
}
