part of input_autocomplete;



abstract class AutocompleteChoice {
  String get key;
}

class AutocompleteChoiceImpl extends AutocompleteChoice {
  String key;
  String label;
  var obj;
  
  AutocompleteChoiceImpl(this.key, this.label, [this.obj]);
}

