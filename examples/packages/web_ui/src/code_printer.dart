// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library code_printer;

/** Helper class that auto-formats generated code. */
class CodePrinter {
  List _items = [];

  /**
   * Adds [object] to this printer and appends a new-line after it. Returns this
   * printer.
   */
  CodePrinter add(object) {
    _items.add(object);
    if (object is! CodePrinter) {
      _items.add('\n');
    }
    return this;
  }

  /** Adds [object] without changing its indentation or appending a newline. */
  CodePrinter addRaw(object) {
    _items.add(new _Raw(object));
    return this;
  }

  /** Returns everything on this printer without any fixes on indentation. */
  String toString() => (new StringBuffer()..addAll(_items)).toString();

  /**
   * Returns a formatted code block, with indentation appropriate to code
   * blocks' nesting level.
   */
  String formatString([int indent = 0]) {
    bool lastEmpty = false;
    var buff = new StringBuffer();
    for (var item in _items) {
      if (item is _Raw) {
        item = (item as _Raw).item;
        buff.add(item);
        continue;
      }
      if (item is Declarations) {
        (item as Declarations)._format(buff, indent);
        continue;
      }

      for (var line in item.toString().split('\n')) {
        line = line.trim();
        if (line == '') {
          if (lastEmpty) continue;
          lastEmpty = true;
        } else {
          lastEmpty = false;
        }
        bool decIndent = line.startsWith("}") || line.startsWith("]");
        bool incIndent = line.endsWith("{") || line.endsWith("[");
        if (decIndent) indent--;
        _indent(buff, indent);
        buff.add(line);
        buff.add('\n');
        if (incIndent) indent++;
      }
    }
    return buff.toString();
  }
}


// TODO(jmesserly): we could simplify by building formatted strings eagerly.
/**
 * This class is used as a marker for raw strings, so they do not have their
 * indentation changed.
 */
class _Raw {
  final item;
  _Raw(this.item);
  String toString() => item.toString();
}

/** A declaration of a field or local variable. */
class Declaration implements Comparable {
  final String type;
  final String name;
  Declaration(this.type, this.name);

  int compareTo(Declaration other) {
    if (type != other.type) return type.compareTo(other.type);
    return name.compareTo(other.name);
  }
}

/** A set of declarations grouped together. */
class Declarations {

  /** All declarations in this group. */
  final List<Declaration> declarations = <Declaration>[];

  /**
   * Whether these declarations are local variables (otherwise they are fields
   * in a class.
   */
  final bool isLocal;

  Declarations(this.isLocal);

  void add(String type, String identifier) {
    declarations.add(new Declaration(isLocal ? 'var' : type, identifier));
  }

  String formatString([int indent = 0]) {
    var buff = new StringBuffer();
    _format(buff, indent);
    return buff.toString();
  }

  void _format(StringBuffer buff, int indent) {
    if (declarations.length == 0) return;
    declarations.sort();
    var lastType = null;
    _indent(buff, indent);
    for (var d in declarations) {
      if (d.type != lastType) {
        if (lastType != null) {
          buff.add(';\n');
          _indent(buff, indent);
        }
        buff.add(d.type);
        lastType = d.type;
      } else {
        buff.add(',');
      }
      buff.add(' ');
      buff.add(d.name);
    }
    buff.add(';');
  }

  String toString() => formatString(0);
}

_indent(StringBuffer buff, int indent) {
  for (int i = 0; i < indent; i++) buff.add('  ');
}
