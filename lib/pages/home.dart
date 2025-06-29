import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Map<String, Map<String, String>> localizationsMap = {
  'ES': {
    'debug_mode_enabled': 'Modo debug activado',
    'timer_remainder_1': 'Intervalo de',
    'timer_remainder_2': 'minutos completado',
    'timer_remainder_3': 'minutos restantes',
    'timer_remainder_4': 'sigue asi',
    'timer_finish': 'Ejercicio completado, buen trabajo',
    'duration_slider_headline': '¿Cuanto vas a correr?',
    'minutes': 'minutos',
    'interval_slider_headline': '¿Cada cuanto te aviso?',
    'button_toast': '¡A por ello!',
    'button': 'Empezar',
  },
  'EN': {
    'debug_mode_enabled': 'Debug mode enabled',
    'timer_remainder_1': 'Interval of',
    'timer_remainder_2': 'minutes completed',
    'timer_remainder_3': 'minutes remaining',
    'timer_remainder_4': 'keep going',
    'timer_finish': 'Excercise completed, good job',
    'duration_slider_headline': '¿How much will you run?',
    'minutes': 'minutes',
    'interval_slider_headline': '¿How often I notify you?',
    'button_toast': '¡Go for it!',
    'button': 'Start',
  },
};

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  String _getDeviceLanguage() {
    String locale = Localizations.localeOf(context).languageCode.toUpperCase();
    return localizationsMap.containsKey(locale) ? locale : 'EN';
  }

  String _getLocalizedString(String key) {
    String language = _getDeviceLanguage();
    return localizationsMap[language]?[key] ?? key;
  }

  FlutterTts flutterTts = FlutterTts();
  bool _ttsReady = false;

  Future<void> _initTts() async {
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSharedInstance(
      true,
    ); // enable mixing with different audio sources
    setState(() {
      _ttsReady = true;
    });
  }

  Future<void> _ensureTts() async {
    if (!_ttsReady) await _initTts();
  }

  Future<void> _speak(String text) async {
    try {
      if (_ttsReady) {
        await flutterTts.speak(text);
      } else {
        await _initTts();
        await flutterTts.speak(text);
      }
    } catch (_) {
      await _initTts();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // register widget as listener
    _initTts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _ensureTts();
  }

  int _tapCount = 0;
  int _durationDivisions = 24;
  int _intervalDivisions = 12;

  void _handleTap() {
    setState(() {
      _tapCount++;
      if (_tapCount >= 10) {
        _tapCount = 0;
        _durationDivisions = 120;
        _intervalDivisions = 60;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getLocalizedString('debug_mode_enabled')),
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  double _duration = 30;
  double _interval = 5;
  Timer? _timer;

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

  void _startTimer() {
    WakelockPlus.enable(); // enable application to run in the background
    if (_timer != null) _timer!.cancel();

    int intervalSeconds = (_interval * 60).toInt();
    int elapsedMinutes = 0;
    int remainingMinutes = _duration.toInt();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      if (remainingMinutes > 0) {
        elapsedMinutes += _interval.toInt();
        remainingMinutes = _duration.toInt() - elapsedMinutes;
        _speak('${_getLocalizedString('timer_remainder_1')} ${_interval.toInt()} ${_getLocalizedString('timer_remainder_2')}, $remainingMinutes ${_getLocalizedString('time_remainder_3')}, ${_getLocalizedString('timer_remainder_4')}');
      } else {
        _speak(_getLocalizedString('timer_finish'));
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _handleTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Heading
              Text('Wayr', style: Theme.of(context).textTheme.headlineLarge),
              Text(
                '(why are you running)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 40),

              // Duration slider
              Text(
                _getLocalizedString('duration_slider_headline'),
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
                    TextSpan(text: ' ${_getLocalizedString('minutes')}'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Slider(
                value: _duration,
                max: 120,
                divisions: _durationDivisions,
                onChanged: _setDuration,
              ),
              SizedBox(height: 40),

              // Interval slider
              Text(
                _getLocalizedString('interval_slider_headline'),
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
                    TextSpan(text: ' ${_getLocalizedString('minutes')}'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Slider(
                value: _interval,
                max: 60,
                divisions: _intervalDivisions,
                onChanged: _setInterval,
              ),
              SizedBox(height: 40),

              // Button
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getLocalizedString('button_toast')),
                      duration: Duration(seconds: 4),
                    ),
                  );
                  _startTimer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_getLocalizedString('button')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
