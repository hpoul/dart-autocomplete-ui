import 'package:autocomplete_ui/input_autocomplete.dart';
import 'package:polymer/polymer.dart';


@CustomTag('tapo-input-autocomplete')
class InputAutocompleteComponentProxy extends InputAutocompleteComponent {
  @observable
  String blah = 'x';
  
  void testClick(e, t, o) {
    blah = 'xyz ${new DateTime.now()}';
  }
}
