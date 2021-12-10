import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/credential.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return Vault(secret: 'abcdabcdabcdabcd');
      },
      child: const MyApp()));
}

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
        routes: {'/form': (context) => const CredentialForm()});
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
          child: Consumer<Vault>(
        builder: (context, vault, child) => vault.credentials.isNotEmpty
            ? ListView.separated(
                itemCount: vault.credentials.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(thickness: 1),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(vault.credentials[index].username),
                    onTap: () {
                      Navigator.pushNamed(context, '/form',
                          arguments: vault.credentials[index]);
                    },
                    subtitle: Text(vault.credentials[index].description ?? ''),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title:
                                          const Text('Are you sure to delete?'),
                                      content:
                                          const Text('Yes, just delete it'),
                                      actions: [
                                        TextButton(
                                            child: const Text('Ok'),
                                            onPressed: () {
                                              vault.remove(
                                                  vault.credentials[index]);
                                              Navigator.pop(context, 'OK');
                                            }),
                                      ]));
                        }),
                  );
                })
            : const Center(child: Text('No credentials')),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/form'),
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
  String? _url;
  String? _description;
  String? _category;
  String? _tmpDialogCat;
  bool _showPassword = false;

  final List<String> _newCat = [];

  @override
  Widget build(BuildContext context) {
    final cred = ModalRoute.of(context)!.settings.arguments as Credential?;
    // if (cred?.category != null) {
    //   _newCat.add(cred!.category!);
    // }
    List<String> categories = _newCat
      ..addAll(Provider.of<Vault>(context).categories);

    return Scaffold(
        appBar: AppBar(
          title: cred == null
              ? const Text('Create a new credential')
              : const Text('Edit credential'),
        ),
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                              initialValue: cred?.username,
                              onSaved: (s) => _username = s,
                              validator: (s) {
                                if (s == '') {
                                  return 'Required field';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter username'))),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                              initialValue: cred?.password,
                              onSaved: (s) => _password = s,
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                  hintText: 'Enter password',
                                  suffixIcon: IconButton(
                                      icon: Icon(_showPassword? Icons.visibility: Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      })),
                              validator: (s) {
                                if (s == '') {
                                  return 'Required field';
                                }
                                return null;
                              })),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              initialValue: cred?.description,
                              onSaved: (s) => _description = s,
                              decoration: const InputDecoration(
                                  hintText: 'Enter description'))),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                              initialValue: cred?.url,
                              onSaved: (s) => _url = s,
                              decoration: const InputDecoration(
                                  hintText: 'Enter url'))),
                      Row(children: [
                        Expanded(
                            child: DropdownButtonFormField<String>(
                          onChanged: (s) {},
                          value: cred?.category,
                          decoration: const InputDecoration(
                              hintText: 'Select a category'),
                          onSaved: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _category = newValue;
                              });
                            }
                          },
                          items: categories
                              .toSet()
                              .toList()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                        Flexible(
                            flex: 0,
                            child: TextButton(
                                child: const Text('Add'),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Add category'),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(onChanged: (s) {
                                              _tmpDialogCat = s;
                                            }),
                                          ]),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            _tmpDialogCat = null;
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (_tmpDialogCat != null) {
                                              setState(() {
                                                _newCat.add(_tmpDialogCat!);
                                              });
                                            }
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                })),
                      ]),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (cred != null) {
                                  cred
                                    ..username = _username!
                                    ..password = _password!
                                    ..url = _url!
                                    ..category = _category!
                                    ..description = _description!;

                                  setState(() {
                                    Provider.of<Vault>(context, listen: false)
                                        .update(cred);
                                  });
                                } else {
                                  var cred = Credential(
                                      username: _username!,
                                      password: _password!,
                                      url: _url,
                                      category: _category,
                                      description: _description);
                                  setState(() {
                                    Provider.of<Vault>(context, listen: false)
                                        .add(cred);
                                  });
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: cred == null
                                ? const Text('Create')
                                : const Text('Save'),
                          )),
                    ])))));
  }
}
