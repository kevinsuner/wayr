import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts();
  bool _ttsReady = false;
  Timer? _timer;
  double _duration = 30;
  double _interval = 5;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _setDuration(double value) {
    setState(() {
      _duration = value;
    });
  }

  void _setInterval(double value) {
    setState(() {
      _interval = value;
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSharedInstance(true);

    setState(() {
      _ttsReady = true;
    });
  }

  Future<void> _speak(String text) async {
    if (_ttsReady) {
      await flutterTts.speak(text);
    }
  }

  void _startTimer() {
    WakelockPlus.enable();
    if (_timer != null) _timer!.cancel();

    int intervalSeconds = (_interval * 60).toInt();
    int elapsedMinutes = 0;
    int remainingMinutes = _duration.toInt();

    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      if (remainingMinutes > 0) {
        elapsedMinutes += _interval.toInt();
        remainingMinutes = _duration.toInt() - elapsedMinutes;
        _speak(
          'Intervalo de ${_interval.toInt()} minutos completado, $remainingMinutes minutos restantes',
        );
      } else {
        _speak('Ejercicio completado');
        _timer?.cancel();
        _timer = null;
        WakelockPlus.disable();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Wayr', style: Theme.of(context).textTheme.headlineLarge),
            Text(
              '(why are you running)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            SizedBox(height: 40),

            Text(
              '¿Cuanto vas a correr?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineSmall,
                children: [
                  TextSpan(
                    text: _duration.toInt().toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' minutos'),
                ],
              ),
            ),

            SizedBox(height: 20),

            Slider(
              value: _duration,
              max: 120,
              divisions: 24,
              onChanged: _setDuration,
            ),

            SizedBox(height: 40),

            Text(
              '¿Cada cuanto te aviso?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineSmall,
                children: [
                  TextSpan(
                    text: _interval.toInt().toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' minutos'),
                ],
              ),
            ),

            SizedBox(height: 20),

            Slider(
              value: _interval,
              max: 60,
              divisions: 12,
              onChanged: _setInterval,
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: _startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Empezar'),
            ),
          ],
        ),
      ),
    );
  }
}
