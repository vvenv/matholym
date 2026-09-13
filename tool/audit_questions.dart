// Sweeps every template across seeds and difficulties and reports mechanical
// defects: malformed stems, giveaway distractors, thin solutions.
import 'dart:io';

import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/choices.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/number_theory.dart';

const seeds = [1, 2, 3, 7, 11, 17, 23, 42, 99, 123, 555, 2024];

void main(List<String> args) {
  final dumpArg = args.firstWhere(
    (a) => a == '--dump' || a.startsWith('--dump='),
    orElse: () => '',
  );
  final dump = dumpArg.isNotEmpty;
  final dumpPath = dumpArg.contains('=')
      ? dumpArg.substring('--dump='.length)
      : 'build/questions.txt';
  final only = args.firstWhere((a) => a.startsWith('--only='), orElse: () => '');
  final filter = only.isEmpty ? '' : only.substring('--only='.length);
  final problems = <String, List<String>>{};
  final out = StringBuffer();
  var total = 0;

  void flag(String tag, String detail) =>
      (problems[tag] ??= <String>[]).add(detail);

  for (final t in questionTemplates) {
    if (filter.isNotEmpty && !t.id.contains(filter)) continue;
    for (final d in t.difficulties) {
      for (final seed in seeds) {
        final q = t.build(seed, d);
        total++;
        final where = '${t.id} ${d.name} seed=$seed';
        final opts = QuestionOptions.of(q);
        if (dump) {
          out.writeln('## $where');
          out.writeln('Q: ${q.stem}');
          out.writeln('A: ${q.answer}   [${opts.join(" | ")}]');
          for (final s in q.steps) {
            out.writeln('   . $s');
          }
          if (q.figure != null) out.writeln('   fig: ${q.figure!.semantics}');
          out.writeln();
        }

        // --- stem hygiene
        final stem = q.stem;
        if (stem.split(r'$').length.isEven) flag('tex-unbalanced', '$where :: $stem');
        if (stem.contains('  ')) flag('double-space', '$where :: $stem');
        if (stem.trim() != stem) flag('edge-space', '$where :: $stem');
        if (stem.contains('，，') || stem.contains('。。') || stem.contains('、、')) {
          flag('double-punct', '$where :: $stem');
        }
        if (RegExp(r'[，。？：]\s*[，。？：]').hasMatch(stem)) {
          flag('punct-run', '$where :: $stem');
        }
        if (RegExp(r'[a-zA-Z0-9]\*[a-zA-Z0-9]').hasMatch(stem)) {
          flag('raw-star', '$where :: $stem');
        }
        if (stem.contains('null') || stem.contains('Instance of')) {
          flag('null-in-stem', '$where :: $stem');
        }
        if (RegExp(r'(?<![\d.])-\s*-').hasMatch(stem)) {
          flag('double-minus', '$where :: $stem');
        }
        if (RegExp(r'\+\s*-|\-\s*\+').hasMatch(stem.replaceAll(RegExp(r'\$[^$]*\$'), ''))) {
          flag('sign-run', '$where :: $stem');
        }
        if (!RegExp(r'[？?。]$').hasMatch(stem.trim()) &&
            !stem.trim().endsWith('）') &&
            !stem.trim().endsWith('.')) {
          flag('no-end-punct', '$where :: $stem');
        }

        // --- answer hygiene
        final a = q.answer;
        if (a.trim().isEmpty) flag('empty-answer', where);
        if (a != a.trim()) flag('answer-space', '$where :: "$a"');
        if (a.contains(r'$')) flag('answer-tex', '$where :: $a');
        if (!q.check(a)) flag('self-check-fail', where);
        if (q.kind == QuestionKind.judge && a != '是' && a != '否') {
          flag('judge-answer', '$where :: $a');
        }
        if (RegExp(r'^-?\d+\.0+$').hasMatch(a)) flag('float-int-answer', '$where :: $a');
        final frac = RegExp(r'^(-?\d+)/(\d+)$').firstMatch(a);
        if (frac != null) {
          final n = int.parse(frac.group(1)!);
          final den = int.parse(frac.group(2)!);
          if (den == 1) flag('int-as-frac', '$where :: $a');
          if (NumberTheory.gcd(n.abs(), den) != 1) {
            flag('unreduced-frac', '$where :: $a');
          }
        }

        // --- choice hygiene
        if (q.kind != QuestionKind.judge) {
          // A residue mod 3 has only three candidates; a fourth button would
          // have to print something that cannot be an answer.
          final range = q.answerRange;
          final room = range == null ? 4 : range.max - range.min + 1;
          if (opts.length != (room < 4 ? room : 4)) {
            flag('opt-count', '$where :: $opts');
          }
          if (opts.toSet().length != opts.length) flag('opt-dup', '$where :: $opts');
          if (!opts.contains(a)) flag('opt-missing-answer', '$where :: $opts');
          for (final o in opts) {
            if (o == a) continue;
            if (NumberTheory.answersEqual(a, o)) {
              flag('opt-duplicate-value', '$where :: answer=$a opts=$opts');
              break;
            }
          }
          final shapes = opts.map(_shape).toSet();
          if (shapes.length > 1) {
            flag('opt-shape-mismatch', '$where :: answer=$a opts=$opts');
          }
          if (RegExp(r'^\d+$').hasMatch(a)) {
            for (final o in opts) {
              if (o.startsWith('-')) {
                flag('opt-negative', '$where :: answer=$a opts=$opts');
                break;
              }
            }
          }
        }

        // --- solution hygiene
        if (q.steps.isEmpty) flag('no-steps', where);
        if (q.hints.isEmpty) flag('no-hints', where);
        if (q.steps.any((s) => s.trim().isEmpty)) flag('blank-step', where);
        if (q.nodeRefs.isEmpty) flag('no-node-refs', where);
      }
    }
  }

  if (dump) {
    final file = File(dumpPath);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(out.toString());
    stdout.writeln('wrote ${file.path}');
  }
  stdout.writeln('swept $total questions from ${questionTemplates.length} templates');
  final keys = problems.keys.toList()
    ..sort((x, y) => problems[y]!.length.compareTo(problems[x]!.length));
  for (final k in keys) {
    final list = problems[k]!;
    final templates = list
        .map((e) => e.split(' ').first)
        .toSet()
        .toList()
      ..sort();
    stdout.writeln('\n### $k  (${list.length} hits, ${templates.length} templates)');
    stdout.writeln('templates: ${templates.take(14).join(", ")}'
        '${templates.length > 14 ? " …" : ""}');
    for (final e in list.take(4)) {
      stdout.writeln('  - $e');
    }
  }
}

String _shape(String s) {
  if (RegExp(r'^-?\d+$').hasMatch(s)) return 'int';
  if (RegExp(r'^-?\d+/\d+$').hasMatch(s)) return 'frac';
  if (RegExp(r'^-?\d+(\.\d+)$').hasMatch(s)) return 'dec';
  if (RegExp(r'^[\d,\s]+$').hasMatch(s)) return 'csv';
  if (RegExp(r'^[\d^*]+$').hasMatch(s)) return 'factored';
  return 'text';
}
