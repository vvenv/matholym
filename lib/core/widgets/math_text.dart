import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

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
    final base =
        (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(color: color);
    final parts = _split(text);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      runSpacing: 6,
      children: [
        for (final part in parts)
          if (part.$1)
            Math.tex(
              part.$2,
              mathStyle: MathStyle.text,
              textStyle: base,
              onErrorFallback: (_) => Text(
                part.$2,
                style: base?.copyWith(fontStyle: FontStyle.italic),
              ),
            )
          else
            Text(part.$2, style: base),
      ],
    );
  }

  static List<(bool, String)> _split(String raw) {
    final out = <(bool, String)>[];
    final re = RegExp(r'\$([^\$]+)\$');
    var cursor = 0;
    for (final match in re.allMatches(raw)) {
      if (match.start > cursor) {
        out.add((false, raw.substring(cursor, match.start)));
      }
      out.add((true, match.group(1)!));
      cursor = match.end;
    }
    if (cursor < raw.length) {
      out.add((false, raw.substring(cursor)));
    }
    if (out.isEmpty) {
      out.add((false, raw));
    }
    return out;
  }
}
