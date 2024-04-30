typedef Predicate<T> = bool Function(T value);

Predicate<T> not<T>(Predicate<T> predicate) {
  return (T value) => !predicate(value);
}

extension PredicateExt<T> on Predicate<T> {
  Predicate<T> and(Predicate<T> other) {
    return (T value) => this(value) && other(value);
  }

  Predicate<T> or(Predicate<T> other) {
    return (T value) => this(value) || other(value);
  }
}
