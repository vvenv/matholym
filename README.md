# 奥数之林

竞赛数学训练壳：每块知识面是一棵树。第一期只种**数论**（知识图谱、参数化专项/闯关、错题本）；代数、组合、几何按同样结构往后铺。Flutter 本地优先，数据存在本机 SQLite。

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js
flutter test
flutter run -d macos
flutter run -d chrome
```

Web 需要 `web/sqlite3.wasm`（与 `sqlite3` 2.9.x 匹配）和 `web/drift_worker.js`。若 wasm 打开失败，会在约 8 秒后回退到内存库。桌面端用本机 SQLite，最稳。
