import 'package:doncube/presentation/signin/signin_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Doncube',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 64),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<Object>(
                    builder: (context) => const SignInPage(),
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Start'),
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
