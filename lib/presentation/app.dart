import 'package:flutter/material.dart';

import 'signin/signin_screen.dart';

class DoncubeApp extends StatelessWidget {
  const DoncubeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Doncube',
      home: const SignInScreen(),
    );
  }
}
