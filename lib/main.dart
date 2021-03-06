import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/main_page.dart';
import 'models/credential.dart';

// const encryptionKey = String.fromEnvironment('ENCRYPTION_KEY', defaultValue: ); 

void main() {
  runApp(Provider(
      create: (BuildContext context) {
        return Vault();
      },
      child: const VaultApp()));
}
