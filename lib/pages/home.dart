import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _duration = 30;
  double _interval = 5;

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
          ],
        ),
      ),
    );
  }
}
