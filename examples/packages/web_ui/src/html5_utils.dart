// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(jmesserly): html5lib might be a better home for this.
// But at the moment we only need it here.

library html5_utils;


/**
 * Maps an HTML tag to a dart:html type. This uses [htmlElementNames] but it
 * will return UnknownElement if the tag is unknown.
 */
String typeForHtmlTag(String tag) {
  var type = htmlElementNames[tag];
  // Note: this will eventually be the component's class name if it is a
  // known x-tag.
  return type == null ? 'UnknownElement' : type;
}

/**
 * HTML element to DOM type mapping. Source:
 * <http://dev.w3.org/html5/spec/section-index.html#element-interfaces>
 *
 * The 'HTML' prefix has been removed to match `dart:html`, as per:
 * <http://code.google.com/p/dart/source/browse/branches/bleeding_edge/dart/lib/html/scripts/htmlrenamer.py>
 * It does not appear any element types are being renamed other than the prefix.
 * However there does not appear to be the last subtypes for the following tags:
 * command, data, dialog, td, th, and time.
 */
const htmlElementNames = const {
  'a': 'AnchorElement',
  'abbr': 'Element',
  'address': 'Element',
  'area': 'AreaElement',
  'article': 'Element',
  'aside': 'Element',
  'audio': 'AudioElement',
  'b': 'Element',
  'base': 'BaseElement',
  'bdi': 'Element',
  'bdo': 'Element',
  'blockquote': 'QuoteElement',
  'body': 'BodyElement',
  'br': 'BRElement',
  'button': 'ButtonElement',
  'canvas': 'CanvasElement',
  'caption': 'TableCaptionElement',
  'cite': 'Element',
  'code': 'Element',
  'col': 'TableColElement',
  'colgroup': 'TableColElement',
  'command': 'Element', // see doc comment, was: 'CommandElement'
  'data': 'Element', // see doc comment, was: 'DataElement'
  'datalist': 'DataListElement',
  'dd': 'Element',
  'del': 'ModElement',
  'details': 'DetailsElement',
  'dfn': 'Element',
  'dialog': 'Element', // see doc comment, was: 'DialogElement'
  'div': 'DivElement',
  'dl': 'DListElement',
  'dt': 'Element',
  'em': 'Element',
  'embed': 'EmbedElement',
  'fieldset': 'FieldSetElement',
  'figcaption': 'Element',
  'figure': 'Element',
  'footer': 'Element',
  'form': 'FormElement',
  'h1': 'HeadingElement',
  'h2': 'HeadingElement',
  'h3': 'HeadingElement',
  'h4': 'HeadingElement',
  'h5': 'HeadingElement',
  'h6': 'HeadingElement',
  'head': 'HeadElement',
  'header': 'Element',
  'hgroup': 'Element',
  'hr': 'HRElement',
  'html': 'HtmlElement',
  'i': 'Element',
  'iframe': 'IFrameElement',
  'img': 'ImageElement',
  'input': 'InputElement',
  'ins': 'ModElement',
  'kbd': 'Element',
  'keygen': 'KeygenElement',
  'label': 'LabelElement',
  'legend': 'LegendElement',
  'li': 'LIElement',
  'link': 'LinkElement',
  'map': 'MapElement',
  'mark': 'Element',
  'menu': 'MenuElement',
  'meta': 'MetaElement',
  'meter': 'MeterElement',
  'nav': 'Element',
  'noscript': 'Element',
  'object': 'ObjectElement',
  'ol': 'OListElement',
  'optgroup': 'OptGroupElement',
  'option': 'OptionElement',
  'output': 'OutputElement',
  'p': 'ParagraphElement',
  'param': 'ParamElement',
  'pre': 'PreElement',
  'progress': 'ProgressElement',
  'q': 'QuoteElement',
  'rp': 'Element',
  'rt': 'Element',
  'ruby': 'Element',
  's': 'Element',
  'samp': 'Element',
  'script': 'ScriptElement',
  'section': 'Element',
  'select': 'SelectElement',
  'small': 'Element',
  'source': 'SourceElement',
  'span': 'SpanElement',
  'strong': 'Element',
  'style': 'StyleElement',
  'sub': 'Element',
  'summary': 'Element',
  'sup': 'Element',
  'table': 'TableElement',
  'tbody': 'TableSectionElement',
  'td': 'TableCellElement', // see doc comment, was: 'TableDataCellElement'
  'template': 'Element', // should be 'TemplateElement', but it is not yet
                         // in dart:html
  'textarea': 'TextAreaElement',
  'tfoot': 'TableSectionElement',
  'th': 'TableCellElement', // see doc comment, was: 'TableHeaderCellElement'
  'thead': 'TableSectionElement',
  'time': 'Element', // see doc comment, was: 'TimeElement'
  'title': 'TitleElement',
  'tr': 'TableRowElement',
  'track': 'TrackElement',
  'u': 'Element',
  'ul': 'UListElement',
  'var': 'Element',
  'video': 'VideoElement',
  'wbr': 'Element',
};

/**
 * HTML element to DOM constructor mapping.
 * It is the same as [htmlElementNames] but removes any tags that map to the
 * same type, such as HeadingElement.
 * If the type is not in this map, it should use `new Element.tag` instead.
 */
final Map<String, String> htmlElementConstructors = (() {
  var typeCount = <int>{};
  for (var type in htmlElementNames.values) {
    var value = typeCount[type];
    if (value == null) value = 0;
    typeCount[type] = value + 1;
  }
  var result = {};
  htmlElementNames.forEach((tag, type) {
    if (typeCount[type] == 1) result[tag] = type;
  });
  return result;
})();



/**
 * HTML attributes that expect a URL value.
 * <http://dev.w3.org/html5/spec/section-index.html#attributes-1>
 *
 * Every one of these attributes is a URL in every context where it is used in
 * the DOM. The comments show every DOM element where an attribute can be used.
 */
const urlAttributes = const [
  'action',     // in form
  'cite',       // in blockquote, del, ins, q
  'data',       // in object
  'formaction', // in button, input
  'href',       // in a, area, link, base, command
  'manifest',   // in html
  'poster',     // in video
  'src',        // in audio, embed, iframe, img, input, script, source, track,
                //    video
];
