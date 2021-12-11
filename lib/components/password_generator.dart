import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/random_password.dart';

var generator = RandomPasswordGenerator();

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PasswordGenerator();
  }
}

class _PasswordGenerator extends State<PasswordGenerator> {
  String? _suggestedPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            _suggestedPassword ?? '',
            // style: const TextStyle(backgroundColor: Colors.grey),
          )),
          TextButton(
              child: const Text('Generate'),
              onPressed: () {
                setState(() {
                  _suggestedPassword = generator.randomPassword(
                      passwordLength: 16,
                      specialChar: true,
                      uppercase: true,
                      numbers: true);
                });
              }),
          TextButton(
              child: const Text('Copy'),
              onPressed: _suggestedPassword != null
                  ? () {
                      FlutterClipboard.copy(_suggestedPassword!).then((value) =>
                          Fluttertoast.showToast(
                              msg: 'copied',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0));
                    }
                  : null),
        ]);
  }
}
