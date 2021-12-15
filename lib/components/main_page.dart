import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
        home: const MyHomePage(title: 'Vault'),
        routes: {'/form': (context) => const CredentialForm()});
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vault = Provider.of<Vault>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Observer(
          builder: (_) => Center(
                child: vault.credentials.isNotEmpty
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
                            subtitle: Text(
                                vault.credentials[index].description),
                            trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Are you sure to delete?'),
                                              content: const Text(
                                                  'Yes, just delete it'),
                                              actions: [
                                                TextButton(
                                                    child: const Text('Ok'),
                                                    onPressed: () {
                                                      vault.remove(vault
                                                          .credentials[index]);
                                                      Navigator.pop(
                                                          context, 'OK');
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


