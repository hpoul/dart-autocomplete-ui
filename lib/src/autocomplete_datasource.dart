part of input_autocomplete;


/**
 * Datasource is responsible for returning all choices suitable for the given query string.
 **/
abstract class AutocompleteDatasource {
  Future<Collection<AutocompleteChoice>> query(String query);
  AutocompleteChoice objectByKey(String key);
}




class SimpleStringDatasource implements AutocompleteDatasource {
  List _givenChoices;
  List<AutocompleteChoiceImpl> _choices;
  SimpleStringDatasource(this._givenChoices) {
    _choices = new List();
    for(var choice in _givenChoices) {
      _choices.add(new AutocompleteChoiceImpl(choice.toString(), choice.toString(), choice));
    }
  }
  
  Future<Collection<AutocompleteChoice>> query(String query) {
    var completer = new Completer<Collection<AutocompleteChoice>>();
    if (query.isEmpty) {
      completer.complete(_choices);
    } else {
      completer.complete(_choices.filter((choice) => choice.key.toLowerCase().contains(query)));
    }
    return completer.future;
  }
  AutocompleteChoice objectByKey(String key) {
    for (var choice in _choices) {
      if (choice.key == key) {
        return choice;
      }
    }
    return null;
  }
}
