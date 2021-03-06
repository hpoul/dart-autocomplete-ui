part of input_autocomplete;



abstract class AutocompleteChoice {
  @reflectable
  String get key;
}

class AutocompleteChoiceImpl extends AutocompleteChoice with Observable {
  @reflectable String key;
  String label;
  var obj;
  
  AutocompleteChoiceImpl(this.key, this.label, [this.obj]);
}

