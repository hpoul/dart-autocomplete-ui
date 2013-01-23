// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * This library exposes the types in [watcher], [safe_html], [templating] and
 * the [WebComponent] base class. See this article for more information about
 * this library: <http://www.dartlang.org/articles/dart-web-components/>.
 */
library web_ui;

export 'watcher.dart';
export 'safe_html.dart';
export 'templating.dart';

import 'dart:async';
import 'dart:html';

// Imported for the doc comment
import 'watcher.dart' as watcher;
import 'safe_html.dart' as safe_html;
import 'templating.dart' as templating;

/**
 * The base class for all Dart web components. In addition to the [Element]
 * interface, it also provides lifecycle methods:
 * - [created]
 * - [inserted]
 * - [attributeChanged]
 * - [removed]
 */
abstract class WebComponent implements Element {
  /** The web component element wrapped by this class. */
  final Element _element;
  List _shadowRoots;

  /**
   * Default constructor for web components. This contructor is only provided
   * for tooling, and is *not* currently supported.
   * Use [WebComponent.forElement] instead.
   */
  WebComponent() : _element = null {
    throw new UnsupportedError(
        'Directly constructing web components is not currently supported. '
        'You need to use the WebComponent.forElement constructor to associate '
        'a component with its DOM element. If you run "bin/dwc.dart" on your '
        'component, the compiler will create the approriate construction '
        'logic.');
  }

  /**
   * Temporary constructor until components extend [Element]. Attaches this
   * component to the provided [element]. The element must not already have a
   * component associated with it.
   */
  WebComponent.forElement(Element element) : _element = element {
    if (element == null || _element.xtag != null) {
      throw new ArgumentError(
          'element must be provided and not have its xtag property set');
    }
    _element.xtag = this;
  }

  /**
   * **Note**: This is an implementation helper and should not need to be called
   * from your code.
   *
   * Creates the [ShadowRoot] backing this component.
   */
  createShadowRoot() {
    if (_realShadowRoot) {
      return _element.createShadowRoot();
    }
    if (_shadowRoots == null) _shadowRoots = [];
    _shadowRoots.add(new Element.html('<div class="shadowroot"></div>'));
    return _shadowRoots.last;
  }

  /**
   * Invoked when this component gets created.
   * Note that [root] will be a [ShadowRoot] if the browser supports Shadow DOM.
   */
  void created() {}

  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {}

  /** Invoked when this component is removed from the DOM tree. */
  void removed() {}

  // TODO(jmesserly): how do we implement this efficiently?
  // See https://github.com/dart-lang/web-ui/issues/37
  /** Invoked when any attribute of the component is modified. */
  void attributeChanged(
      String name, String oldValue, String newValue) {}

