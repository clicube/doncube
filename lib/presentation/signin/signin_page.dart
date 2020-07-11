import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/presentation/main/session_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TextEditingController()),
        ChangeNotifierProvider(create: (context) => _SignInState())
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign in to instance'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer2<TextEditingController, _SignInState>(
              builder: (context, controller, signInState, child) => Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Instance'),
                    autofocus: true,
                    autocorrect: false,
                    controller: controller,
                  ),
                  const SizedBox(height: 64),
                  FlatButton(
                    onPressed: controller.text.isNotEmpty && !signInState.value
                        ? () {
                            _startAuthentication(
                              context,
                              controller.value.text,
                              signInState,
                            );
                          }
                        : null,
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
        ),
      ),
    );
  }

  Future<void> _startAuthentication(
      BuildContext context, String hostname, _SignInState _signInState) async {
    _signInState.value = true;
    final sessionService = context.read<SessionService>();
    Session session;
    try {
      session = await sessionService.signIn(hostname);
    } on Exception catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to sign in'),
      ));
      return;
    } finally {
      _signInState.value = false;
    }

    final nextRoute = MaterialPageRoute<Object>(
        builder: (context) => SessionContext.mainPage(session));
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil<Object>(
      nextRoute,
      (route) => false,
    );
  }
}

class _SignInState extends ValueNotifier<bool> {
  _SignInState() : super(false);
}
