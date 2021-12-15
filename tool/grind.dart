import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
build() {
  PubApp.local('build_runner').run(['build', '--delete-conflicting-outputs']);
}

