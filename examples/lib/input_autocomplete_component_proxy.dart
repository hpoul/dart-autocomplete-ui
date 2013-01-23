// Auto-generated from input_autocomplete.html.
// DO NOT EDIT.

library x_input_autocomplete;

import 'dart:html' as autogenerated;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;

import 'package:autocomplete_ui/input_autocomplete.dart';

import 'dart:html';

class InputAutocompleteComponentProxy extends InputAutocompleteComponent {
  
  /** Autogenerated from the template. */
  
  /**
  * Shadow root for this component. We use 'var' to allow simulating shadow DOM
  * on browsers that don't support this feature.
  */
  var _root;
  autogenerated.Element __e7;
  autogenerated.InputElement __e8;
  autogenerated.Template __t;
  
  InputAutocompleteComponentProxy.forElement(e) : super.forElement(e);
  
  void created_autogenerated() {
    _root = createShadowRoot();
    __t = new autogenerated.Template(_root);
    _root.innerHtml = '''
    <div class="autocomplete-wrapper">
    <template id="__e-7" style="display:none"></template>
    <input type="text" id="__e-8">
    </div>
    <style>
    .autocomplete-wrapper input {
      border: 1px solid black;
      padding: 3px;
    }
    .autocomplete-wrapper input.loading {
      background-image: url(\'data:image/gif;base64,R0lGODlhEAAQAPIAAP///wAAAMLCwkJCQgAAAGJiYoKCgpKSkiH+GkNyZWF0ZWQgd2l0aCBhamF4bG9hZC5pbmZvACH5BAAKAAAAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAADMwi63P4wyklrE2MIOggZnAdOmGYJRbExwroUmcG2LmDEwnHQLVsYOd2mBzkYDAdKa+dIAAAh+QQACgABACwAAAAAEAAQAAADNAi63P5OjCEgG4QMu7DmikRxQlFUYDEZIGBMRVsaqHwctXXf7WEYB4Ag1xjihkMZsiUkKhIAIfkEAAoAAgAsAAAAABAAEAAAAzYIujIjK8pByJDMlFYvBoVjHA70GU7xSUJhmKtwHPAKzLO9HMaoKwJZ7Rf8AYPDDzKpZBqfvwQAIfkEAAoAAwAsAAAAABAAEAAAAzMIumIlK8oyhpHsnFZfhYumCYUhDAQxRIdhHBGqRoKw0R8DYlJd8z0fMDgsGo/IpHI5TAAAIfkEAAoABAAsAAAAABAAEAAAAzIIunInK0rnZBTwGPNMgQwmdsNgXGJUlIWEuR5oWUIpz8pAEAMe6TwfwyYsGo/IpFKSAAAh+QQACgAFACwAAAAAEAAQAAADMwi6IMKQORfjdOe82p4wGccc4CEuQradylesojEMBgsUc2G7sDX3lQGBMLAJibufbSlKAAAh+QQACgAGACwAAAAAEAAQAAADMgi63P7wCRHZnFVdmgHu2nFwlWCI3WGc3TSWhUFGxTAUkGCbtgENBMJAEJsxgMLWzpEAACH5BAAKAAcALAAAAAAQABAAAAMyCLrc/jDKSatlQtScKdceCAjDII7HcQ4EMTCpyrCuUBjCYRgHVtqlAiB1YhiCnlsRkAAAOwAAAAAAAAAAAA==\');
      background-repeat: no-repeat;
      background-position: right center;
    }
    .autocomplete-content {
      //display: none;
      position: absolute;
      border: 1px solid black;
      padding: 0px;
      margin: 0px;
      background-color: #fff;
      overflow-x: scroll;
    }
    .autocomplete-content li {
      list-style-type: none;
      padding: 2px;
      margin: 0px;
      margin-top: 2px;
      background-color: #fafafa;
    }
    .autocomplete-content li.focused {
      background-color: #ddd;
    }
    .autocomplete-content div {
      padding: 0px;
      margin: 0px;
    }
    </style>
    ''';
    __e7 = _root.query('#__e-7');
    __t.conditional(__e7, () => (inputHasFocus && filteredChoices != null), (__t) {
      var __e5, __e6;
      __e6 = new autogenerated.Element.html('<ul class="autocomplete-content">\n              <template id="__e-5" style="display:none"></template>\n            </ul>');
      __e5 = __e6.query('#__e-5');
      __t.loop(__e5, () => (filteredChoices), (choice, __t) {
        var __e3, __e4;
        __e4 = new autogenerated.Element.html('<li class="">\n                  <div id="__e-3"></div>\n                  <!--content select=".choiceTemplate"></content-->\n                </li>');
        __e3 = __e4.query('#__e-3');
        var __binding2 = __t.contentBind(() => ( renderChoice(choice) ));
        __e3.nodes.add(__binding2);
        __t.listen(__e4.on.mouseDown, ($event) { mouseDownChoice(choice, $event); });
        __t.listen(__e4.on.mouseOver, ($event) { mouseOverChoice(choice, $event); });
        __t.listen(__e4.on.mouseUp, ($event) { selectChoice(choice); });
        __t.oneWayBind(() => ( choice.key ), (e) { __e4.attributes['choice-key'] = e; }, false);
        __t.bindClass(__e4, () => ( isFocused(choice) ? 'focused' : 'notfocused' ));
        __t.addAll([
          new autogenerated.Text('\n                '),
          __e4,
          new autogenerated.Text('\n              ')
        ]);
      });
      __t.addAll([
        new autogenerated.Text('\n            '),
        __e6,
        new autogenerated.Text('\n          ')
      ]);
    });
    
    __e8 = _root.query('#__e-8');
    __t.listen(__e8.on.blur, ($event) { inputBlur($event); });
    __t.listen(__e8.on.focus, ($event) { inputFocus($event); });
    __t.listen(__e8.on.keyDown, ($event) { keyDown($event); });
    __t.listen(__e8.on.keyUp, ($event) { keyUp($event); });
    
    __t.create();
  }
  
  void inserted_autogenerated() {
    __t.insert();
  }
  
  void removed_autogenerated() {
    __t.remove();
    __e7 = __e8 = __t = null;
  }
  
  void composeChildren() {
    super.composeChildren();
    if (_root is! autogenerated.ShadowRoot) _root = this;
  }
  
  /** Original code from the component. */
  
  //  InputAutocompleteComponentProxy.forElement(Element element) : super.forElement(element) {
    //  }
  }
  