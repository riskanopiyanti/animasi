import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(VeggieHubApp());
}

class VeggieHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _textOpacity;
  bool _isTextVisible = true;

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Animasi pergerakan untuk Logo (jatuh dan memantul)
    _logoAnimation = Tween<Offset>(
      begin: Offset(0, 0), 
      end: Offset(0, 0.4), 
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Animasi pergerakan untuk Teks
    _textAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.4),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Animasi untuk Opacity Teks
    _textOpacity = Tween<double>(
      begin: 1.0, 
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fungsi untuk memulai animasi ketika elemen diklik
  void _startAnimation() {
    if (_controller.isAnimating) return;

    setState(() {
      _isTextVisible = false; 
    });

    // Mulai animasi jatuh logo ke bayangan dan memantul
    _controller.forward(from: 0).then((_) {
      // Setelah animasi selesai, logo kembali ke posisi semula
      _controller.reverse().then((_) {
        setState(() {
          _isTextVisible =
              true;  s
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background full-screen
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Logo dengan animasi pergerakan jatuh dan memantul
          Positioned(
            top: 260,
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: GestureDetector(
              onTap: _startAnimation, 
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return child!;
                },
                child: SlideTransition(
                  position: _logoAnimation,
                  child: Image.asset(
                    'assets/logo veggiehub.png',
                    width: 160,
                    height: 160,
                  ),
                ),
              ),
            ),
          ),
          // Teks dengan animasi pergerakan, opacity dan zoom
          Positioned(
            top: 340, 
            left: MediaQuery.of(context).size.width / 2 -
                200, 
            child: AnimatedOpacity(
              opacity: _isTextVisible ? 1.0 : 0.0, 
              duration: Duration(seconds: 1),
              child: ScaleTransition(
                scale: _textOpacity,
                child: SlideTransition(
                  position: _textAnimation,
                  child: Image.asset(
                    'assets/teks.png',
                    width: 400,
                    height: 250,
                  ),
                ),
              ),
            ),
          ),
          // Bayangan statis tanpa animasi
          Positioned(
            top: 460, // 
            left: MediaQuery.of(context).size.width / 2 - 120,
            child: Image.asset(
              'assets/bayangan.png', 
              width: 250,
              height: 150, 
            ),
          ),
        ],
      ),
    );
  }
}
