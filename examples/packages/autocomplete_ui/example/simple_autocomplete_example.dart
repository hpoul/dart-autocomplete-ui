import 'dart:async';
import 'package:polymer/polymer.dart';

import 'package:autocomplete_ui/input_autocomplete.dart';

@CustomTag('simple-autocomplete-example')
class SimpleAutocompleteExample extends PolymerElement with ChangeNotifier  {
  @reflectable @observable
  AutocompleteChoice get selectedchoice => __$selectedchoice; AutocompleteChoice __$selectedchoice; @reflectable set selectedchoice(AutocompleteChoice value) { __$selectedchoice = notifyPropertyChange(#selectedchoice, __$selectedchoice, value); }
  @reflectable @observable
  ExampleDatasource get exampleDatasource => __$exampleDatasource; ExampleDatasource __$exampleDatasource; @reflectable set exampleDatasource(ExampleDatasource value) { __$exampleDatasource = notifyPropertyChange(#exampleDatasource, __$exampleDatasource, value); }
  
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
