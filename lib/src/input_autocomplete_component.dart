part of input_autocomplete;



abstract class AutocompleteChoice {
  String get key;
}

class AutocompleteChoiceImpl implements AutocompleteChoice {
  String key;
  String label;
  var obj;
  
  AutocompleteChoiceImpl(this.key, this.label, [this.obj]);
}

abstract class AutocompleteChoiceRenderer {
  Element renderChoice(AutocompleteChoice choice, String query);
  
}

abstract class BaseAutocompleteChoiceRenderer implements AutocompleteChoiceRenderer {
  String highlightTextAndHtmlEscape(String text, String query) {
    Element span = new Element.tag("span")
      ..text = text;
    String html = span.innerHtml;
    if (query.isEmpty) {
      return html;
    }
    int idx = html.toLowerCase().indexOf(query);
    if (idx >= 0) {
      String prefix = html.substring(0, idx);
      String value = html.substring(idx, idx+query.length);
      String postfix = html.substring(idx+query.length);
      html = "${prefix}<strong>${value}</strong>${postfix}";
    }
//    html = html.replaceAll(query, "<strong>${query}</strong>");
    return html;
  }
}

class AutocompleteChoiceRendererImpl extends BaseAutocompleteChoiceRenderer
      implements AutocompleteChoiceRenderer {
  Element renderChoice(AutocompleteChoice choice, String query) {
    if (choice is AutocompleteChoiceImpl) {
      return new Element.tag("div")..innerHtml = highlightTextAndHtmlEscape("${choice.label}", query);
    }
    throw new ArgumentError("Invalid choice ${choice}");
  }
}

class InputAutocompleteComponent extends WebComponent {
  bool inputHasFocus = false;
  List<AutocompleteChoice> _matches;
  AutocompleteChoiceRenderer _renderer;
  AutocompleteDatasource _datasource;
  
  InputAutocompleteComponent();
  
  InputAutocompleteComponent.forElement(Element element) : super.forElement(element) {
    //super.forElement(element);
  }
  
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
  
  void set choices(List choices) {
    this.datasource = new SimpleStringDatasource(choices);
    print('Choices have been set.');
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
    this.datasource.query(input.value.toLowerCase()).then((matches) {
      _matches = matches;
      watchers.dispatch();
      _positionCompleteBox();
    });
    /*
    var choices = this.choices;
    if (input.text.length == 0) {
      _matches = choices;
    }
    print("value: ${input.value}");
    _matches = choices.filter((e) => e.label.indexOf(input.value) != -1);
    if (_matches.length > 10) {
      _matches = _matches.getRange(0, 10);
    }
    */
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
  
  renderChoice(AutocompleteChoice choice) {
    var input = this.query('input');
    Element tmp = this.renderer.renderChoice(choice, input.value);
    return new SafeHtml.unsafe(tmp.outerHtml);
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
