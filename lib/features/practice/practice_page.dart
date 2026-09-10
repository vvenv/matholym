import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_text.dart';
import '../../domain/generators/question.dart';
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

  String _progressTitle(PracticeSession? session) {
    if (session == null || session.phase == PracticePhase.finished) return '';
    final i = (session.index + 1).toString().padLeft(2, '0');
    final n = session.total.toString().padLeft(2, '0');
    return '$i  /  $n';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_progressTitle(session), style: AppType.tabular),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: _starting
          ? const QuietProgress()
          : _bootError != null
          ? Center(child: Text(_bootError!, style: AppType.body))
          : session == null
          ? const Center(child: Text('未开始', style: AppType.meta))
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
    final practice = ref.read(practiceProvider.notifier);
    final progress = session.total == 0 ? 0.0 : (session.index + 1) / session.total;
    return Column(
      children: [
        LinearProgressIndicator(value: progress, minHeight: 1),
        Expanded(
          child: PageColumn(
            children: [
              MathText(q.stem, style: AppType.title.copyWith(height: 1.55, fontWeight: FontWeight.w400)),
              const SizedBox(height: AppSpace.xl),
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
                      const SizedBox(width: AppSpace.sm),
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
                    style: AppType.body,
                    cursorColor: AppColors.accent,
                    decoration: const InputDecoration(hintText: '答案'),
                    onSubmitted: (_) => onSubmit(),
                  ),
                  const SizedBox(height: AppSpace.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(onPressed: onSubmit, child: const Text('提交')),
                  ),
                ],
              ],
              if (session.phase == PracticePhase.wrong ||
                  session.phase == PracticePhase.solution) ...[
                for (var i = 0; i < session.hintsShown && i < q.hints.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.md),
                    child: MathText(q.hints[i], style: AppType.body.copyWith(color: AppColors.muted)),
                  ),
                if (session.phase == PracticePhase.solution) ...[
                  for (final step in q.steps)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.sm),
                      child: MathText(step),
                    ),
                  Text(q.answer, style: AppType.meta),
                  const SizedBox(height: AppSpace.md),
                ],
                Row(
                  children: [
                    if (session.phase != PracticePhase.solution) ...[
                      TextButton(onPressed: practice.moreHint, child: const Text('提示')),
                      TextButton(onPressed: practice.showSolution, child: const Text('解析')),
                    ],
                    const Spacer(),
                    FilledButton(
                      onPressed: practice.nextAfterWrong,
                      child: Text(session.isLast ? '结束' : '下一题'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.session});

  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.lg, AppSpace.page, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${session.correctCount}',
                    style: AppType.display.copyWith(letterSpacing: 1, fontSize: 56),
                  ),
                  const SizedBox(width: 10),
                  Text('/  ${session.total}', style: AppType.meta.copyWith(fontSize: 16)),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
              const ColoredBox(
                color: AppColors.accent,
                child: SizedBox(width: 28, height: 1.5),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('返回'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
