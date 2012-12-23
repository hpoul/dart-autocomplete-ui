// Auto-generated from example.html.
// DO NOT EDIT.

library example_html;

import 'dart:html' as autogenerated_html;
import 'dart:web_audio' as autogenerated_audio;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;

import 'dart:html';

import 'lib/input_autocomplete_component_proxy.dart';


// Original code
var exampleData = new ExampleData();

void main() {
}


class ExampleData {
  int test = 5;
  
  List<String> get autocompleteChoices {
    return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha'];
  }
}

// Additional generated code
/** Create the views and bind them to models. */
void init_autogenerated() {
  var _root = autogenerated_html.document.body;
  autogenerated_html.ParagraphElement __e1;
  
  var __binding0;
  
  List<autogenerated.WatcherDisposer> __stoppers1;
  
  autogenerated_html.UnknownElement __e2;
  


  // Initialize fields.
  __e1 = _root.query('#__e-1');
  __binding0 = new autogenerated_html.Text('');
  __stoppers1 = [];
  __e1.nodes.add(new autogenerated_html.Text('Hello world from Dart! '));
  __e1.nodes.add(__binding0);
  __e2 = _root.query('#__e-2');
  new InputAutocompleteComponentProxy.forElement(__e2)
  ..created_autogenerated()
  ..created()
  ..composeChildren();
  

  // Attach model to views.
  __stoppers1.add(autogenerated.watchAndInvoke(() => '${exampleData.test}', (__e) {
    __binding0 = autogenerated.updateBinding(exampleData.test, __binding0, __e.newValue);
  }));
  
  __stoppers1.add(autogenerated.watchAndInvoke(() => exampleData.autocompleteChoices, (__e) { __e2.xtag.choices = __e.newValue; }));
  
  __e2.xtag..inserted()
  
  ..inserted_autogenerated();
  

}
