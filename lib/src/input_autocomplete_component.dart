part of input_autocomplete;


class InputAutocompleteComponent extends WebComponent {
  List _choices;
  
  InputAutocompleteComponent();
  
  InputAutocompleteComponent.forElement(Element element) : super.forElement(element) {
    //super.forElement(element);
  }
  
  void set choices(List choices) {
    _choices = choices;
    print('Choices have been set.');
  }
  
  List get choices {
    print("Somebody want's to get the choices.");
    return _choices;
  }
}
