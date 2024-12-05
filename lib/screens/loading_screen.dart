import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_note_app/app_assets.dart';
import 'package:simple_note_app/screens/home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {

    Future.delayed(const Duration(seconds: 1), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Container(
          child: SvgPicture.asset(AppAssets.mainLogo,
          color: Theme.of(context).colorScheme.secondaryContainer,
          height: 200,
          width: 200,
          ),
        ),
      )
      );
  }
}