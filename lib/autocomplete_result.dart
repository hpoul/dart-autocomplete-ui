import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:autocomplete_ui/input_autocomplete.dart';

@CustomTag('tapo-autocomplete-result')
class AutocompleteResult extends PolymerElement with ObservableMixin {
  @observable AutocompleteChoice choice;
  @observable String searchquery;
  AutocompleteChoiceRenderer renderer;
  
  dynamic inserted() {
    super.inserted();
    Element resultLabel = getShadowRoot('tapo-autocomplete-result').query('.result-label');
    resultLabel.innerHtml = renderer.renderChoice(choice, searchquery).outerHtml;
  }
}