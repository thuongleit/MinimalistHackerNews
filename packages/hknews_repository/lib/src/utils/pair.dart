/// A pair of values
class Pair<F, S> {
  Pair(this.first, this.second);

  final F first;
  final S second;

  @override
  String toString() => 'Pair[$first, $second]';
}