  /**
   * **Note**: This is an implementation helper and should not need to be called
   * from your code.
   *
   * If [ShadowRoot.supported] or [useShadowDom] is false, this distributes
   * children to the insertion points of the emulated ShadowRoot.
   * This is an implementation helper and should not need to be called from your
   * code.
   *
   * This is an implementation of [composition][1] and [rendering][2] from the
   * Shadow DOM spec. Currently the algorithm will replace children of this
   * component with the DOM as it should be rendered.
   *
   * Note that because we're always expanding to the render tree, and nodes are
   * expanded in a bottom up fashion, [reprojection][3] is handled naturally.
   *
   * [1]: http://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/shadow/index.html#composition
   * [2]: http://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/shadow/index.html#rendering-shadow-trees
   * [3]: http://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/shadow/index.html#reprojection
   */
  void composeChildren() {
    if (_realShadowRoot) return;

    if (_shadowRoots.length == 0) {
      // TODO(jmesserly): this is a limitation of our codegen approach.
      // We could keep the _shadowRoots around and clone(true) them, but then
      // bindings wouldn't be properly associated.
      throw new StateError('Distribution algorithm requires at least one shadow'
        ' root and can only be run once.');
    }

    var treeStack = _shadowRoots;

    // Let TREE be the youngest tree in the HOST's tree stack
    var tree = treeStack.removeLast();
    var youngestRoot = tree;
    // Let POOL be the list of nodes
    var pool = new List.from(nodes);

    // Note: reprojection logic is skipped here because composeChildren is
    // run on each component in bottom up fashion.

    var shadowInsertionPoints = [];
    var shadowInsertionTrees = [];

    while (true) {
      // Run the distribution algorithm, supplying POOL and TREE as input
      pool = _distributeNodes(tree, pool);

      // Let POINT be the first encountered active shadow insertion point in
      // TREE, in tree order
      var point = tree.query('shadow');
      if (point != null) {
        if (treeStack.length > 0) {
          // Find the next older tree, relative to TREE in the HOST's tree stack
          // Set TREE to be this older tree
          tree = treeStack.removeLast();
          // Assign TREE to the POINT

          // Note: we defer the actual tree replace operation until the end, so
          // we can run _distributeNodes on this tree. This simplifies the query
          // for content nodes in tree order.
          shadowInsertionPoints.add(point);
          shadowInsertionTrees.add(tree);

          // Continue to repeat
        } else {
          // If we've hit a built-in element, just use a content selector.
          // This matches the behavior of built-in HTML elements.
          // Since <content> can be implemented simply, we just inline it.
          _distribute(point, pool);

          // If there is no older tree, stop.
          break;
        }
      } else {
        // If POINT exists: ... Otherwise, stop
        break;
      }
    }

    // Handle shadow tree assignments that we deferred earlier.
    for (int i = 0; i < shadowInsertionPoints.length; i++) {
      var point = shadowInsertionPoints[i];
      var tree = shadowInsertionTrees[i];
      // Note: defensive copy is a workaround for http://dartbug.com/6684
      _distribute(point, new List.from(tree.nodes));
    }

    // Replace our child nodes with the ones in the youngest root.
    nodes.clear();
    // Note: defensive copy is a workaround for http://dartbug.com/6684
    nodes.addAll(new List.from(youngestRoot.nodes));
  }


  /**
   * This is an implementation of the [distribution algorithm][1] from the
   * Shadow DOM spec.
   *
   * [1]: http://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/shadow/index.html#dfn-distribution-algorithm
   */
  List<Node> _distributeNodes(Element tree, List<Node> pool) {
    // Repeat for each active insertion point in TREE, in tree order:
    for (var insertionPoint in tree.queryAll('content')) {
      if (!_isActive(insertionPoint)) continue;
      // Let POINT be the current insertion point.

      // TODO(jmesserly): validate selector, as specified here:
      // http://dvcs.w3.org/hg/webcomponents/raw-file/tip/spec/shadow/index.html#matching-insertion-points
      var select = insertionPoint.attributes['select'];
      if (select == null || select == '') select = '*';

      // Repeat for each node in POOL:
      //     1. Let NODE be the current node
      //     2. If the NODE matches POINT's matching criteria:
      //         1. Distribute the NODE to POINT
      //         2. Remove NODE from the POOL

      var matching = [];
      var notMatching = [];
      for (var node in pool) {
        (_matches(node, select) ? matching : notMatching).add(node);
      }

      if (matching.length == 0) {
        // When an insertion point or a shadow insertion point has nothing
        // assigned or distributed to them, the fallback content must be used
        // instead when rendering. The fallback content is all descendants of
        // the element that represents the insertion point.
        matching = insertionPoint.nodes;
      }

      _distribute(insertionPoint, matching);

      pool = notMatching;
    }

    return pool;
  }

  static bool _matches(Node node, String selector) {
    if (node is Text) return selector == '*';
    return (node as Element).matches(selector);
  }

  static bool _isInsertionPoint(Element node) =>
      node.tagName == 'CONTENT' || node.tagName == 'SHADOW';

  /**
   * An insertion point is "active" if it is not the child of another insertion
   * point. A child of an insertion point is "fallback" content and should not
   * be considered during the distribution algorithm.
   */
  static bool _isActive(Element node) {
    assert(_isInsertionPoint(node));
    for (node = node.parent; node != null; node = node.parent) {
      if (_isInsertionPoint(node)) return false;
    }
    return true;
  }

  /** Distribute the [nodes] in place of an existing [insertionPoint]. */
  static void _distribute(Element insertionPoint, List<Node> nodes) {
    assert(_isInsertionPoint(insertionPoint));
    for (var node in nodes) {
      insertionPoint.parent.insertBefore(node, insertionPoint);
    }
    insertionPoint.remove();
  }

