import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_figure.dart';
import '../../core/widgets/math_text.dart';
import '../../core/widgets/quiet_tap.dart';
import '../../core/widgets/study_bar.dart';
import '../../core/widgets/study_section.dart';
import '../../domain/generators/choices.dart';
import '../../domain/generators/question.dart';
import '../../domain/mastery.dart';
import '../../providers.dart';
import 'practice_controller.dart';

/// How long a correct pick stays on screen before the next question.
const _rightBeat = Duration(milliseconds: 420);

const _digitKeys = [
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
];
const _letterKeys = [
  LogicalKeyboardKey.keyA,
  LogicalKeyboardKey.keyB,
  LogicalKeyboardKey.keyC,
  LogicalKeyboardKey.keyD,
];

enum _Mark { idle, right, wrong, dim }

class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({super.key, required this.args});

  final PracticeArgs args;

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  final _focus = FocusNode(debugLabel: 'practice');
  String? _bootError;
  var _starting = true;

  /// The option tapped on question [index], shown until the controller moves on.
  ({int index, String answer})? _pending;

  @override
  void initState() {
    super.initState();
    Future.microtask(_start);
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
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

  void _restart() {
    setState(() {
      _starting = true;
      _pending = null;
    });
    _start();
  }

  Future<void> _answer(String answer) async {
    final session = ref.read(practiceProvider);
    if (_pending != null || session == null) return;
    final practice = ref.read(practiceProvider.notifier);
    final right = session.current.check(answer);
    switch (session.phase) {
      case PracticePhase.answering:
        _feel(right);
        setState(() => _pending = (index: session.index, answer: answer));
        if (right) await Future<void>.delayed(_rightBeat);
        await practice.submit(answer);
        if (mounted) setState(() => _pending = null);
      case PracticePhase.wrong:
        if (session.tried.contains(answer)) return;
        _feel(right);
        practice.retry(answer);
      case PracticePhase.solution:
      case PracticePhase.finished:
        return;
    }
  }

  void _feel(bool right) {
    if (right) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// 1–4 / A–D pick, Enter moves on. Reads the session at key time rather than
  /// from the last build, so a key that lands before the next frame still
  /// acts on the question now on screen.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final session = ref.read(practiceProvider);
    if (event is! KeyDownEvent || _starting || session == null) {
      return KeyEventResult.ignored;
    }
    final keys = HardwareKeyboard.instance;
    if (keys.isControlPressed || keys.isMetaPressed || keys.isAltPressed) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final phase = session.phase;
    if (phase == PracticePhase.answering || phase == PracticePhase.wrong) {
      final options = QuestionOptions.of(session.current);
      var i = _digitKeys.indexOf(key);
      if (i < 0) i = _letterKeys.indexOf(key);
      if (i >= 0 && i < options.length) {
        _answer(options[i]);
        return KeyEventResult.handled;
      }
    }
    final enter =
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter;
    if (enter &&
        (phase == PracticePhase.wrong || phase == PracticePhase.solution)) {
      ref.read(practiceProvider.notifier).nextAfterWrong();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      // Every answer is already recorded, so leaving loses nothing.
      if (context.canPop()) context.pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Tabbing to a dock button and pressing it removes that button, and focus
  /// falls back to the route, above [_onKey]. Take it back after each frame.
  void _holdFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_focus.hasFocus) _focus.requestFocus();
    });
  }

  String _title() {
    if (widget.args.mode == PracticeMode.redo) return '错题重练';
    final nodeId = widget.args.nodeId;
    if (nodeId == null) return '';
    final seeds = ref.watch(seedStoreProvider).valueOrNull;
    return seeds?.nodeOrNull(nodeId)?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceProvider);
    final pending = _pending;
    final counting = session != null && session.phase != PracticePhase.finished;
    _holdFocus();
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        body: Column(
          children: [
            StudyBar.page(
              title: _title(),
              close: true,
              onPop: () => context.pop(),
              actions: [
                if (counting && !_starting)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${session.index + 1} / ${session.total}',
                      style: AppType.tabular.copyWith(fontSize: 13),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: _starting
                  ? const QuietProgress()
                  : _bootError != null
                  ? Center(child: Text(_bootError!, style: AppType.body))
                  : session == null
                  ? const Center(child: Text('还没有开始', style: AppType.meta))
                  : session.phase == PracticePhase.finished
                  ? _ResultView(session: session, onRetry: _restart)
                  : _QuestionView(
                      session: session,
                      pending: pending != null && pending.index == session.index
                          ? pending.answer
                          : null,
                      onAnswer: _answer,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionView extends ConsumerWidget {
  const _QuestionView({
    required this.session,
    required this.pending,
    required this.onAnswer,
  });

  final PracticeSession session;
  final String? pending;
  final void Function(String answer) onAnswer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = session.current;
    final practice = ref.read(practiceProvider.notifier);
    final answering = session.phase == PracticePhase.answering;
    final missed = session.phase == PracticePhase.wrong;
    final solved = session.phase == PracticePhase.solution;
    final answered = session.index + (answering ? 0 : 1);
    final progress = session.total == 0 ? 0.0 : answered / session.total;
    final options = QuestionOptions.of(q);
    final moreHints = session.hintsShown < q.hints.length;

    _Mark markOf(String option) {
      if (answering) {
        if (pending == null) return _Mark.idle;
        if (option != pending) return _Mark.dim;
        return q.check(option) ? _Mark.right : _Mark.wrong;
      }
      if (session.tried.contains(option)) return _Mark.wrong;
      if (solved) return q.check(option) ? _Mark.right : _Mark.dim;
      return _Mark.idle;
    }

    final open = (answering && pending == null) || missed;
    final choices = _Choices(
      question: q,
      all: options,
      visible: solved
          ? [
              for (final o in options)
                if (markOf(o) != _Mark.dim) o,
            ]
          : options,
      markOf: markOf,
      onAnswer: open ? onAnswer : null,
    );

    return Column(
      children: [
        _Progress(value: progress),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.page,
              AppSpace.lg,
              AppSpace.page,
              AppSpace.lg,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpace.column - 2 * AppSpace.page,
                ),
                // Fill the column so a short stem starts on the same
                // edge as the options instead of centering.
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Arrive(
                        key: ValueKey(session.index),
                        child: MathText(
                          q.stem,
                          style: AppType.title.copyWith(
                            height: 1.55,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (q.figure != null) ...[
                        const SizedBox(height: AppSpace.lg),
                        MathFigureView(figure: q.figure!),
                      ],
                      if (missed) ...[
                        const SizedBox(height: AppSpace.lg),
                        const _Verdict(
                          icon: Icons.close,
                          color: AppColors.danger,
                          text: '不对。看看提示，再选一次。',
                        ),
                        if (session.hintsShown > 0) ...[
                          const SizedBox(height: AppSpace.lg),
                          StudySection.lines(
                            label: '提示',
                            lines: q.hints.take(session.hintsShown).toList(),
                            color: AppColors.muted,
                          ),
                        ],
                      ],
                      if (solved) ...[
                        const SizedBox(height: AppSpace.lg),
                        if (session.recovered) ...[
                          const _Verdict(
                            icon: Icons.check,
                            color: AppColors.mastered,
                            text: '这次对了。对照解析，把思路走一遍。',
                          ),
                          const SizedBox(height: AppSpace.lg),
                        ],
                        StudySection.lines(
                          label: '解析',
                          lines: q.steps,
                          tick: AppColors.mastered,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        StudyDock(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.page - _optionInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Arrive(
                key: ValueKey(session.index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _optionInset),
                  child: choices,
                ),
              ),
              if (!answering)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _optionInset - 8,
                    AppSpace.xs,
                    _optionInset,
                    0,
                  ),
                  child: Row(
                    children: [
                      if (missed) ...[
                        if (moreHints)
                          TextButton(
                            onPressed: practice.moreHint,
                            child: const Text('再给提示'),
                          ),
                        TextButton(
                          onPressed: practice.showSolution,
                          child: const Text('看解析'),
                        ),
                      ],
                      const Spacer(),
                      // While a retry is open, moving on is the quiet choice.
                      if (missed)
                        TextButton(
                          onPressed: practice.nextAfterWrong,
                          child: Text(session.isLast ? '结束' : '跳过'),
                        )
                      else
                        FilledButton(
                          onPressed: practice.nextAfterWrong,
                          child: Text(session.isLast ? '看结果' : '下一题'),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A thin run of accent along the bar's bottom edge, easing as questions pass.
class _Progress extends StatelessWidget {
  const _Progress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: reduce ? Duration.zero : const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => LinearProgressIndicator(
        value: v,
        minHeight: 2,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

/// Fades a new question in with a short rise. Key it by question index.
class _Arrive extends StatelessWidget {
  const _Arrive({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 6),
          child: child,
        ),
      ),
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppType.body)),
        ],
      ),
    );
  }
}

/// The dock pads this much less than the page so text-button labels land on
/// the column edge; the option frames pad it back.
const _optionInset = 12.0;

const _optionGap = 8.0;

class _Choices extends StatelessWidget {
  const _Choices({
    required this.question,
    required this.all,
    required this.visible,
    required this.markOf,
    required this.onAnswer,
  });

  final GeneratedQuestion question;
  final List<String> all;
  final List<String> visible;
  final _Mark Function(String option) markOf;
  final void Function(String answer)? onAnswer;

  @override
  Widget build(BuildContext context) {
    VoidCallback? tapOf(String option) {
      final answer = onAnswer;
      if (answer == null || markOf(option) == _Mark.wrong) return null;
      return () => answer(option);
    }

    if (question.kind == QuestionKind.judge) {
      return Row(
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) const SizedBox(width: _optionGap),
            Expanded(
              child: _JudgeHit(
                label: visible[i],
                mark: markOf(visible[i]),
                onTap: tapOf(visible[i]),
              ),
            ),
          ],
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < visible.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : _optionGap),
            child: _OptionHit(
              letter: String.fromCharCode(65 + all.indexOf(visible[i])),
              label: visible[i],
              mark: markOf(visible[i]),
              onTap: tapOf(visible[i]),
            ),
          ),
      ],
    );
  }
}

Color? _markColor(_Mark mark) => switch (mark) {
  _Mark.right => AppColors.mastered,
  _Mark.wrong => AppColors.danger,
  _Mark.dim => AppColors.locked,
  _Mark.idle => null,
};

// Icons, not ✓/✗ characters: those need a symbol font that web fetches late.
IconData? _markIcon(_Mark mark) => switch (mark) {
  _Mark.right => Icons.check,
  _Mark.wrong => Icons.close,
  _ => null,
};

class _JudgeHit extends StatelessWidget {
  const _JudgeHit({required this.label, required this.mark, this.onTap});

  final String label;
  final _Mark mark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _markColor(mark) ?? AppColors.text;
    final icon = _markIcon(mark);
    return _OptionFrame(
      mark: mark,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppType.title.copyWith(
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionHit extends StatelessWidget {
  const _OptionHit({
    required this.letter,
    required this.label,
    required this.mark,
    this.onTap,
  });

  final String letter;
  final String label;
  final _Mark mark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _markColor(mark);
    final icon = _markIcon(mark);
    return _OptionFrame(
      mark: mark,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 28,
            child: icon == null
                ? Text(
                    letter,
                    style: AppType.meta.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      color: color ?? AppColors.muted,
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(icon, size: 14, color: color),
                  ),
          ),
          Expanded(child: AnswerText(label, color: color ?? AppColors.text)),
        ],
      ),
    );
  }
}

/// Hairline frame around one choice. The edge firms up on hover or focus and
/// takes the verdict colour once the choice is marked.
class _OptionFrame extends StatefulWidget {
  const _OptionFrame({
    required this.mark,
    required this.onTap,
    required this.padding,
    required this.child,
  });

  final _Mark mark;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Widget child;

  @override
  State<_OptionFrame> createState() => _OptionFrameState();
}

class _OptionFrameState extends State<_OptionFrame> {
  var _hot = false;

  @override
  Widget build(BuildContext context) {
    final edge = switch (widget.mark) {
      _Mark.right => AppColors.mastered.withValues(alpha: 0.7),
      _Mark.wrong => AppColors.danger.withValues(alpha: 0.7),
      _ when _hot && widget.onTap != null => AppColors.lineStrong,
      _ => AppColors.line,
    };
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 120),
      decoration: BoxDecoration(border: Border.all(color: edge)),
      child: QuietTap(
        onTap: widget.onTap,
        onHighlight: (on) {
          if (on != _hot) setState(() => _hot = on);
        },
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}

class _ResultView extends ConsumerWidget {
  const _ResultView({required this.session, required this.onRetry});

  final PracticeSession session;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correct = session.correctCount;
    final mode = session.args.mode;
    final challenge = mode == PracticeMode.challenge;
    final passed = MasteryRules.challengePassed(
      correct: correct,
      total: session.total,
    );
    final misses = session.results.where((r) => !r).length;
    final nodeId = session.args.nodeId;
    final view = nodeId == null
        ? null
        : ref.watch(nodeViewProvider(nodeId)).valueOrNull;
    final node = nodeId == null ? null : view?.graph.nodeOrNull(nodeId);
    // After a pass the recommendation has already moved past this node.
    final next = challenge && passed ? view?.recommended() : null;
    final (note, noteColor) = switch (mode) {
      PracticeMode.challenge when passed => (
        node == null ? '过关，已掌握' : '过关，已掌握「${node.title}」',
        AppColors.mastered,
      ),
      PracticeMode.challenge => (
        '还差 ${max(1, MasteryRules.passCount - correct)} 题过关。'
            '做错的题已收进错题本。',
        AppColors.text,
      ),
      PracticeMode.redo => (
        correct > 0 ? '$correct 道错题已消化' : '这几道还要再看看',
        AppColors.text,
      ),
      _ => (
        '正确率 ${session.total == 0 ? 0 : (correct * 100 / session.total).round()}%'
            ' · 这一组不计入掌握',
        AppColors.text,
      ),
    };
    final redo = mode == PracticeMode.redo;

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpace.column),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.page),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$correct',
                          style: AppType.display.copyWith(
                            letterSpacing: 1,
                            fontSize: 56,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '/ ${session.total}',
                          style: AppType.meta.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.sm),
                    _ResultStrip(results: session.results),
                    const SizedBox(height: AppSpace.md),
                    Text(note, style: AppType.body.copyWith(color: noteColor)),
                    if (misses > 0 && challenge && !passed) ...[
                      const SizedBox(height: AppSpace.xs),
                      const Text('回知识卡把易错点再读一遍，再来。', style: AppType.meta),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        StudyDock(
          child: Row(
            children: [
              if (challenge && !passed) ...[
                FilledButton(onPressed: onRetry, child: const Text('再闯一次')),
                const SizedBox(width: AppSpace.xs),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('回知识卡'),
                ),
              ] else if (challenge && next != null && next.id != nodeId) ...[
                Flexible(
                  child: FilledButton(
                    onPressed: () => context.go('/card/${next.id}'),
                    child: Text(
                      '下一节：${next.title}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.xs),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('回树'),
                ),
              ] else if (redo)
                FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('回错题本'),
                )
              else if (mode == PracticeMode.special) ...[
                FilledButton(onPressed: onRetry, child: const Text('再练一组')),
                const SizedBox(width: AppSpace.xs),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('回知识卡'),
                ),
              ] else
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('回树'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One short bar per question, in order: green first-try, red miss.
class _ResultStrip extends StatelessWidget {
  const _ResultStrip({required this.results});

  final List<bool> results;

  @override
  Widget build(BuildContext context) {
    final right = results.where((r) => r).length;
    return Semantics(
      label: '对 $right 题，错 ${results.length - right} 题',
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (final r in results)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ColoredBox(
                  color: r ? AppColors.mastered : AppColors.danger,
                  child: const SizedBox(width: 22, height: 3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
