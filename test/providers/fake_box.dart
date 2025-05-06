import 'package:hive/hive.dart';

class FakeBox<T> implements Box<T> {
  final Map<dynamic, T> _map = {};
  FakeBox([Iterable<T>? initial]) {
    if (initial != null) {
      for (var v in initial) {
        _map[(v as dynamic).id] = v;
      }
    }
  }

  @override
  Iterable<T> get values => _map.values;

  @override
  T? get(key, {T? defaultValue}) => _map[key] ?? defaultValue;

  @override
  Future<void> put(key, T value) async {
    _map[key] = value;
  }

  @override
  Future<void> delete(key) async {
    _map.remove(key);
  }

  @override
  Future<int> clear() async {
    final count = _map.length;
    _map.clear();
    return count;
  }

  @override
  int get length => _map.length;

  // Les autres méthodes ne sont pas utilisées dans les tests actuels
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
