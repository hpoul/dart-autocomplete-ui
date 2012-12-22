library build;

import 'dart:io';
import 'package:web_ui/component_build.dart';

void main() {
  List<String> args = new Options().arguments;//..add("--basedir")..add(".");
  //print("args: ${args}");
  build(args, ['web/example.html']);
}