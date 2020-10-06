/// A pair of values
class Pair<L, R> {
  Pair(this.left, this.right);

  final L left;
  final R right;

  @override
  String toString() => 'Pair[$left, $right]';
}
