import 'area.dart';

export 'area.dart';

enum KnowledgeLevel {
  l1,
  l2,
  l3,
  l4,
  l5,
  l6;

  String get label => switch (this) {
    KnowledgeLevel.l1 => 'L1 基础',
    KnowledgeLevel.l2 => 'L2 质合',
    KnowledgeLevel.l3 => 'L3 公约公倍',
    KnowledgeLevel.l4 => 'L4 同余',
    KnowledgeLevel.l5 => 'L5 高阶定理',
    KnowledgeLevel.l6 => 'L6 进阶专题',
  };

  String get shortLabel => name.toUpperCase().replaceFirst('L', 'L');

  static KnowledgeLevel fromJson(String raw) {
    final match = RegExp(r'l\s*([1-6])', caseSensitive: false).firstMatch(raw);
    if (match != null) {
      return KnowledgeLevel.values[int.parse(match.group(1)!) - 1];
    }
    return KnowledgeLevel.l1;
  }
}

enum NodeStatus { locked, learning, mastered }

class KnowledgeNode {
  const KnowledgeNode({
    required this.id,
    required this.title,
    required this.level,
    required this.prerequisites,
    required this.practiceReady,
    this.subtitle = '',
  });

  final String id;
  final String title;
  final KnowledgeLevel level;
  final List<String> prerequisites;
  final bool practiceReady;
  final String subtitle;

  factory KnowledgeNode.fromJson(Map<String, dynamic> json) {
    return KnowledgeNode(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      level: KnowledgeLevel.fromJson(json['level'] as String),
      prerequisites: (json['prerequisites'] as List<dynamic>? ?? const [])
          .cast<String>(),
      practiceReady: json['practiceReady'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'level': 'L${level.name.substring(1)}',
    'prerequisites': prerequisites,
    'practiceReady': practiceReady,
  };
}

class KnowledgeCard {
  const KnowledgeCard({
    required this.nodeId,
    required this.definition,
    required this.theorems,
    required this.examples,
    required this.commonMistakes,
  });

  final String nodeId;
  final String definition;
  final List<String> theorems;
  final List<String> examples;
  final List<String> commonMistakes;

  factory KnowledgeCard.fromJson(Map<String, dynamic> json) {
    return KnowledgeCard(
      nodeId: json['nodeId'] as String? ?? json['id'] as String,
      definition: json['definition'] as String? ?? '',
      theorems: (json['theorems'] as List<dynamic>? ?? const []).cast<String>(),
      examples: (json['examples'] as List<dynamic>? ?? const []).cast<String>(),
      commonMistakes: (json['commonMistakes'] as List<dynamic>? ?? const [])
          .cast<String>(),
    );
  }
}

class KnowledgeGraph {
  const KnowledgeGraph({
    required this.rootId,
    required this.nodes,
    this.area = KnowledgeArea.numberTheory,
  });

  final KnowledgeArea area;
  final String rootId;
  final List<KnowledgeNode> nodes;

  KnowledgeNode nodeById(String id) => nodes.firstWhere((n) => n.id == id);

  List<KnowledgeNode> dependentsOf(String id) =>
      nodes.where((n) => n.prerequisites.contains(id)).toList();

  List<KnowledgeNode> byLevel(KnowledgeLevel level) =>
      nodes.where((n) => n.level == level).toList();

  factory KnowledgeGraph.fromJson(Map<String, dynamic> json) {
    return KnowledgeGraph(
      area: KnowledgeArea.byId(json['areaId'] as String? ?? KnowledgeArea.numberTheoryId),
      rootId: json['rootId'] as String,
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => KnowledgeNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

enum StudentStage {
  primary,
  junior,
  senior;

  String get label => switch (this) {
    StudentStage.primary => '小学高年级',
    StudentStage.junior => '初中',
    StudentStage.senior => '高中',
  };

  static StudentStage parse(String raw) => StudentStage.values.firstWhere(
    (e) => e.name == raw,
    orElse: () => StudentStage.junior,
  );
}
