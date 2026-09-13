import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_figure.dart';
import '../../core/widgets/math_text.dart';
import '../../core/widgets/quiet_tap.dart';
import '../../core/widgets/study_bar.dart';
import '../../core/widgets/study_section.dart';
import '../../domain/figure.dart';
import '../../domain/generators/question.dart';
import '../../domain/knowledge/models.dart';
import '../../domain/mastery.dart';
import '../../providers.dart';

class CardPage extends ConsumerWidget {
  const CardPage({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The node's own tree, not the one on screen: a card reached from the
    // wrong book can belong to another subject.
    final graph = ref.watch(nodeViewProvider(nodeId));
    final seeds = ref.watch(seedStoreProvider);

    return graph.when(
      loading: () => const Scaffold(body: QuietProgress()),
      error: (e, _) => Scaffold(
        body: Center(child: Text('$e', style: AppType.body)),
      ),
      data: (view) {
        final node = view.graph.nodeOrNull(nodeId);
        if (node == null) return const _MissingNode();
        final card = seeds.valueOrNull?.cardFor(node.id);
        final prereqs = [
          for (final id in node.prerequisites) view.graph.nodeById(id),
        ];
        final next = view.graph.dependentsOf(node.id);
        // Definition, then what follows from it, then it at work, then traps.
        final sections = [
          if (card != null && card.theorems.isNotEmpty)
            StudySection.lines(label: '性质', lines: card.theorems),
          if (card != null && card.examples.isNotEmpty)
            StudySection.lines(label: '例', lines: card.examples),
          if (card != null && card.commonMistakes.isNotEmpty)
            StudySection.lines(
              label: '易错',
              lines: card.commonMistakes,
              tick: AppColors.danger,
            ),
        ];
        return Scaffold(
          body: Column(
            children: [
              StudyBar.page(),
              Expanded(
                child: PageColumn(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.page,
                    AppSpace.lg,
                    AppSpace.page,
                    AppSpace.xl,
                  ),
                  children: [
                    _Heading(
                      node: node,
                      levelLabel: view.graph.levelLabel(node.level),
                    ),
                    const SizedBox(height: AppSpace.lg),
                    if (card != null) MathText(card.definition),
                    if (cardFigureFor(node.id) case final fig?) ...[
                      const SizedBox(height: AppSpace.lg),
                      MathFigureView(figure: fig),
                    ],
                    for (final section in sections) ...[
                      const SizedBox(height: AppSpace.lg),
                      section,
                    ],
                    if (prereqs.isNotEmpty || next.isNotEmpty) ...[
                      const SizedBox(height: AppSpace.xl),
                      const Divider(),
                      const SizedBox(height: AppSpace.md),
                      _RelatedNodes(prerequisites: prereqs, dependents: next),
                    ],
                  ],
                ),
              ),
              StudyDock(
                child: node.practiceReady
                    ? _ChallengeDock(
                        mastered: view.statusOf(node.id) == NodeStatus.mastered,
                        progress: view.progress[node.id],
                        onStart: () => context.push(
                          '/practice?mode=challenge&nodeId=${node.id}',
                        ),
                        onDrill: (difficulty) => context.push(
                          '/practice?mode=special&nodeId=${node.id}'
                          '&difficulty=${difficulty.name}',
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: Text('这一节的练习还在准备，先读懂概念。', style: AppType.meta),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.node, required this.levelLabel});

  final KnowledgeNode node;
  final String levelLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(levelLabel, style: AppType.mark),
          const SizedBox(height: 10),
          Text(
            node.title,
            style: AppType.display.copyWith(fontSize: 26, letterSpacing: 1.2),
          ),
          if (node.subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            MathText(node.subtitle, style: AppType.meta),
          ],
        ],
      ),
    );
  }
}

/// Challenge on the left, and next to it the run that does not judge: a warm
/// up before the first pass, a harder set once the node is done.
class _ChallengeDock extends StatelessWidget {
  const _ChallengeDock({
    required this.mastered,
    required this.progress,
    required this.onStart,
    required this.onDrill,
  });

  final bool mastered;
  final NodeProgressSnapshot? progress;
  final VoidCallback onStart;
  final void Function(Difficulty difficulty) onDrill;

  @override
  Widget build(BuildContext context) {
    final p = progress;
    final rule =
        '${MasteryRules.challengeSize} 题，对 ${MasteryRules.passCount} 题过关';
    final note = mastered
        ? '已掌握'
        : p != null && p.attempts > 0
        ? '正确率 ${(p.accuracy * 100).round()}% · $rule'
        : rule;
    return Row(
      children: [
        FilledButton(onPressed: onStart, child: Text(mastered ? '再闯' : '闯关')),
        const SizedBox(width: AppSpace.xs),
        TextButton(
          onPressed: () =>
              onDrill(mastered ? Difficulty.medium : Difficulty.basic),
          child: Text(mastered ? '加练' : '先练一组'),
        ),
        const SizedBox(width: AppSpace.xs),
        Expanded(
          child: Text(
            note,
            maxLines: 2,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppType.meta.copyWith(
              height: 1.5,
              color: mastered ? AppColors.mastered : AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

/// A card whose node no tree carries any more: a link from an older build.
class _MissingNode extends StatelessWidget {
  const _MissingNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StudyBar.page(),
          const Expanded(
            child: Center(child: Text('找不到这一节', style: AppType.body)),
          ),
        ],
      ),
    );
  }
}

class _RelatedNodes extends StatelessWidget {
  const _RelatedNodes({required this.prerequisites, required this.dependents});

  final List<KnowledgeNode> prerequisites;
  final List<KnowledgeNode> dependents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prerequisites.isNotEmpty)
          _RelatedLine(label: '前置', nodes: prerequisites),
        if (prerequisites.isNotEmpty && dependents.isNotEmpty)
          const SizedBox(height: 4),
        if (dependents.isNotEmpty) _RelatedLine(label: '后续', nodes: dependents),
      ],
    );
  }
}

class _RelatedLine extends StatelessWidget {
  const _RelatedLine({required this.label, required this.nodes});

  final String label;
  final List<KnowledgeNode> nodes;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SizedBox(width: 30, child: Text(label, style: AppType.meta)),
        ),
        Expanded(
          child: Wrap(
            spacing: 2,
            children: [
              for (final node in nodes)
                QuietTap(
                  onTap: () => context.push('/card/${node.id}'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Text(
                    node.title,
                    style: AppType.meta.copyWith(color: AppColors.text),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
