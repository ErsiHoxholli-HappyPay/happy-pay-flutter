import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      _initApp(), // your real init logic
      Future.delayed(const Duration(seconds: 3)),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/get_started');
  }

  Future<void> _initApp() async {
    // auth check, remote config, prefs load, etc.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 154, 16, 16),
              Color.fromARGB(255, 15, 5, 157),
            ],
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
          ),
        ),

        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Image.asset(
              'lib/assets/image.png',
              width: 200,
              height: 200,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
