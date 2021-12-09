import 'package:flutter/material.dart';
import 'models/credential.dart';

void main() {
  runApp(const MyApp());
}

// key must be length 16
var vault = Vault('abcdabcdabcdabcd');

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Derek\'s Vault',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(title: 'Vault'),
        routes: {'/new': (context) => const CredentialForm()});
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ListView(
            children: vault.credentials
                .map((cred) => ListTile(title: Text(cred.username)))
                .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/new'),
        tooltip: 'New credential',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CredentialForm extends StatefulWidget {
  const CredentialForm({Key? key}) : super(key: key);

  @override
  State<CredentialForm> createState() => _CredentialForm();
}

class _CredentialForm extends State<CredentialForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create a new credential'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                          onSaved: (s) => _username = s,
                          validator: (s) {
                            if (s == '') {
                              return 'Required field';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter username')),
                      TextFormField(
                          onSaved: (s) => _password = s,
                          obscureText: true,
                          decoration:
                              const InputDecoration(hintText: 'Enter password'),
                          validator: (s) {
                            if (s == '') {
                              return 'Required field';
                            }
                            return null;
                          }),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                var cred =
                                    Credential(_username!, _password!, '');
                                setState(() {
                                  vault.add(cred);
                                });
                                Navigator.pushReplacementNamed(context, '/');
                              }
                            },
                            child: const Text('Submit'),
                          )),
                    ]))));
  }
}
