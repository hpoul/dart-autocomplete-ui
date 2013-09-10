import 'package:polymer/polymer.dart';

import 'package:autocomplete_ui/input_autocomplete.dart';

@CustomTag('simple-autocomplete-example')
class SimpleAutocompleteExample extends PolymerElement {
  @observable
  AutocompleteChoice selectedchoice;
  
  List<String> get autocompleteChoices {
    return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha', 'Lorem Ipsum', 'Testing 3']..sort();
  }
}