  // TODO(jmesserly): this forwarding is temporary until Dart supports
  // subclassing Elements.
  // TODO(jmesserly): we were missing the setter for title, are other things
  // missing setters?

  List<Node> get nodes => _element.nodes;

  set nodes(Collection<Node> value) { _element.nodes = value; }

  /**
   * Replaces this node with another node.
   */
  Node replaceWith(Node otherNode) { _element.replaceWith(otherNode); }

  /**
   * Removes this node from the DOM.
   */
  void remove() => _element.remove();

  Node get nextNode => _element.nextNode;

  Document get document => _element.document;

  Node get previousNode => _element.previousNode;

  String get text => _element.text;

  set text(String v) { _element.text = v; }

  bool contains(Node other) => _element.contains(other);

  bool hasChildNodes() => _element.hasChildNodes();

  Node insertBefore(Node newChild, Node refChild) =>
    _element.insertBefore(newChild, refChild);

  Map<String, String> get attributes => _element.attributes;
  set attributes(Map<String, String> value) {
    _element.attributes = value;
  }

  List<Element> get elements => _element.children;

  set elements(Collection<Element> value) {
    _element.children = value;
  }

  List<Element> get children => _element.children;

  set children(Collection<Element> value) {
    _element.children = value;
  }

  Set<String> get classes => _element.classes;

  set classes(Collection<String> value) {
    _element.classes = value;
  }

  Map<String, String> get dataAttributes => _element.dataAttributes;
  set dataAttributes(Map<String, String> value) {
    _element.dataAttributes = value;
  }

  Map<String, String> getNamespacedAttributes(String namespace) =>
      _element.getNamespacedAttributes(namespace);

  Future<CssStyleDeclaration> get computedStyle => _element.computedStyle;

  Future<CssStyleDeclaration> getComputedStyle(String pseudoElement)
    => _element.getComputedStyle(pseudoElement);

  Element clone(bool deep) => _element.clone(deep);

  Element get parent => _element.parent;

  Node get parentNode => _element.parentNode;

  String get nodeValue => _element.nodeValue;

  ElementEvents get on => _element.on;

  String get contentEditable => _element.contentEditable;

  String get dir => _element.dir;

  bool get draggable => _element.draggable;

  bool get hidden => _element.hidden;

  String get id => _element.id;

  String get innerHTML => _element.innerHtml;

  void set innerHTML(String v) {
    _element.innerHtml = v;
  }

  String get innerHtml => _element.innerHtml;
  void set innerHtml(String v) {
    _element.innerHtml = v;
  }

  bool get isContentEditable => _element.isContentEditable;

  String get lang => _element.lang;

  String get outerHtml => _element.outerHtml;

  bool get spellcheck => _element.spellcheck;

  int get tabIndex => _element.tabIndex;

  String get title => _element.title;

  set title(String value) { _element.title = value; }

  bool get translate => _element.translate;

  String get webkitdropzone => _element.webkitdropzone;

  void click() { _element.click(); }

  Element insertAdjacentElement(String where, Element element) =>
    _element.insertAdjacentElement(where, element);

  void insertAdjacentHtml(String where, String html) {
    _element.insertAdjacentHtml(where, html);
  }

  void insertAdjacentText(String where, String text) {
    _element.insertAdjacentText(where, text);
  }

  Map<String, String> get dataset => _element.dataset;

  Element get nextElementSibling => _element.nextElementSibling;

  Element get offsetParent => _element.offsetParent;

  Element get previousElementSibling => _element.previousElementSibling;

  CssStyleDeclaration get style => _element.style;

  String get tagName => _element.tagName;

  String get webkitPseudo => _element.webkitPseudo;

  void set webkitPseudo(String value) {
    _element.webkitPseudo = value;
  }

  ShadowRoot get webkitShadowRoot => _element.webkitShadowRoot;

  void blur() { _element.blur(); }

  void focus() { _element.focus(); }

  void scrollByLines(int lines) {
    _element.scrollByLines(lines);
  }

  void scrollByPages(int pages) {
    _element.scrollByPages(pages);
  }

  void scrollIntoView([bool centerIfNeeded]) {
    if (centerIfNeeded == null) {
      _element.scrollIntoView();
    } else {
      _element.scrollIntoView(centerIfNeeded);
    }
  }

