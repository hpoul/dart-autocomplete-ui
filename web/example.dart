import 'dart:html';
import 'dart:async';

import 'package:autocomplete_ui/input_autocomplete.dart';



var exampleData = new ExampleData();
var exampleDatasource = new ExampleDatasource(exampleData.autocompleteChoices);

void main() {
}


class ExampleData {
  
  List<String> get autocompleteChoices {
    return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha', 'Lorem Ipsum', 'Testing 3']..sort();
  }
}




class ExampleDatasource extends SimpleStringDatasource {
  ExampleDatasource(givenChoices) : super(givenChoices);

  Future<Iterable<AutocompleteChoice>> query(String query) {
    var completer = new Completer<Iterable<AutocompleteChoice>>();
    var future = super.query(query);
    
    new Future.delayed(const Duration(seconds: 1), () {
      future.then((coll) => completer.complete(coll));
    });
    return completer.future;
  }
}
