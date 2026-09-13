/// Elementary / junior-high algebra helpers used by generators.
class Algebra {
  const Algebra._();

  /// Solve [a]x + [b] = [c] in integers. Null if not integral.
  static int? linearRoot(int a, int b, int c) {
    if (a == 0) return null;
    if ((c - b) % a != 0) return null;
    return (c - b) ~/ a;
  }

  static ({int larger, int smaller}) fromSumDiff(int sum, int diff) {
    assert((sum + diff) % 2 == 0, '和与差要同奇偶，两数才是整数');
    return (larger: (sum + diff) ~/ 2, smaller: (sum - diff) ~/ 2);
  }

  /// 每人 [perMore] 个剩 [leftover]；每人 [perLess] 个差 [short]。求人数。
  static int peopleFromExcessDeficit({
    required int perMore,
    required int leftover,
    required int perLess,
    required int short,
  }) {
    assert((leftover + short) % (perLess - perMore) == 0, '人数要是整数');
    final den = perLess - perMore;
    return (leftover + short) ~/ den;
  }

  static int itemsFromExcessDeficit({
    required int people,
    required int perMore,
    required int leftover,
  }) {
    return people * perMore + leftover;
  }

  static int shareByRatio({
    required int total,
    required int part,
    required int other,
  }) {
    assert(total * part % (part + other) == 0, '按比分配要分得整数');
    return total * part ~/ (part + other);
  }

  static int meetTime({required int dist, required int v1, required int v2}) {
    assert(dist % (v1 + v2) == 0, '相遇时间要是整数');
    return dist ~/ (v1 + v2);
  }

  static int catchTime({
    required int lead,
    required int fast,
    required int slow,
  }) {
    assert(lead % (fast - slow) == 0, '追及时间要是整数');
    return lead ~/ (fast - slow);
  }

  /// Days for A and B together if A alone takes [a] days, B [b] days.
  static int togetherDays(int a, int b) {
    assert(a * b % (a + b) == 0, '合作天数要是整数');
    return (a * b) ~/ (a + b);
  }

  static int expandValue(int a, int b, int c) => (a + b) * c;

  /// Largest integer x satisfying [a]x + [b] < [c], assuming a > 0.
  static int largestIntLess(int a, int b, int c) {
    // ax < c-b, x < (c-b)/a
    final num = c - b;
    if (num % a == 0) return num ~/ a - 1;
    return num ~/ a;
  }

  static int arithTerm(int a1, int d, int n) => a1 + (n - 1) * d;

  static int arithSum(int a1, int d, int n) => n * (2 * a1 + (n - 1) * d) ~/ 2;

  /// The concentration of a two-part mixture, in whole percent. Null when the
  /// weighted mean is not a whole number: a mixture question that rounds
  /// silently teaches a wrong answer, so the caller has to pick other numbers.
  static int? mixPercent({
    required int w1,
    required int p1,
    required int w2,
    required int p2,
  }) {
    final total = w1 + w2;
    final solute = w1 * p1 + w2 * p2;
    return solute % total == 0 ? solute ~/ total : null;
  }

  static ({int chickens, int rabbits}) chickenRabbit({
    required int heads,
    required int legs,
  }) {
    assert((legs - 2 * heads) % 2 == 0, '脚数减两倍头数要是偶数');
    final rabbits = (legs - 2 * heads) ~/ 2;
    return (chickens: heads - rabbits, rabbits: rabbits);
  }

  static int treesOnLine({required int length, required int gap}) {
    assert(length % gap == 0, '株距要整除全长');
    return length ~/ gap + 1;
  }

  static int treesOnCircle({required int length, required int gap}) {
    assert(length % gap == 0, '株距要整除周长');
    return length ~/ gap;
  }

  /// Years until the older is [times] times the younger.
  static int yearsUntil({
    required int older,
    required int younger,
    required int times,
  }) {
    assert((older - times * younger) % (times - 1) == 0, '年龄差问题的年数要是整数');
    return (older - times * younger) ~/ (times - 1);
  }

  /// People standing on the edge of an n×n square formation.
  static int formationEdge(int side) => side <= 1 ? side : 4 * (side - 1);

  /// Days until grass is gone: stock + t·grow = cows·t.
  static int grassDays({
    required int stock,
    required int grow,
    required int cows,
  }) {
    assert(stock % (cows - grow) == 0, '牛吃草的天数要是整数');
    return stock ~/ (cows - grow);
  }

  static int quadSum(int p, int q) => p + q;

  static int quadProd(int p, int q) => p * q;

  static int linearAt({required int k, required int b, required int x}) =>
      k * x + b;

  /// Minimum of x + c/x for x > 0 when c is a perfect square.
  static int amGmMin(int c) {
    var r = 1;
    while (r * r < c) {
      r++;
    }
    return 2 * r;
  }