  bool matches(String selectors) => _element.matches(selectors);

  void webkitRequestFullScreen(int flags) {
    _element.webkitRequestFullScreen(flags);
  }

  void webkitRequestFullscreen() { _element.webkitRequestFullscreen(); }

  void webkitRequestPointerLock() { _element.webkitRequestPointerLock(); }

  Element query(String selectors) => _element.query(selectors);

  List<Element> queryAll(String selectors) => _element.queryAll(selectors);

  HtmlCollection get $dom_children => _element.$dom_children;

  int get $dom_childElementCount => _element.$dom_childElementCount;

  String get $dom_className => _element.$dom_className;
  set $dom_className(String value) { _element.$dom_className = value; }

  int get clientHeight => _element.clientHeight;

  int get clientLeft => _element.clientLeft;

  int get clientTop => _element.clientTop;

  int get clientWidth => _element.clientWidth;

  Element get $dom_firstElementChild => _element.$dom_firstElementChild;

  Element get $dom_lastElementChild => _element.$dom_lastElementChild;

  int get offsetHeight => _element.offsetHeight;

  int get offsetLeft => _element.offsetLeft;

  int get offsetTop => _element.offsetTop;

  int get offsetWidth => _element.offsetWidth;

  int get scrollHeight => _element.scrollHeight;

  int get scrollLeft => _element.scrollLeft;

  int get scrollTop => _element.scrollTop;

  set scrollLeft(int value) { _element.scrollLeft = value; }

  set scrollTop(int value) { _element.scrollTop = value; }

  int get scrollWidth => _element.scrollWidth;

  String $dom_getAttribute(String name) =>
      _element.$dom_getAttribute(name);

  String $dom_getAttributeNS(String namespaceUri, String localName) =>
      _element.$dom_getAttributeNS(namespaceUri, localName);

  String $dom_setAttributeNS(
      String namespaceUri, String localName, String value) {
    _element.$dom_setAttributeNS(namespaceUri, localName, value);
  }

  bool $dom_hasAttributeNS(String namespaceUri, String localName) =>
      _element.$dom_hasAttributeNS(namespaceUri, localName);

  void $dom_removeAttributeNS(String namespaceUri, String localName) =>
      _element.$dom_removeAttributeNS(namespaceUri, localName);

  ClientRect getBoundingClientRect() => _element.getBoundingClientRect();

  List<ClientRect> getClientRects() => _element.getClientRects();

  List<Node> $dom_getElementsByClassName(String name) =>
      _element.$dom_getElementsByClassName(name);

  List<Node> $dom_getElementsByTagName(String name) =>
      _element.$dom_getElementsByTagName(name);

  bool $dom_hasAttribute(String name) =>
      _element.$dom_hasAttribute(name);

  Element $dom_querySelector(String selectors) =>
      _element.$dom_querySelector(selectors);

  List<Node> $dom_querySelectorAll(String selectors) =>
      _element.$dom_querySelectorAll(selectors);

  void $dom_removeAttribute(String name) =>
      _element.$dom_removeAttribute(name);

  void $dom_setAttribute(String name, String value) =>
      _element.$dom_setAttribute(name, value);

  NamedNodeMap get $dom_attributes => _element.$dom_attributes;

  List<Node> get $dom_childNodes => _element.$dom_childNodes;

  Node get $dom_firstChild => _element.$dom_firstChild;

  Node get $dom_lastChild => _element.$dom_lastChild;

  String get $dom_localName => _element.$dom_localName;

  String get $dom_namespaceUri => _element.$dom_namespaceUri;

  int get nodeType => _element.nodeType;

  void $dom_addEventListener(String type, EventListener listener,
                             [bool useCapture]) {
    _element.$dom_addEventListener(type, listener, useCapture);
  }

  Node $dom_appendChild(Node newChild) => _element.$dom_appendChild(newChild);

  bool $dom_dispatchEvent(Event event) => _element.$dom_dispatchEvent(event);

  Node $dom_removeChild(Node oldChild) => _element.$dom_removeChild(oldChild);

  void $dom_removeEventListener(String type, EventListener listener,
                                [bool useCapture]) {
    _element.$dom_removeEventListener(type, listener, useCapture);
  }

