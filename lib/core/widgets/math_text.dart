import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../theme/app_theme.dart';

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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      runSpacing: 8,
      children: [
        for (final part in parts)
          if (part.math)
            Math.tex(
              part.tex,
              mathStyle: part.display ? MathStyle.display : MathStyle.text,
              textStyle: base,
              onErrorFallback: (_) => Text(
                part.tex,
                style: base.copyWith(fontStyle: FontStyle.italic),
              ),
            )
          else
            Text(part.tex, style: base),
      ],
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
