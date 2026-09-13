import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../theme/app_theme.dart';

const _closers = '，。、；：！？）」』》〉”’,.;:!?)]';
const _openers = '（「『《〈“‘([';

/// A raw answer string (`12`, `2^3*3`, `4,1`). Powers and products go
/// through TeX so `2^3*3` reads as 2³ × 3; plain answers stay plain text.
class AnswerText extends StatelessWidget {
  const AnswerText(this.answer, {super.key, this.style, this.color});

  final String answer;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (RegExp(r'[\^\\*]').hasMatch(answer)) {
      final tex = answer.replaceAll('*', r' \times ');
      return MathText('\$$tex\$', style: style, color: color);
    }
    return Text(answer, style: (style ?? AppType.body).copyWith(color: color));
  }
}

/// Mixed Chinese + TeX. Inline `$a \mid b$`, display `$$a \equiv b \pmod m$$`.
/// Engine is KaTeX-compatible (flutter_math_fork), not full LaTeX.
class MathText extends StatelessWidget {
  const MathText(
    this.text, {
    super.key,
    this.style,
    this.color,
  });

  final String text;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = (style ?? AppType.body).copyWith(color: color ?? style?.color);
    final parts = splitMath(text);
    final blocks = <Widget>[];
    var inline = <({bool math, bool display, String tex})>[];

    void flushInline() {
      if (inline.isEmpty) return;
      // A math span is an opaque placeholder to the line breaker, so a
      // trailing "，" can wrap onto its own line. Glue adjacent punctuation
      // into the same widget.
      final texts = [for (final part in inline) part.tex];
      final lead = List.filled(inline.length, '');
      final trail = List.filled(inline.length, '');
      for (var i = 0; i < inline.length; i++) {
        if (!inline[i].math) continue;
        if (i > 0 && !inline[i - 1].math) {
          final t = texts[i - 1];
          var k = t.length;
          while (k > 0 && _openers.contains(t[k - 1])) {
            k--;
          }
          lead[i] = t.substring(k);
          texts[i - 1] = t.substring(0, k);
        }
        if (i + 1 < inline.length && !inline[i + 1].math) {
          final t = texts[i + 1];
          var k = 0;
          while (k < t.length && _closers.contains(t[k])) {
            k++;
          }
          trail[i] = t.substring(0, k);
          texts[i + 1] = t.substring(k);
        }
      }

      Widget mathOf(int i) {
        final tex = inline[i].tex;
        final math = Math.tex(
          tex,
          mathStyle: MathStyle.text,
          textStyle: base,
          onErrorFallback: (_) => Text(
            tex,
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
        if (lead[i].isEmpty && trail[i].isEmpty) return math;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (lead[i].isNotEmpty) Text(lead[i], style: base),
            math,
            if (trail[i].isNotEmpty) Text(trail[i], style: base),
          ],
        );
      }

      blocks.add(
        Text.rich(
          // The widget style sets the line metrics. Without it a math-only
          // line takes DefaultTextStyle's and stands taller than its text.
          style: base,
          TextSpan(
            children: [
              for (var i = 0; i < inline.length; i++)
                if (inline[i].math)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: mathOf(i),
                  )
                else if (texts[i].isNotEmpty)
                  TextSpan(text: texts[i], style: base),
            ],
          ),
        ),
      );
      inline = [];
    }

    for (final part in parts) {
      if (part.math && part.display) {
        flushInline();
        blocks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Math.tex(
              part.tex,
              mathStyle: MathStyle.display,
              textStyle: base,
              onErrorFallback: (_) => Text(
                part.tex,
                style: base.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        );
      } else {
        inline.add(part);
      }
    }
    flushInline();

    if (blocks.length == 1) return blocks.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }

  static List<({bool math, bool display, String tex})> splitMath(String raw) {
    final out = <({bool math, bool display, String tex})>[];
    final re = RegExp(r'\$\$([\s\S]+?)\$\$|\$([^\$]+)\$');
    var cursor = 0;
    for (final match in re.allMatches(raw)) {
      if (match.start > cursor) {
        out.add((math: false, display: false, tex: raw.substring(cursor, match.start)));
      }
      final display = match.group(1);
      if (display != null) {
        out.add((math: true, display: true, tex: display.trim()));
      } else {
        out.add((math: true, display: false, tex: match.group(2)!));
      }
      cursor = match.end;
    }
    if (cursor < raw.length) {
      out.add((math: false, display: false, tex: raw.substring(cursor)));
    }
    if (out.isEmpty) {
      out.add((math: false, display: false, tex: raw));
    }
    return out;
  }
}