  Node $dom_replaceChild(Node newChild, Node oldChild) =>
      _element.$dom_replaceChild(newChild, oldChild);

  get xtag => _element.xtag;

  set xtag(value) { _element.xtag = value; }

  void append(Element e) => _element.append(e);

  void appendText(String text) => _element.appendText(text);

  void appendHtml(String html) => _element.appendHtml(html);

  Stream<Event> get onAbort => _element.onAbort;
  Stream<Event> get onBeforeCopy => _element.onBeforeCopy;
  Stream<Event> get onBeforeCut => _element.onBeforeCut;
  Stream<Event> get onBeforePaste => _element.onBeforePaste;
  Stream<Event> get onBlur => _element.onBlur;
  Stream<Event> get onChange => _element.onChange;
  Stream<MouseEvent> get onClick => _element.onClick;
  Stream<MouseEvent> get onContextMenu => _element.onContextMenu;
  Stream<Event> get onCopy => _element.onCopy;
  Stream<Event> get onCut => _element.onCut;
  Stream<Event> get onDoubleClick => _element.onDoubleClick;
  Stream<MouseEvent> get onDrag => _element.onDrag;
  Stream<MouseEvent> get onDragEnd => _element.onDragEnd;
  Stream<MouseEvent> get onDragEnter => _element.onDragEnter;
  Stream<MouseEvent> get onDragLeave => _element.onDragLeave;
  Stream<MouseEvent> get onDragOver => _element.onDragOver;
  Stream<MouseEvent> get onDragStart => _element.onDragStart;
  Stream<MouseEvent> get onDrop => _element.onDrop;
  Stream<Event> get onError => _element.onError;
  Stream<Event> get onFocus => _element.onFocus;
  Stream<Event> get onInput => _element.onInput;
  Stream<Event> get onInvalid => _element.onInvalid;
  Stream<KeyboardEvent> get onKeyDown => _element.onKeyDown;
  Stream<KeyboardEvent> get onKeyPress => _element.onKeyPress;
  Stream<KeyboardEvent> get onKeyUp => _element.onKeyUp;
  Stream<Event> get onLoad => _element.onLoad;
  Stream<MouseEvent> get onMouseDown => _element.onMouseDown;
  Stream<MouseEvent> get onMouseMove => _element.onMouseMove;
  Stream<Event> get onFullscreenChange => _element.onFullscreenChange;
  Stream<Event> get onFullscreenError => _element.onFullscreenError;
  Stream<Event> get onPaste => _element.onPaste;
  Stream<Event> get onReset => _element.onReset;
  Stream<Event> get onScroll => _element.onScroll;
  Stream<Event> get onSearch => _element.onSearch;
  Stream<Event> get onSelect => _element.onSelect;
  Stream<Event> get onSelectStart => _element.onSelectStart;
  Stream<Event> get onSubmit => _element.onSubmit;
  Stream<MouseEvent> get onMouseOut => _element.onMouseOut;
  Stream<MouseEvent> get onMouseOver => _element.onMouseOver;
  Stream<MouseEvent> get onMouseUp => _element.onMouseUp;
  Stream<TouchEvent> get onTouchCancel => _element.onTouchCancel;
  Stream<TouchEvent> get onTouchEnd => _element.onTouchEnd;
  Stream<TouchEvent> get onTouchEnter => _element.onTouchEnter;
  Stream<TouchEvent> get onTouchLeave => _element.onTouchLeave;
  Stream<TouchEvent> get onTouchMove => _element.onTouchMove;
  Stream<TouchEvent> get onTouchStart => _element.onTouchStart;
  Stream<TransitionEvent> get onTransitionEnd => _element.onTransitionEnd;

  // TODO(sigmund): do the normal forwarding when dartbug.com/7919 is fixed.
  Stream<WheelEvent> get onMouseWheel {
    throw new UnsupportedError('onMouseWheel is not supported');
  }
}

/**
 * Set this to true to use native Shadow DOM if it is supported.
 * Note that this will change behavior of [WebComponent] APIs for tree
 * traversal.
 */
bool useShadowDom = false;

bool get _realShadowRoot => useShadowDom && ShadowRoot.supported;
