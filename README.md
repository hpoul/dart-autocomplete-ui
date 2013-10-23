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


Changelog
-------

* HEAD:
* 0.1.0 (2013-10-24): Got it to work with polymer 0.8.5! ;-)
* 0.0.6+4 (2013-09-05): simply removed upper version constraint for web_ui (there won't be too many new versions anyway) - should make it compatible with dart sdk 0.7.1
* 0.0.6+3 (2013-08-20): compatibility to dart sdk 0.6.19 / web_ui 0.4.18
* 0.0.6+2 (2013-08-12): compatibility to dart sdk 0.6.15 / web_ui 0.4.17
* 0.0.6+1 (2013-07-25): compatibility to dart sdk 0.6.9 / web_ui 0.4.15
* 0.0.6 (2013-07-12): compatibility to dart sdk 0.6.3 / web_ui 0.4.14
* 0.0.5 (2013-07-03): added a way to bind for the latest selected value. (bind-selectedchoice="..")
* 0.0.4+2 (2013-07-02): changed layout to wrap everything in a position: relative div, instead of trying to position autocompletion box absolute to the whole page.
* 0.0.4 (2013-06-27): Fixed support for Latest Dart Libraries & Web UI (0.4.12+3)
* 0.0.3: Support for Dart Libraries v2 (M3 preparation)
* 0.0.2: support for custom datasources, formatting
* 0.0.1: initial "release"

Future
-------

* Support for lazy loading of choices
* Support for object choices (which have a separate key / label attribute)
* Support for formatting of choices (however this can work? the coolest would be to provide html fragments inside the <x-input-autocomplete> tag)
* Helper methods to create a multi-value input (like input for tags)
