import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:autocomplete_ui/input_autocomplete.dart';

@CustomTag('tapo-autocomplete-result')
class AutocompleteResult extends PolymerElement with ChangeNotifier {
  @reflectable @observable @published AutocompleteChoice get choice => __$choice; AutocompleteChoice __$choice; @reflectable set choice(AutocompleteChoice value) { __$choice = notifyPropertyChange(#choice, __$choice, value); }
  @reflectable @observable @published String get searchquery => __$searchquery; String __$searchquery; @reflectable set searchquery(String value) { __$searchquery = notifyPropertyChange(#searchquery, __$searchquery, value); }
  @reflectable @published AutocompleteChoiceRenderer get renderer => __$renderer; AutocompleteChoiceRenderer __$renderer; @reflectable set renderer(AutocompleteChoiceRenderer value) { __$renderer = notifyPropertyChange(#renderer, __$renderer, value); }
  
  bool get applyAuthorStyles => true;
  
  
  AutocompleteResult.created() : super.created();
  
  dynamic enteredView() {
    super.enteredView();
    Element resultLabel = getShadowRoot('tapo-autocomplete-result').query('.result-label');
    resultLabel.innerHtml = renderer.renderChoice(choice, searchquery).outerHtml;
  }
}