  static int downstream({
    required int still,
    required int current,
    required int dist,
  }) {
    assert(dist % (still + current) == 0, '顺水时间要是整数');
    return dist ~/ (still + current);
  }

  static int upstream({
    required int still,
    required int current,
    required int dist,
  }) {
    assert(dist % (still - current) == 0, '逆水时间要是整数');
    return dist ~/ (still - current);
  }

  static int trainPass({
    required int trainLen,
    required int bridgeLen,
    required int speed,
  }) {
    assert((trainLen + bridgeLen) % speed == 0, '过桥时间要是整数');
    return (trainLen + bridgeLen) ~/ speed;
  }

  static int loopMeet({required int circ, required int v1, required int v2}) {
    assert(circ % (v1 + v2) == 0, '环形相遇时间要是整数');
    return circ ~/ (v1 + v2);
  }

  static int salePrice({required int price, required int off}) {
    assert(price * (100 - off) % 100 == 0, '折后价要是整数');
    return price * (100 - off) ~/ 100;
  }

  static int profitAmount({required int cost, required int rate}) {
    assert(cost * rate % 100 == 0, '利润要是整数');
    return cost * rate ~/ 100;
  }

  static ({int x, int y}) solveTwo({
    required int a1,
    required int b1,
    required int c1,
    required int a2,
    required int b2,
    required int c2,
  }) {
    final det = a1 * b2 - a2 * b1;
    return (x: (c1 * b2 - c2 * b1) ~/ det, y: (a1 * c2 - a2 * c1) ~/ det);
  }

  static int geoTerm(int a1, int ratio, int n) {
    var t = a1;
    for (var i = 1; i < n; i++) {
      t *= ratio;
    }
    return t;
  }

  static int simpleInterest({
    required int principal,
    required int rate,
    required int years,
  }) {
    assert(principal * rate * years % 100 == 0, '单利利息要是整数');
    return principal * rate * years ~/ 100;
  }

  /// Amount after [years] of annual compound interest. [years] is 2.
  static int compoundAmount({
    required int principal,
    required int rate,
    required int years,
  }) {
    var amount = principal;
    for (var i = 0; i < years; i++) {
      amount = amount * (100 + rate) ~/ 100;
    }
    return amount;
  }

  /// y / x = knownY / knownX, find y at [askX].
  static int directY({
    required int knownX,
    required int knownY,
    required int askX,
  }) {
    assert(knownY * askX % knownX == 0, '正比例的 y 要是整数');
    return knownY * askX ~/ knownX;
  }

  /// xy = k, find y at [askX].
  static int inverseY({
    required int knownX,
    required int knownY,
    required int askX,
  }) {
    assert(knownX * knownY % askX == 0, '反比例的 y 要是整数');
    return knownX * knownY ~/ askX;
  }

  static int taxiFare({
    required int baseKm,
    required int baseFare,
    required int extraPer,
    required int dist,
  }) {
    if (dist <= baseKm) return baseFare;
    return baseFare + (dist - baseKm) * extraPer;
  }

  /// Integers x with [lo] < x < [hi].
  static int openCount(int lo, int hi) {
    final n = hi - lo - 1;
    return n < 0 ? 0 : n;
  }

  /// Largest integer x with [lo] < x < [hi].
  static int openLargest(int lo, int hi) => hi - 1;

  static int vertexX(int a, int b) {
    assert(-b % (2 * a) == 0, '顶点横坐标要是整数');
    return -b ~/ (2 * a);
  }

  static int vertexY(int a, int b, int c) {
    final x = vertexX(a, b);
    return a * x * x + b * x + c;
  }

  static int absLarger(int center, int dist) => center + dist;

  static int absSum(int center) => 2 * center;

  /// Integers x with |x − [center]| < [radius].
  static int absIneqCount(int center, int radius) => 2 * radius - 1;

  static int xIntercept(int k, int b) {
    assert(-b % k == 0, '横截距要是整数');
    return -b ~/ k;
  }

  static int discriminant(int a, int b, int c) => b * b - 4 * a * c;

  static int chainShare({
    required int total,
    required int part,
    required int parts,
  }) {
    assert(total * part % parts == 0, '连比分配要分得整数');
    return total * part ~/ parts;
  }

  static int nextWithRemainder({
    required int after,
    required int modulus,
    required int residue,
  }) {
    var x = after - (after % modulus) + residue;
    if (x <= after) x += modulus;
    return x;
  }

  static int yInterceptQuad(int c) => c;

  static int invK(int x, int y) => x * y;

  static int quadMinWhenAPos(int a, int b, int c) => vertexY(a, b, c);
}
