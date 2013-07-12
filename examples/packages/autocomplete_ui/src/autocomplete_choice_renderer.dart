part of input_autocomplete;

/**
 * Highlights the given [query] in the [text] using html strong tags.
 * The returned string is save to be used in innerHtml.
 */
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
  return html;
}


abstract class AutocompleteChoiceRenderer {
  Element renderChoice(AutocompleteChoice choice, String query);
  
}

abstract class BaseAutocompleteChoiceRenderer implements AutocompleteChoiceRenderer {
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