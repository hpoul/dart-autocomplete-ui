import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:autocomplete_ui/input_autocomplete.dart';

@CustomTag('tapo-autocomplete-result')
class AutocompleteResult extends PolymerElement with Observable {
  @observable @published AutocompleteChoice choice;
  @observable @published String searchquery;
  @published AutocompleteChoiceRenderer renderer;
  
  bool get applyAuthorStyles => true;
  
  
  AutocompleteResult.created() : super.created();
  
  dynamic enteredView() {
    super.enteredView();
    Element resultLabel = getShadowRoot('tapo-autocomplete-result').querySelector('.result-label');
    resultLabel.innerHtml = renderer.renderChoice(choice, searchquery).outerHtml;
  }
}