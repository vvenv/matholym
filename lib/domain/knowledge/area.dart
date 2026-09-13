class KnowledgeArea {
  const KnowledgeArea({
    required this.id,
    required this.title,
    required this.treeTitle,
    required this.blurb,
    this.available = false,
    this.levelNames = const ['基础', '进阶', '提高', '综合', '专题', '竞赛'],
  });

  final String id;
  final String title;
  final String treeTitle;
  final String blurb;
  final bool available;
  final List<String> levelNames;

  String levelLabel(int index) {
    final name = index >= 0 && index < levelNames.length
        ? levelNames[index]
        : '';
    return name.isEmpty ? 'L${index + 1}' : 'L${index + 1} $name';
  }

  static const calculationId = 'calculation';
  static const numberTheoryId = 'number_theory';
  static const algebraId = 'algebra';
  static const combinatoricsId = 'combinatorics';
  static const geometryId = 'geometry';
  static const logicId = 'logic';

  static const calculation = KnowledgeArea(
    id: calculationId,
    title: '计算',
    treeTitle: '计算之树',
    blurb: '速算、分数与新运算',
    available: true,
    levelNames: ['巧算入门', '分数小数', '新运算', '繁分估算', '竞赛计算', '进阶专题'],
  );

  static const numberTheory = KnowledgeArea(
    id: numberTheoryId,
    title: '数论',
    treeTitle: '数论之树',
    blurb: '整除、质合、同余与高阶定理',
    available: true,
    levelNames: ['基础', '质合', '公约公倍', '同余', '高阶定理', '进阶专题'],
  );

  static const algebra = KnowledgeArea(
    id: algebraId,
    title: '代数',
    treeTitle: '代数之树',
    blurb: '方程、应用题与式',
    available: true,
    levelNames: ['方程应用', '比例行程', '式与数列', '二次与函数', '多项式', '进阶专题'],
  );

  static const combinatorics = KnowledgeArea(
    id: combinatoricsId,
    title: '组合',
    treeTitle: '组合之树',
    blurb: '计数、排列组合与存在性',
    available: true,
    levelNames: ['计数入门', '排列组合', '常用模型', '存在性', '图与递推', '进阶专题'],
  );

  static const geometry = KnowledgeArea(
    id: geometryId,
    title: '几何',
    treeTitle: '几何之树',
    blurb: '度量、面积与三角形',
    available: true,
    levelNames: ['度量入门', '面积周长', '直线三角形', '勾股相似', '立体', '进阶专题'],
  );

  static const logic = KnowledgeArea(
    id: logicId,
    title: '逻辑',
    treeTitle: '逻辑之树',
    blurb: '奇偶、真假与推理',
    available: true,
    levelNames: ['判断入门', '还原最值', '天平日历', '不变性', '博弈', '进阶专题'],
  );

  static const planned = [
    calculation,
    algebra,
    geometry,
    numberTheory,
    combinatorics,
    logic,
  ];

  static KnowledgeArea byId(String id) =>
      planned.firstWhere((area) => area.id == id, orElse: () => numberTheory);
}
