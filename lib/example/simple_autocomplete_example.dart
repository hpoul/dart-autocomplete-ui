import 'dart:async';
import 'package:polymer/polymer.dart';

import 'package:autocomplete_ui/input_autocomplete.dart';

@CustomTag('simple-autocomplete-example')
class SimpleAutocompleteExample extends PolymerElement {
  @observable
  AutocompleteChoice selectedchoice;
  @observable
  ExampleDatasource exampleDatasource;
  
  SimpleAutocompleteExample.created() : super.created() {
    exampleDatasource = new ExampleDatasource(autocompleteChoices);
  }
  
  List<String> get autocompleteChoices {
    return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha', 'Lorem Ipsum', 'Testing 3']..sort();
  }
}




class ExampleDatasource extends SimpleStringDatasource {
  ExampleDatasource(givenChoices) : super(givenChoices);

  Future<Iterable<AutocompleteChoice>> query(String query) {
    var completer = new Completer<Iterable<AutocompleteChoice>>();
    var future = super.query(query);
    
    new Future.delayed(const Duration(milliseconds: 300), () {
      future.then((coll) => completer.complete(coll));
    });
    return completer.future;
  }
}
