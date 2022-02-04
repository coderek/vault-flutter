import 'package:firstweb/components/search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'form_page.dart';
import '../models/credential.dart';

class VaultApp extends StatelessWidget {
  const VaultApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Derek\'s Vault',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(title: 'Password Vault'),
        routes: {'/form': (context) => const CredentialForm()});
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, this.title = ''}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showSearch = false;
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final vault = Provider.of<Vault>(context);
    vault.init();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
            onPressed: () {
              setState(() => showSearch = !showSearch);
            },
            icon: const Icon(Icons.search)),
      ]),
      body: Stack(
        children: [
          Observer(builder: (_) {
            var creds = vault.getCredentials(searchTerm);
            return creds.isNotEmpty
                ? ListView.separated(
                    itemCount: creds.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(thickness: 1),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(creds[index].username),
                        onTap: () async {
                          try {
                            await vault.loadPasswordForCredAt(index);
                            Navigator.pushNamed(context, '/form',
                                arguments: creds[index]);
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: 'failed to decrypt the credential',
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          }
                        },
                        subtitle: Text(creds[index].description),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Are you sure to delete?'),
                                          content:
                                              const Text('Yes, just delete it'),
                                          actions: [
                                            TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () async {
                                                  await vault
                                                      .remove(creds[index]);
                                                  Navigator.pop(context, 'OK');
                                                }),
                                          ]));
                            }),
                      );
                    })
                : const Center(child: Text('No credentials'));
          }),
          SearchField(
              show: showSearch,
              onChanged: (t) => setState(() => searchTerm = t)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/form'),
        tooltip: 'New credential',
        child: const Icon(Icons.add),
      ),
    );
  }
}
