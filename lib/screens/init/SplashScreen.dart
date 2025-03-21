import 'package:flutter/material.dart';

import '../../utils/auth_checker.dart';

// SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final double _defaultLogoHeight = 300;
  final double _expandedImageHeight = 600;

  final String defaultLogo = "assets/images/logo-bg-icon-color.png";
  final String animatedLogo = "assets/images/logo-bg-icon-color-gray.png";

  double _initialImageHeight = 300;
  String _displayLogo = "assets/images/logo-bg-icon-color.png";

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  _authenticateUser() async {
    navigateByAuth(context, mounted);
  }

  Future<void> _refreshScreen() async {
    if (mounted) {
      setState(() {
        _displayLogo = animatedLogo;
        _initialImageHeight = _expandedImageHeight;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _displayLogo = defaultLogo;
          _initialImageHeight = _defaultLogoHeight;
        });
      }
    });
    await Future.delayed(const Duration(seconds: 3), () => _authenticateUser());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (kDebugMode) {
    //       print("StreamBuilder snapshot connectionState: ${snapshot.connectionState.name}");
    //       print("StreamBuilder snapshot data: ${snapshot.data}");
    //     }
    //     if (snapshot.connectionState == ConnectionState.active) {
    //       return AuthChecker();
    //     }
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Opacity(
                //   opacity: 0.8,
                //   child: Image.asset(
                //     defaultLogo,
                //     height: 300,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Center(
                  child: GestureDetector(
                    onDoubleTap: _refreshScreen,
                    child: AnimatedContainer(
                      height: _initialImageHeight,
                      curve: Curves.easeInOutExpo,
                      duration: const Duration(milliseconds: 200),
                      child: Image.asset(
                        _displayLogo,
                        height: _initialImageHeight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -8,
            left: -20,
            child: Image.asset(
              'assets/images/splash-screen-parking.png',
              height: 375.0,
            ),
          ),
        ],
      ),
    );
    //   },
    // );
  }
}
