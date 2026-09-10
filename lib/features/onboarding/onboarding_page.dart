import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/info_tip.dart';
import '../../domain/knowledge/models.dart';
import '../../providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _name = TextEditingController();
  StudentStage _stage = StudentStage.junior;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nickname = _name.text.trim();
    if (nickname.isEmpty) {
      setState(() => _error = '请填写昵称');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = await ref.read(repositoryProvider.future);
      await repo.createProfile(nickname: nickname, stage: _stage);
      ref.invalidate(profileProvider);
      ref.invalidate(graphViewProvider);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _error = '创建档案失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      const Text(
                        '数论之树',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const InfoTip('本机档案，无需网络。先选学段，再从整除定义开始往上长。'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _name,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: '昵称',
                      hintText: '你希望怎么称呼',
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 20),
                  const Text('学段', style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 8),
                  SegmentedButton<StudentStage>(
                    segments: [
                      for (final stage in StudentStage.values)
                        ButtonSegment(value: stage, label: Text(stage.label)),
                    ],
                    selected: {_stage},
                    onSelectionChanged: (s) => setState(() => _stage = s.first),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(_error!, style: const TextStyle(color: AppColors.danger)),
                  ],
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: Text(_busy ? '创建中…' : '开始训练'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () {
                            _name.text = '同学';
                            _submit();
                          },
                    child: const Text('用「同学」快速开始'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
