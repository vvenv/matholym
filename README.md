# 奥数之林

竞赛数学训练壳：每块知识面是一棵树。已开放小学到初中的六块：**计算**、**代数**、**几何**、**数论**、**组合**、**逻辑**（约 204 个练习节点；几何、数表、坐标系等知识点带示意图）。Flutter 本地优先，数据存在本机 SQLite。

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js
flutter test
flutter run -d macos
flutter run -d chrome
```

## 一节课怎么走

树上点开一节 → 知识卡 → **闯关**（5 题，对 4 题算掌握）或 **先练一组**（5 题，不计入掌握；掌握之后这个按钮变成 **加练**，往上一个难度走）。做错的题进错题本，重练做对就移出；错题里的「复习」会把树切到那道题所属的知识面。

一组题里不会出现同一道题：每个空位先挑这轮没用过的模板，再按题干去重（`lib/domain/generators/question.dart` 的 `runForNode`）。`test/variety_test.dart` 守住这条——每个节点都要能凑出 5 道互不相同的题。

Web 需要 `web/sqlite3.wasm`（与 `sqlite3` 2.9.x 匹配）和 `web/drift_worker.js`。若 wasm 打开失败，会在约 8 秒后回退到内存库。桌面端用本机 SQLite，最稳。

## 题目正确性

题干、选项、解答步骤都由 414 个模板按种子生成，所以正确性靠扫全量来守，而不是靠抽查：

- `test/arithmetic_test.dart` 把每道题印出的每个 `$…$` 算式当成断言：会解析成精确有理数并核对等号两边。看不懂的式子（含变量、同余、组合数）跳过，所以报出来的一定是错式。
- `test/choices_test.dart` 扫全部选项：四个互不相同、同一形状、分数必约简、质因数分解按质数升序，且答案有取值范围时（余数 < 模数、一位数字、角度 < 180）选项不会越界。
- `test/wording_test.dart` 扫写法：TeX 命令不许漏到 `$` 外面、中文之间不留空格、不出现 `1x` 这种系数、比不留未约简的 `2:4`、答案不许与种子无关（少数「立方体有几个面」式的常量答案在白名单里）。
- `lib/domain/` 的助手函数用 `assert` 声明除法必须整除（面积、浓度、工程天数、加权平均…）。`flutter test` 开着 assert，所以谁把参数抽成 11.11% 会当场失败，而不是把四舍五入后的答案当标准答案。
- `test/variety_test.dart` 扫每个节点的出题量：闯关的 5 个空位必须各不相同，题目太薄的节点会当场报出来。
- `dart run tool/audit_questions.dart` 一次扫 12408 道题，打印机械缺陷汇总；`--dump`（或 `--dump=路径`）把全部题目写到 `build/questions.txt` 供人工过目。
