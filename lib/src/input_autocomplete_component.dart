part of input_autocomplete;


class AutocompleteChoice {
  String key;
  String label;
  
  AutocompleteChoice(this.key, this.label);
}

class InputAutocompleteComponent extends WebComponent {
  bool inputHasFocus = false;
  List _givenChoices;
  /// sanitized choices
  List<AutocompleteChoice> _choices;
  List<AutocompleteChoice> _matches;
  
  InputAutocompleteComponent();
  
  InputAutocompleteComponent.forElement(Element element) : super.forElement(element) {
    //super.forElement(element);
  }
  
  void set choices(List choices) {
    _givenChoices = choices;
    print('Choices have been set.');
  }
  
  _sanitzeChoices() {
    if (_givenChoices != null) {
      _choices = new List();
      for (var obj in _givenChoices) {
        // for now simply use the toString as key and label :-)
        _choices.add(new AutocompleteChoice(obj.toString(), obj.toString()));
      }
    }
  }
  
  List get choices {
    print("Somebody wants to get the choices.");
    if (_choices == null) {
      _sanitzeChoices();
    }
    return _choices;
  }
  
  List<AutocompleteChoice> get matches {
    if (_matches == null) {
      _doSearch();
    }
    return _matches;
  }
  
  
  void keyPressed(Event event) {
    _doSearch();
  }
  
  void _doSearch() {
    var input = this.query('input');
    var choices = this.choices;
    if (input.text.length == 0) {
      _matches = choices;
    }
    print("value: ${input.value}");
    _matches = choices.filter((e) => e.label.indexOf(input.value) != -1);
    if (_matches.length > 10) {
      _matches = _matches.getRange(0, 10);
    }
    watchers.dispatch();
    _positionCompleteBox();
  }
  
  void inputFocus(Event event) {
    inputHasFocus = true;
    watchers.dispatch();
    _positionCompleteBox();
  }
  
  void inputBlur(Event event) {
    inputHasFocus = false;
    watchers.dispatch();
  }
  
  void inserted() {
    //_positionCompleteBox();
  }
  
  num _parseStyleInt(String styleValue) {
    int pos = styleValue.indexOf('px');
    if (pos > 0) {
      styleValue = styleValue.substring(0, pos);
    }
    return parseInt(styleValue);
  }
  
  void _positionCompleteBox() {
    var content = this.query('ul.autocomplete-content');
    if (content == null) {
      return;
    }
    var input = this.query('input');
    // TODO: I'm pretty sure this won't work in all (most?) cases..
    // but it's good enough for now..
    var rect = input.getBoundingClientRect();
    var contentrect = content.getBoundingClientRect();
    var padding = contentrect.width - content.clientWidth;
    input.computedStyle.then((CssStyleDeclaration style) {
      content.style.top = '${rect.top + window.pageYOffset + rect.height}px';
      num marginLeft = _parseStyleInt(style.marginLeft);
      num marginRight = _parseStyleInt(style.marginRight);
      content.style.left = '${rect.left + window.pageXOffset - padding + marginLeft}px';
      content.style.width = '${rect.width - padding}px';
    });
  }
}
