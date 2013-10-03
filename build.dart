//import 'package:polymer/builder.dart';
import 'dart:io';

main() {
  var args = new Options().arguments;
  args.addAll(['--', '--deploy']); // Note: the --deploy is what makes this work
//  build(args, ['web/example.html']);
  //build(entryPoints: ['web/example.html']);
}