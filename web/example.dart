import 'dart:html';

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

  Future<Collection<AutocompleteChoice>> query(String query) {
    var completer = new Completer<Collection<AutocompleteChoice>>();
    var future = super.query(query);
    window.setTimeout(() {
      future.then((coll) => completer.complete(coll));
    }, 1000);
    return completer.future;
  }
}
