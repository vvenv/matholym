import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/question.dart';

const _seeds = 60;

/// How the questions read. A trainer that prints `\ldots` as text, spaces a
/// Chinese sentence like English, or asks a question whose answer never
/// changes does not look like something a teacher wrote.
void main() {
  test('no TeX command escapes its math span', () {
    final leaks = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (var seed = 1; seed <= _seeds; seed++) {
          final q = t.build(seed, d);
          for (final text in [q.stem, ...q.hints, ...q.steps]) {
            final outside = StringBuffer();
            var inMath = false;
            for (var i = 0; i < text.length; i++) {
              if (text[i] == r'$') {
                inMath = !inMath;
                continue;
              }
              if (!inMath) outside.write(text[i]);
            }
            final m = RegExp(r'\\[a-zA-Z]+').firstMatch(outside.toString());
            if (m != null) leaks.add('${t.id} :: ${m.group(0)} in $text');
          }
        }
      }
    }
    expect(leaks, isEmpty);
  });

  test('no space between two Chinese characters', () {
    // The spaces around a math span are deliberate; these are not.
    final cjk = RegExp(r'[一-鿿，。、；：？！「」（）]');
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (var seed = 1; seed <= _seeds; seed++) {
          final q = t.build(seed, d);
          for (final text in [q.stem, ...q.hints, ...q.steps]) {
            final bare = text.replaceAll(RegExp(r'\$[^$]*\$'), '§');
            for (var i = 1; i < bare.length - 1; i++) {
              if (bare[i] != ' ') continue;
              if (cjk.hasMatch(bare[i - 1]) && cjk.hasMatch(bare[i + 1])) {
                bad.add('${t.id} :: $text');
                break;
              }
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('no coefficient written as 1x, and no ratio left unreduced', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (var seed = 1; seed <= _seeds; seed++) {
          final stem = t.build(seed, d).stem;
          if (RegExp(r'(?<![\d.])1 ?[xy](?![\d²])').hasMatch(stem)) {
            bad.add('${t.id} coefficient :: $stem');
          }
          for (final m in RegExp(r'(\d+) ?: ?(\d+)').allMatches(stem)) {
            var x = int.parse(m.group(1)!);
            var y = int.parse(m.group(2)!);
            while (y != 0) {
              final t2 = x % y;
              x = y;
              y = t2;
            }
            if (x > 1) bad.add('${t.id} ratio ${m.group(0)} :: $stem');
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('a template whose answer never changes is answerable by rote', () {
    // These are facts, not variables: a cube has 6 faces, a square number ends
    // in one of 6 digits, and a self-referential 「恰有 k 句为真」 puzzle has
    // one consistent count. Everything else has to move with the seed.
    const constantByNature = {
      'truth.exact', 'truth.who', 'net.faces', 'sch.who', 'end.list',
      'icp.ask', 'bis.side', 'box.pear', 'wst.rank', 'wst.who',
      'tha.right', 'odr.idx', 'odr.n',
    };
    final rote = <String>[];
    for (final t in questionTemplates) {
      final d = t.difficulties.first;
      if (constantByNature.contains(t.id)) continue;
      final answers = <String>{};
      for (var seed = 1; seed <= _seeds; seed++) {
        final q = t.build(seed, d);
        if (q.kind == QuestionKind.judge) {
          answers.add('judge');
          continue;
        }
        answers.add(q.answer);
      }
      if (answers.length == 1 && answers.single != 'judge') {
        rote.add('${t.id} -> ${answers.single}');
      }
    }
    expect(rote, isEmpty);
  });
}
