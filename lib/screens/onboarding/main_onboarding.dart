import 'package:flutter/material.dart';

class MainOnboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateMainOnboarding();
}

class _StateMainOnboarding extends State<MainOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PageView(children: [Homeonboard()]));
  }

  Widget Homeonboard() {
    return Column(children: [Container()]);
  }
}
