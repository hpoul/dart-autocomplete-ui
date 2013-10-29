part of input_autocomplete;

class ValueHolder extends Object with ChangeNotifier {
  @reflectable @observable
  bool get inputHasFocus => __$inputHasFocus; bool __$inputHasFocus = false; @reflectable set inputHasFocus(bool value) { __$inputHasFocus = notifyPropertyChange(#inputHasFocus, __$inputHasFocus, value); }
  @reflectable @observable
  List<AutocompleteChoice> get filteredChoices => __$filteredChoices; List<AutocompleteChoice> __$filteredChoices; @reflectable set filteredChoices(List<AutocompleteChoice> value) { __$filteredChoices = notifyPropertyChange(#filteredChoices, __$filteredChoices, value); }
  @reflectable @observable
  String get xyz => __$xyz; String __$xyz; @reflectable set xyz(String value) { __$xyz = notifyPropertyChange(#xyz, __$xyz, value); }
  @reflectable @observable
  bool get hasSearched => __$hasSearched; bool __$hasSearched = false; @reflectable set hasSearched(bool value) { __$hasSearched = notifyPropertyChange(#hasSearched, __$hasSearched, value); }
  @reflectable @observable
  Object get mynull => __$mynull; Object __$mynull = null; @reflectable set mynull(Object value) { __$mynull = notifyPropertyChange(#mynull, __$mynull, value); }
  @reflectable @observable
  String get searchquery => __$searchquery; String __$searchquery = ""; @reflectable set searchquery(String value) { __$searchquery = notifyPropertyChange(#searchquery, __$searchquery, value); }
  @observable
  int _focusedItemIndex = -1;
}

/**
 * autocomplete component for input fields.
 * 
 * Users can set the following attributes:
 * 
 * ## Simple Usage
 * 
 * * [choices]: List of choices (Strings) to be selected from
 *
 * ## or customized:
 * 
 * * [datasource] (subclass of [AutocompleteDatasource])
 * * [renderer] (subclass of [AutocompleteChoiceRenderer])
 */
@CustomTag('tapo-input-autocomplete')
class InputAutocompleteComponent extends PolymerElement with ChangeNotifier  {
  AutocompleteChoiceRenderer _renderer;
  @reflectable @observable @published AutocompleteDatasource get datasource => __$datasource; AutocompleteDatasource __$datasource; @reflectable set datasource(AutocompleteDatasource value) { __$datasource = notifyPropertyChange(#datasource, __$datasource, value); }
  @reflectable @observable
  ValueHolder get model => __$model; ValueHolder __$model = new ValueHolder(); @reflectable set model(ValueHolder value) { __$model = notifyPropertyChange(#model, __$model, value); }
  @reflectable @observable @published
  AutocompleteChoice get selectedchoice => __$selectedchoice; AutocompleteChoice __$selectedchoice; @reflectable set selectedchoice(AutocompleteChoice value) { __$selectedchoice = notifyPropertyChange(#selectedchoice, __$selectedchoice, value); }
  
  InputAutocompleteComponent.created() : super.created() {
    onPropertyChange(this, #datasource, () {
      print('datasource changed.');
    });
  }

  bool get applyAuthorStyles => true;
  
  @published
  void set renderer (AutocompleteChoiceRenderer renderer) {
    _renderer = renderer;
  }
  
  @published
  AutocompleteChoiceRenderer get renderer {
    if (_renderer == null) {
      _renderer = new AutocompleteChoiceRendererImpl();
    }
    return _renderer;
  }
  
  bool isFocused(AutocompleteChoice choice) {
    if (model._focusedItemIndex < 0 || model._focusedItemIndex >= model.filteredChoices.length) {
      return false;
    }
    return model.filteredChoices[model._focusedItemIndex] == choice;
  }
  
  @published void set choices(List choices) {
    print("Setting choices. to ${choices}");
    this.datasource = new SimpleStringDatasource(choices);
  }
  
  @published List get choices {
    return datasource == null ? null : (datasource as SimpleStringDatasource).givenChoices;
  }
  
  
  void _focusNext(int next) {
    var newfocus = model._focusedItemIndex + next;
    if (newfocus < 0) {
      newfocus = 0;
    }
    if (newfocus >= model.filteredChoices.length) {
      newfocus = model.filteredChoices.length - 1;
    }
    model._focusedItemIndex = newfocus;
  }
  
  void keyDown(KeyboardEvent event, var detail, Node target) {
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
    selectChoice(model.filteredChoices[model._focusedItemIndex]);
  }
  
  void selectChoice(AutocompleteChoice choice) {
    print("selectChoice");
    selectedchoice = choice;
    _input.blur();
    if (choice != null) {
      _input.value = choice.key;
    } else {
      _input.value = '';
    }
  }
  void mouseUpChoice(Event event, var detail, Node target) {
    if (target is Element) {
      var choiceKey = (target as Element).attributes['choice-key'];
      var choice = datasource.objectByKey(choiceKey);
      if (choice == null) {
        print('could not find choice with key ${choiceKey}');
      }
      selectChoice(choice);
    }
  }
  
//  void mouseOverChoice(AutocompleteChoice choice, Event event) {
  void mouseOverChoice(Event event, var detail, Node target) {
    print('mouseOver');
    if (target is Element) {
      var choiceKey = (target as Element).attributes['choice-key'];
      var choice = datasource.objectByKey(choiceKey);
      var idx = model.filteredChoices.indexOf(choice);
      if (idx == model._focusedItemIndex || idx < 0) {
        return;
      }
      model._focusedItemIndex = idx;
      print("focusedItemIndex: ${idx}");
    }
  }
  
  void mouseDown(Event event, var detail, Node target) {
    print('mouse down');
    // prevent default action, which would blur our input field.
    event.preventDefault();
  }
  
  void keyUp(Event e, var detail, Node target) {
    _doSearch();
  }
  
  /// returns the current inputfield (TODO: add caching?)
  InputElement get _input => this.getShadowRoot("tapo-input-autocomplete").query('input');
  
  void _doSearch() {
    // TODO would it be nicer to do this in HTML?
    this._input.classes.add("loading");
    this.datasource.query(this._input.value.toLowerCase()).then((matches) {
      model.filteredChoices = toObservable(matches.toList());
      this._input.classes.remove("loading");
      _positionCompleteBox();
    });
  }
  
  void inputFocus(Event e, var detail, Node target) {
    model.xyz = 'haha ${new DateTime.now()}';print("inputFocus ${model.xyz}");
    _positionCompleteBox();
    model.inputHasFocus = true;
  }
  
  void inputBlur(Event e, var detail, Node target) {
    model.inputHasFocus = false;
  }
  
  void enteredView() {
    super.enteredView();
    //_positionCompleteBox();
    model.changes.listen((records){
      model.hasSearched = model.filteredChoices != null;
    });
    _positionCompleteBox();
    InputElement el = this.getShadowRoot('tapo-input-autocomplete').query('input');
    el.onFocus.listen((e) => inputFocus(null, null, null));
    el.onBlur.listen((e) => inputBlur(null, null, null));
  }
  
  renderChoice(AutocompleteChoice choice) {
    InputElement input = this._input;
    Element tmp = this.renderer.renderChoice(choice, input.value);
    print("we need to set ${tmp.outerHtml}");
//    return tmp;//new SafeHtml.unsafe(tmp.outerHtml);
    
    return new Element.html('<span>test<strong>asdf</strong></span>');
  }
  
  num _parseStyleInt(String styleValue) {
    int pos = styleValue.indexOf('px');
    if (pos > 0) {
      styleValue = styleValue.substring(0, pos);
    }
    return int.parse(styleValue);
  }
  
  void _positionCompleteBox() {
    var content = this.getShadowRoot('tapo-input-autocomplete').query('.autocomplete-content-wrapper-marker');
    if (content == null) {
      print("unable to find autocomplete-content");
      return;
    }
    var input = this._input;
    // TODO: I'm pretty sure this won't work in all (most?) cases..
    // but it's good enough for now..
    var rect = input.getBoundingClientRect();
    var contentrect = content.getBoundingClientRect();
    var padding = contentrect.width - content.clientWidth;
    CssStyleDeclaration style = input.getComputedStyle();
//    input.computedStyle.then((CssStyleDeclaration style) {
      content.style.top = '${rect.height}px';
      num marginLeft = _parseStyleInt(style.marginLeft);
      num marginRight = _parseStyleInt(style.marginRight);
      content.style.left = '${marginLeft}px';
      content.style.width = '${rect.width - padding}px';
//    });
  }
}
