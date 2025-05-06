import 'package:hive/hive.dart';

class FakeBox<T> implements Box<T> {
  final Map<dynamic, T> _store = {};

  @override
  Iterable<T> get values => _store.values;

  @override
  Future<void> put(dynamic key, T value) async {
    _store[key] = value;
  }

  @override
  T? get(dynamic key, {T? defaultValue}) {
    return _store.containsKey(key) ? _store[key] : defaultValue;
  }

  @override
  Future<void> delete(dynamic key) async {
    _store.remove(key);
  }

  // Ajoute d'autres méthodes si besoin, ou lance UnimplementedError pour le reste
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
