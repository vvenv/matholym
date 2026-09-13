import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/core/widgets/math_text.dart';
import 'package:matholym/domain/knowledge/graph.dart';

void main() {
  test('node subtitles parse as TeX in both graph sources', () {
    List<dynamic> nodesOf(String path) =>
        (jsonDecode(File(path).readAsStringSync())
                as Map<String, dynamic>)['nodes']
            as List<dynamic>;
    final subtitles = [
      for (final graph in [
        knowledgeGraph,
        calculationGraph,
        algebraGraph,
        combinatoricsGraph,
        geometryGraph,
        logicGraph,
      ])
        for (final node in graph.nodes) node.subtitle,
      for (final path in [
        'assets/seeds/nodes.json',
        'assets/seeds/calculation_nodes.json',
        'assets/seeds/algebra_nodes.json',
        'assets/seeds/combinatorics_nodes.json',
        'assets/seeds/geometry_nodes.json',
        'assets/seeds/logic_nodes.json',
      ])
        for (final node in nodesOf(path))
          (node as Map<String, dynamic>)['subtitle'] as String,
    ];
    for (final subtitle in subtitles) {
      for (final part in MathText.splitMath(subtitle).where((p) => p.math)) {
        expect(Math.tex(part.tex).parseError, isNull, reason: subtitle);
      }
    }
  });

  testWidgets('punctuation after inline math rides with the math', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MathText(r'则称 $a$ 整除 $b$，记作 $a \mid b$。此时（$k$）为整数'),
        ),
      ),
    );
    // Glued punctuation renders as its own Text beside the math, so the line
    // breaker cannot strand it at the start of a line.
    expect(find.text('，'), findsOneWidget);
    expect(find.text('。'), findsOneWidget);
    expect(find.text('（'), findsOneWidget);
    expect(find.text('）'), findsOneWidget);
  });

  test('splitMath keeps text, inline, and display parts in order', () {
    final parts = MathText.splitMath(r'设 $a$ 有 $$a = bq + r$$ 成立');
    expect(parts.map((p) => (p.math, p.display)).toList(), [
      (false, false),
      (true, false),
      (false, false),
      (true, true),
      (false, false),
    ]);
  });
}
