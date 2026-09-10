import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/info_tip.dart';
import '../../core/widgets/math_text.dart';
import '../../domain/generators/question.dart';
import '../../domain/wrong_book.dart';
import '../../providers.dart';
import 'practice_controller.dart';

class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({super.key, required this.args});

  final PracticeArgs args;

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  final _answer = TextEditingController();
  String? _bootError;
  var _starting = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_start);
  }

  Future<void> _start() async {
    final error = await ref.read(practiceProvider.notifier).start(widget.args);
    if (mounted) {
      setState(() {
        _bootError = error;
        _starting = false;
      });
    }
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.mode.label),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _starting
          ? const Center(child: CircularProgressIndicator())
          : _bootError != null
          ? Center(child: Text(_bootError!))
          : session == null
          ? const Center(child: Text('会话未启动'))
          : session.phase == PracticePhase.finished
          ? _ResultView(session: session)
          : _QuestionView(
              session: session,
              controller: _answer,
              onSubmit: () async {
                await ref.read(practiceProvider.notifier).submit(_answer.text);
                _answer.clear();
              },
            ),
    );
  }
}

class _QuestionView extends ConsumerWidget {
  const _QuestionView({
    required this.session,
    required this.controller,
    required this.onSubmit,
  });

  final PracticeSession session;
  final TextEditingController controller;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = session.current;
    final graph = ref.watch(graphViewProvider).valueOrNull;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Text(
          '第 ${session.index + 1} / ${session.total} 题 · ${q.difficulty.label}',
          style: const TextStyle(color: AppColors.muted),
        ),
        if (session.showFluentTip) ...[
          const SizedBox(height: 10),
          const _Banner(
            color: AppColors.accent,
            text: '该节点已熟练，建议挑战下一节点。',
          ),
        ],
        if (session.lastCorrect && session.phase == PracticePhase.answering) ...[
          const SizedBox(height: 10),
          const _Banner(color: AppColors.accent, text: '+1  判断准确'),
        ],
        const SizedBox(height: 16),
        MathText(q.stem, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 20),
        if (session.phase == PracticePhase.answering) ...[
          if (q.kind == QuestionKind.judge)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      controller.text = '是';
                      await onSubmit();
                    },
                    child: const Text('是'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      controller.text = '否';
                      await onSubmit();
                    },
                    child: const Text('否'),
                  ),
                ),
              ],
            )
          else ...[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '你的答案',
                hintText: q.answerHint.isEmpty ? null : q.answerHint,
              ),
              onSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onSubmit, child: const Text('提交')),
          ],
        ],
        if (session.phase == PracticePhase.wrong ||
            session.phase == PracticePhase.solution) ...[
          for (var i = 0; i < session.hintsShown && i < q.hints.length; i++)
            _HintCard(index: i + 1, text: q.hints[i]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: ref.read(practiceProvider.notifier).moreHint,
                child: const Text('再看提示'),
              ),
              OutlinedButton(
                onPressed: ref.read(practiceProvider.notifier).showSolution,
                child: const Text('查看完整解析'),
              ),
            ],
          ),
        ],
        if (session.phase == PracticePhase.solution) ...[
          const SizedBox(height: 16),
          const Text('解析', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final step in q.steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MathText(step),
            ),
          Text('参考答案：${q.answer}', style: const TextStyle(color: AppColors.warn)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final id in q.nodeRefs)
                ActionChip(
                  label: Text(graph?.graph.nodeById(id).title ?? id),
                  onPressed: () => context.push('/card/$id'),
                ),
            ],
          ),
        ],
        if (session.phase != PracticePhase.answering && !session.lastCorrect) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('错因', style: TextStyle(color: AppColors.muted)),
              if (session.lastAttribution != null) ...[
                const SizedBox(width: 4),
                InfoTip(
                  '薄弱点：${graph?.graph.nodeById(session.lastAttribution!.attributedNodeId).title ?? session.lastAttribution!.attributedNodeId}',
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final cause in ErrorCause.values)
                ChoiceChip(
                  label: Text(cause.label),
                  selected: session.selectedCause == cause,
                  onSelected: (_) =>
                      ref.read(practiceProvider.notifier).chooseCause(cause),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.read(practiceProvider.notifier).nextAfterWrong(),
            child: Text(session.isLast ? '查看结算' : '下一题'),
          ),
        ],
      ],
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('提示 $index', style: const TextStyle(color: AppColors.info)),
            const SizedBox(width: 10),
            Expanded(child: MathText(text)),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.session});

  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    final rate = session.total == 0
        ? 0
        : (session.correctCount / session.total * 100).round();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('本轮结束', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(
            '正确 ${session.correctCount} / ${session.total}（$rate%）',
            style: const TextStyle(fontSize: 18),
          ),
          if (session.newlyMastered) ...[
            const SizedBox(height: 12),
            const _Banner(color: AppColors.accent, text: '闯关达标，节点已掌握。'),
          ],
          if (session.newlyUnlocked.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '新解锁：${session.newlyUnlocked.map((e) => e.title).join('、')}',
              style: const TextStyle(color: AppColors.info),
            ),
          ],
          const Spacer(),
          FilledButton(
            onPressed: () => context.go('/tree'),
            child: const Text('回到知识树'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
