import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/branding.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/knowledge/models.dart';
import '../../providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _name = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final nickname = _name.text.trim().isEmpty ? '同学' : _name.text.trim();
      final repo = await ref.read(repositoryProvider.future);
      await repo.createProfile(nickname: nickname, stage: StudentStage.junior);
      ref.invalidate(profileProvider);
      ref.invalidate(graphViewProvider);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _error = '$e');
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
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 3),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ColoredBox(
                      color: AppColors.accent,
                      child: SizedBox(width: 28, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: AppSpace.md),
                  const Text(Brand.appName, style: AppType.display),
                  const SizedBox(height: AppSpace.sm),
                  const Text('竞赛数学知识林', style: AppType.meta),
                  const SizedBox(height: AppSpace.xl),
                  TextField(
                    controller: _name,
                    textInputAction: TextInputAction.done,
                    style: AppType.body,
                    cursorColor: AppColors.accent,
                    decoration: const InputDecoration(labelText: '昵称'),
                    onSubmitted: (_) => _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: AppColors.danger,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpace.lg),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: Text(_busy ? '…' : '开始'),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
