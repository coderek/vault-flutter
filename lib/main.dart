import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/main_page.dart';
import 'models/credential.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return Vault(secret: 'abcdabcdabcdabcd');
      },
      child: const VaultApp()));
}
