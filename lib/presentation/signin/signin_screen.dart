import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to instance'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Instance'),
                autofocus: true,
                autocorrect: false,
              ),
              const SizedBox(height: 48),
              FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Next'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
