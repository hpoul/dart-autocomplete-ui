part of input_autocomplete;



/**
 * autocomplete component for input fields.
 */
class InputAutocompleteComponent extends WebComponent {
  @observable
  bool inputHasFocus = false;
  AutocompleteChoiceRenderer _renderer;
  AutocompleteDatasource _datasource;
  int _focusedItemIndex = -1;
  @observable
  List<AutocompleteChoice> filteredChoices;
  
  
  void set renderer (AutocompleteChoiceRenderer renderer) {
    _renderer = renderer;
    print("a renderer was set: ${_renderer}");
  }
  
  AutocompleteChoiceRenderer get renderer {
    if (_renderer == null) {
      _renderer = new AutocompleteChoiceRendererImpl();
    }
    return _renderer;
  }
  
  void set datasource (AutocompleteDatasource ds) {
    _datasource = ds;
  }
  
  AutocompleteDatasource get datasource => _datasource;
  
  bool isFocused(AutocompleteChoice choice) {
    if (_focusedItemIndex < 0 || _focusedItemIndex >= filteredChoices.length) {
      return false;
    }
    //print("isFocused? ${_matches[_focusedItemIndex] == choice}");
    return filteredChoices[_focusedItemIndex] == choice;
  }
  
  void set choices(List choices) {
    this.datasource = new SimpleStringDatasource(choices);
    print('Choices have been set.');
  }
  
  List get choices {
    return datasource == null ? null : (datasource as SimpleStringDatasource).givenChoices;
  }
  
  
  void _focusNext(int next) {
    var newfocus = _focusedItemIndex + next;
    if (newfocus < 0) {
      newfocus = 0;
    }
    if (newfocus >= filteredChoices.length) {
      newfocus = filteredChoices.length - 1;
    }
    _focusedItemIndex = newfocus;
  }
  
  void keyDown(KeyboardEvent event) {
    switch(event.keyCode) {
      case KeyCode.DOWN:
        _focusNext(1);
        event.preventDefault();
        break;
      case KeyCode.UP:
        _focusNext(-1);
        event.preventDefault();
        break;
      case KeyCode.ENTER:
        selectCurrentFocus();
        break;
    }
  }
  
  void selectCurrentFocus() {
    selectChoice(filteredChoices[_focusedItemIndex]);
  }
  
  void selectChoice(AutocompleteChoice choice) {
    print("We have selected a choice: ${choice.key}");
    _input.blur();
    _input.value = choice.key;
  }
  
  void mouseOverChoice(AutocompleteChoice choice, Event event) {
    var idx = filteredChoices.indexOf(choice);
    if (idx == _focusedItemIndex || idx < 0) {
      return;
    }
    _focusedItemIndex = idx;
  }
  
  void mouseDownChoice(AutocompleteChoice choice, Event event) {
    // prevent default action, which would blur our input field.
    event.preventDefault();
  }
  
  void keyUp(Event event) {
    _doSearch();
  }
  
  /// returns the current inputfield (TODO: add caching?)
  InputElement get _input => this.query('input');
  
  void _doSearch() {
    // TODO would it be nicer to do this in HTML?
    this._input.classes.add("loading");
    this.datasource.query(this._input.value.toLowerCase()).then((matches) {
      filteredChoices = matches.toList();
      this._input.classes.remove("loading");
      _positionCompleteBox();
    });
  }
  
  void inputFocus(Event event) {
    _positionCompleteBox();
    inputHasFocus = true;
  }
  
  void inputBlur(Event event) {
    inputHasFocus = false;
  }
  
  void inserted() {
    //_positionCompleteBox();
    _positionCompleteBox();
  }
  
  renderChoice(AutocompleteChoice choice) {
    InputElement input = this.query('input');
    Element tmp = this.renderer.renderChoice(choice, input.value);
    return new SafeHtml.unsafe(tmp.outerHtml);
  }
  
  num _parseStyleInt(String styleValue) {
    int pos = styleValue.indexOf('px');
    if (pos > 0) {
      styleValue = styleValue.substring(0, pos);
    }
    return int.parse(styleValue);
  }
  
  void _positionCompleteBox() {
    var content = this.query('.autocomplete-content-wrapper-marker');
    if (content == null) {
      print("unable to find autocomplete-content");
      return;
    }
    print ("positioning autocomplete-content");
    var input = this.query('input');
    // TODO: I'm pretty sure this won't work in all (most?) cases..
    // but it's good enough for now..
    var rect = input.getBoundingClientRect();
    var contentrect = content.getBoundingClientRect();
    var padding = contentrect.width - content.clientWidth;
    CssStyleDeclaration style = input.getComputedStyle();
//    input.computedStyle.then((CssStyleDeclaration style) {
      content.style.top = '${rect.top + window.pageYOffset + rect.height}px';
      num marginLeft = _parseStyleInt(style.marginLeft);
      num marginRight = _parseStyleInt(style.marginRight);
      content.style.left = '${rect.left + window.pageXOffset - padding + marginLeft}px';
      content.style.width = '${rect.width - padding}px';
//    });
  }
}
