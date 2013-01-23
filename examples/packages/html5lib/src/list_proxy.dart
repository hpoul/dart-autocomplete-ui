// TODO(jmesserly): remove this once we have a subclassable growable list
// in our libraries.

/** A [List] proxy that you can subclass. */
library list_proxy;

// TODO(jmesserly): this should extend the base list.
// See http://code.google.com/p/dart/issues/detail?id=949
/** A [List<T>] proxy that you can subclass. */
class ListProxy<E> extends Collection<E> implements List<E> {

  /** The inner [List<T>] with the actual storage. */
  final List<E> _list;

  /**
   * Creates a list proxy.
   * You can optionally specify the list to use for [storage] of the items,
   * otherwise this will create a [List<E>].
   */
  ListProxy([List<E> storage])
     : _list = storage != null ? storage : <E>[];

  // TODO(jmesserly): This should be on List.
  // See http://code.google.com/p/dart/issues/detail?id=947
  bool remove(E item) {
    int i = indexOf(item);
    if (i == -1) return false;
    removeAt(i);
    return true;
  }

  // TODO(jmesserly): This should be on List, to match removeAt.
  // See http://code.google.com/p/dart/issues/detail?id=5375
  void insertAt(int index, E item) => insertRange(index, 1, item);

  // Override from Iterable to fix performance
  // Length and last become O(1) instead of O(N)
  // The others are just different constant factor.
  int get length => _list.length;
  E get last => _list.last;
  E get first => _list.first;
  E get single => _list.single;

  // From Iterable
  Iterator<E> get iterator => _list.iterator;

  // From List
  E operator [](int index) => _list[index];
  operator []=(int index, E value) { _list[index] = value; }
  set length(int value) { _list.length = value; }
  void add(E value) { _list.add(value); }
  void addLast(E value) { _list.addLast(value); }
  void addAll(Iterable<E> collection) { _list.addAll(collection); }
  void sort([int compare(E a, E b)]) { _list.sort(compare); }

  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);
  int lastIndexOf(E element, [int start]) => _list.lastIndexOf(element, start);
  void clear() { _list.clear(); }

  E removeAt(int index) {
    // TODO(jmesserly): removeAt not implemented on the VM?
    var result = _list[index];
    _list.removeRange(index, 1);
    return result;
  }
  E removeLast() => _list.removeLast();
  List<E> getRange(int start, int length) => _list.getRange(start, length);
  void setRange(int start, int length, List<E> from, [int startFrom]) {
    _list.setRange(start, length, from, startFrom);
  }
  void removeRange(int start, int length) { _list.removeRange(start, length); }
  void insertRange(int start, int length, [E initialValue]) {
    _list.insertRange(start, length, initialValue);
  }
}
