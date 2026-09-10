import 'number_theory.dart';

enum ErrorCause {
  calculation,
  concept,
  theorem,
  method;

  String get label => switch (this) {
    ErrorCause.calculation => '计算错误',
    ErrorCause.concept => '概念不清',
    ErrorCause.theorem => '定理误用',
    ErrorCause.method => '方法不当',
  };

  static ErrorCause parse(String raw) => ErrorCause.values.firstWhere(
    (e) => e.name == raw,
    orElse: () => ErrorCause.concept,
  );
}

class AttributionInput {
  const AttributionInput({
    required this.nodeId,
    required this.prerequisites,
    required this.correctAnswer,
    required this.userAnswer,
    required this.nodeAccuracy,
    required this.prereqAccuracy,
    this.userCause,
  });

  final String nodeId;
  final List<String> prerequisites;
  final String correctAnswer;
  final String userAnswer;
  final double nodeAccuracy;
  final Map<String, double> prereqAccuracy;
  final ErrorCause? userCause;
}

class AttributionResult {
  const AttributionResult({
    required this.cause,
    required this.attributedNodeId,
  });

  final ErrorCause cause;
  final String attributedNodeId;
}

class WrongBookRules {
  const WrongBookRules._();

  static AttributionResult attribute(AttributionInput input) {
    final cause = input.userCause ?? _inferCause(input);
    var target = input.nodeId;
    if (cause == ErrorCause.concept || cause == ErrorCause.theorem) {
      final weak = _weakestPrereq(input);
      if (weak != null) target = weak;
    }
    return AttributionResult(cause: cause, attributedNodeId: target);
  }

  static ErrorCause _inferCause(AttributionInput input) {
    if (NumberTheory.numericallyClose(input.correctAnswer, input.userAnswer)) {
      return ErrorCause.calculation;
    }
    final weak = _weakestPrereq(input);
    if (weak != null && (input.prereqAccuracy[weak] ?? 1) < 0.6) {
      return ErrorCause.concept;
    }
    if (input.nodeAccuracy < 0.5) return ErrorCause.method;
    return ErrorCause.concept;
  }

  static String? _weakestPrereq(AttributionInput input) {
    String? weakest;
    var lowest = input.nodeAccuracy;
    for (final id in input.prerequisites) {
      final acc = input.prereqAccuracy[id] ?? 1;
      if (acc < lowest) {
        lowest = acc;
        weakest = id;
      }
    }
    return weakest;
  }
}
