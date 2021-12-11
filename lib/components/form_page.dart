import 'package:firstweb/components/password_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/credential.dart';

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
    final cred = ModalRoute.of(context)!.settings.arguments as Cred?;
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
                                      labelText: 'Username',
                                      hintText: 'Enter username'))),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                  initialValue: cred?.password,
                                  onSaved: (s) => _password = s,
                                  obscureText: !_showPassword,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Enter password',
                                      suffixIcon: IconButton(
                                          icon: Icon(_showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
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
                                      labelText: 'Description',
                                      hintText: 'Enter description'))),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                  initialValue: cred?.website,
                                  onSaved: (s) => _url = s,
                                  decoration: const InputDecoration(
                                      labelText: 'Website',
                                      hintText: 'Enter url'))),
                          Row(children: [
                            Expanded(
                                child: DropdownButtonFormField<String>(
                              onChanged: (s) {},
                              value: cred?.category,
                              decoration: const InputDecoration(
                                  labelText: 'Category',
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
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                                Navigator.pop(
                                                    context, 'Cancel');
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
                                      var c = cred.copyWith(
                                        username : _username!,
                                        password : _password!,
                                        website : _url,
                                        category : _category,
                                        description : _description,
                                      );

                                      setState(() {
                                        Provider.of<Vault>(context,
                                                listen: false)
                                            .update(cred, c);
                                      });
                                    } else {
                                      var cred = Cred(
                                          username: _username!,
                                          password: _password!,
                                          website: _url,
                                          category: _category,
                                          description: _description);
                                      setState(() {
                                        Provider.of<Vault>(context,
                                                listen: false)
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
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: PasswordGenerator(),
                          ),
                        ])))));
  }
}
