import 'package:doncube/domain/account/account_service.dart';
import 'package:doncube/presentation/main/account_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) =>
          _TextEditingControllerWrapper(TextEditingController()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign in to instance'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<_TextEditingControllerWrapper>(
              builder: (context, wrapper, child) => Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Instance'),
                    autofocus: true,
                    autocorrect: false,
                    controller: wrapper.controller,
                  ),
                  const SizedBox(height: 64),
                  FlatButton(
                    onPressed: () {
                      final text = wrapper.controller.value.text;
                      _startAuthentication(context, text);
                    },
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
      BuildContext context, String hostname) async {
    // TODO(clicube): lock/unlock button
    // TODO(clicube): handle error
    final account = await context.read<AccountService>().signIn(hostname);
    final nextRoute = MaterialPageRoute<Object>(
        builder: (context) => AccountContext.mainPage(account));
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil<Object>(
      nextRoute,
      (route) => false,
    );
  }
}

class _TextEditingControllerWrapper {
  const _TextEditingControllerWrapper(this.controller);
  final TextEditingController controller;
}
