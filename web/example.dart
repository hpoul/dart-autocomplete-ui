import 'dart:html';


var exampleData = new ExampleData();

void main() {
}


class ExampleData {
  int test = 5;
  
  List<String> get autocompleteChoices {
    return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha'];
  }
}