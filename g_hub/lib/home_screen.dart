import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:g_hub/shorts_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 50,
            spawnMinSpeed: 10.00,
            particleCount: 68,
            spawnMaxSpeed: 50,
            minOpacity: 0.3,
            spawnOpacity: 0.4,
            baseColor: Colors.blue,
            image: Image(image: AssetImage('assets/buuble.png')),
          ),
        ),
        vsync: this,
        child: Stack(children: [
          Center(
            child: RawMaterialButton(
              padding: const EdgeInsets.all(10.0),
              elevation: 12.0,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ShortsScreen()));
              },
              shape: const CircleBorder(
                  side: BorderSide(color: Colors.blue, width: 2.0)),
              fillColor: Colors.black,
              child: const Icon(
                Icons.play_arrow,
                size: 60.0,
                color: Colors.blue,
              ),
            ),
          ),
          const Positioned(
            left: 30.0,
            bottom: 300.0,
            child: Text(
              'To play shorts press play button',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 25),
            ),
          )
        ]),
      ),
    );
  }
}
