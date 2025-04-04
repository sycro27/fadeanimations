import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AnimationsDemo(),
    );
  }
}

class AnimationsDemo extends StatefulWidget {
  const AnimationsDemo({Key? key}) : super(key: key);

  @override
  State<AnimationsDemo> createState() => _AnimationsDemoState();
}

class _AnimationsDemoState extends State<AnimationsDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    // Start the implicit animation after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Explicit Animation Example
            const Text(
              'Explicit Animation (AnimationController)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                width: 150,
                height: 150,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const FlutterLogo(
                  size: 120,
                  style: FlutterLogoStyle.markOnly,
                ),
              ),
            ),

            const SizedBox(height: 60),

            const Text(
              'Implicit Animation (AnimatedContainer)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              curve: Curves.easeIn,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                width: 150,
                height: 150,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _isVisible ? Colors.green : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const FlutterLogo(
                  size: 120,
                  style: FlutterLogoStyle.markOnly,
                ),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                _controller.reset();
                _controller.forward();
                setState(() {
                  _isVisible = false;
                });
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    _isVisible = true;
                  });
                });
              },
              child: const Text('Replay Animations'),
            ),
          ],
        ),
      ),
    );
  }
}
