class KnowledgeArea {
  const KnowledgeArea({
    required this.id,
    required this.title,
    required this.treeTitle,
    required this.blurb,
    this.available = false,
  });

  final String id;
  final String title;
  final String treeTitle;
  final String blurb;
  final bool available;

  static const numberTheoryId = 'number_theory';

  static const numberTheory = KnowledgeArea(
    id: numberTheoryId,
    title: '数论',
    treeTitle: '数论之树',
    blurb: '整除、质合、同余与高阶定理',
    available: true,
  );

  static const algebra = KnowledgeArea(
    id: 'algebra',
    title: '代数',
    treeTitle: '代数之树',
    blurb: '方程、不等式与多项式',
  );

  static const combinatorics = KnowledgeArea(
    id: 'combinatorics',
    title: '组合',
    treeTitle: '组合之树',
    blurb: '计数、图论与存在性',
  );

  static const geometry = KnowledgeArea(
    id: 'geometry',
    title: '几何',
    treeTitle: '几何之树',
    blurb: '平面几何与三角',
  );

  static const planned = [numberTheory, algebra, combinatorics, geometry];

  static KnowledgeArea byId(String id) => planned.firstWhere(
    (area) => area.id == id,
    orElse: () => numberTheory,
  );
}
