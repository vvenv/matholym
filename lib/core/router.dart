import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/generators/question.dart';
import '../features/card/card_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/practice/practice_controller.dart';
import '../features/practice/practice_page.dart';
import '../features/shell/app_shell.dart';
import '../features/wrongbook/wrongbook_page.dart';
import '../providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(profileProvider, (previous, next) {
    refresh.value++;
  });
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final profile = ref.read(profileProvider);
      if (profile.isLoading) return null;
      final hasProfile = profile.asData?.value != null;
      final onboarding = state.uri.path == '/onboarding';
      if (!hasProfile && !onboarding) return '/onboarding';
      if (hasProfile && onboarding) return '/';
      if (state.uri.path == '/tree') return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      // Nested so `go` to any page keeps the tree underneath for back.
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(),
        routes: [
          GoRoute(
            path: 'wrongbook',
            builder: (context, state) => const WrongBookPage(),
          ),
          GoRoute(
            path: 'card/:nodeId',
            builder: (context, state) => CardPage(
              nodeId: state.pathParameters['nodeId']!,
            ),
          ),
          GoRoute(
            path: 'practice',
            builder: (context, state) {
              final params = state.uri.queryParameters;
              final mode = PracticeMode.values.firstWhere(
                (e) => e.name == params['mode'],
                orElse: () => PracticeMode.special,
              );
              return PracticePage(
                args: PracticeArgs(
                  mode: mode,
                  nodeId: params['nodeId'],
                  difficulty: params['difficulty'] == null
                      ? null
                      : Difficulty.parse(params['difficulty']!),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
});
