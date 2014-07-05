dart-autocomplete-ui
====================

A simple dart web ui component which provides a autocomplete input text field.
(To autocomplete a single value)


Status
-------

Currently it is nothing more than a POC which can display a auto complete
field for a text input with a static list of strings.

Checkout an example at http://hpoul.github.com/dart-autocomplete-ui/examples/example.html

Usage
-------

Take a look at the example - the basic idea is that you simply include the
web component:

    <link rel="import" href="lib/input_autocomplete.html">

and then include the input autocompletion whereever you want:

    <tapo-input-autocomplete choices="{{exampleData.autocompleteChoices}}">
    </tapo-input-autocomplete>

example dart code:


    var exampleData = new ExampleData();


    class ExampleData {
      List<String> get autocompleteChoices {
        return ['Test 1', 'Test 2', 'Misc', 'Abcdef', 'Haha'];
      }
    }


It is also possible to use a custom datasource as well as a custom renderer.
See the classes AutocompleteDatasource and AutocompleteChoiceRenderer for
more details.


TODO write documentation.


Future
-------

* Support for lazy loading of choices
* Support for object choices (which have a separate key / label attribute)
* Support for formatting of choices (however this can work? the coolest would be to provide html fragments inside the <x-input-autocomplete> tag)
* Helper methods to create a multi-value input (like input for tags)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/hpoul/dart-autocomplete-ui/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

