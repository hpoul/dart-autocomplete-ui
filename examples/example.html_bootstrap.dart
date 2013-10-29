library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:autocomplete_ui/autocomplete_result.dart' as i0;
import 'package:autocomplete_ui/input_autocomplete.html.0.dart' as i1;
import 'package:autocomplete_ui/example/simple_autocomplete_example.dart' as i2;
import 'example.html.0.dart' as i3;

void main() {
  configureForDeployment([
      'package:autocomplete_ui/autocomplete_result.dart',
      'package:autocomplete_ui/input_autocomplete.html.0.dart',
      'package:autocomplete_ui/example/simple_autocomplete_example.dart',
      'example.html.0.dart',
    ]);
  i3.main();
}
