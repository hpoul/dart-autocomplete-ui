dart-autocomplete-ui
====================

A simple dart web ui component which provides a autocomplete input text field.


Status
-------

Currently it is nothing more than a POC which can display a auto complete field for a text input with a static list of strings.

Checkout an example at http://hpoul.github.com/dart-autocomplete-ui/examples/example.html

Usage
-------

Take a look at the example - the basic idea is that you simply include the web component:

    <link rel="components" href="lib/input_autocomplete.html">

and then include the input autocompletion whereever you want:

    <x-input-autocomplete choices="{{exampleData.autocompleteChoices}}"></x-input-autocomplete>

example dart code:


    var exampleData = new ExampleData();


    class ExampleData {
      List<String> get autocompleteChoices {
        return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha'];
      }
    }

todo write documentation.

