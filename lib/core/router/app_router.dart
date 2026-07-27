import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import 'auth_state_stub.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final _consumerHomeBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'consumerHome',
);
final _consumerRequestBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'consumerRequest',
);
final _consumerBanksBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'consumerBanks',
);
final _consumerDonorsBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'consumerDonors',
);
final _consumerProfileBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'consumerProfile',
);

final _adminPartnersBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminPartners',
);
final _adminStockBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminStock',
);
final _adminCarouselBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminCarousel',
);
final _adminEducationBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminEducation',
);
final _adminModerationBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminModeration',
);

/// Route names and paths for every screen in `docs/SPEC.md`. Screens should
/// navigate via `context.goNamed(AppRoute.xName, ...)` rather than hardcoding
/// path strings.
abstract final class AppRoute {
  static const String rootPath = '/';

  // Auth / onboarding — root navigator, no shell.
  static const String onboardingName = 'onboarding';
  static const String onboardingPath = '/onboarding';

  static const String signUpName = 'signUp';
  static const String signUpPath = '/sign-up';

  static const String signInName = 'signIn';
  static const String signInPath = '/sign-in';

  static const String donorProfileSetupName = 'donorProfileSetup';
  static const String donorProfileSetupPath = '/donor-profile-setup';

  // Consumer shell tabs — bottom nav: Home, Request, Banks, Donors, Profile.
  static const String homeName = 'home';
  static const String homePath = '/home';

  static const String requestName = 'request';
  static const String requestPath = '/request';

  static const String requestResultsName = 'requestResults';
  static const String requestResultsPath = '/request/results/:requestId';

  static const String requestStatusName = 'requestStatus';
  static const String requestStatusPath = '/request/status/:requestId';

  static const String banksName = 'banks';
  static const String banksPath = '/banks';

  static const String bankProfileName = 'bankProfile';
  static const String bankProfilePath = '/banks/:bankId';

  static const String donorsName = 'donors';
  static const String donorsPath = '/donors';

  static const String profileName = 'profile';
  static const String profilePath = '/profile';

  // Root-navigator screens reachable from within the consumer shell (nav bar hidden).
  static const String notificationsName = 'notifications';
  static const String notificationsPath = '/notifications';

  static const String educationHubName = 'educationHub';
  static const String educationHubPath = '/education';

  static const String educationArticleName = 'educationArticle';
  static const String educationArticlePath = '/education/:articleId';

  static const String donationHistoryName = 'donationHistory';
  static const String donationHistoryPath = '/profile/donation-history';

  static const String badgesName = 'badges';
  static const String badgesPath = '/profile/badges';

  static const String settingsName = 'settings';
  static const String settingsPath = '/profile/settings';

  static const String helpSupportName = 'helpSupport';
  static const String helpSupportPath = '/profile/help';

  static const String bannerViewerName = 'bannerViewer';
  static const String bannerViewerPath = '/banner-viewer/:itemId';

  // Admin shell tabs — own nav shell, never merged into the consumer bottom nav.
  static const String adminPartnersName = 'adminPartners';
  static const String adminPartnersPath = '/admin/partners';

  static const String adminPartnerNewName = 'adminPartnerNew';
  static const String adminPartnerEditName = 'adminPartnerEdit';

  static const String adminStockName = 'adminStock';
  static const String adminStockPath = '/admin/stock';

  static const String adminCarouselName = 'adminCarousel';
  static const String adminCarouselPath = '/admin/carousel';

  static const String adminCarouselNewName = 'adminCarouselNew';

  static const String adminEducationName = 'adminEducation';
  static const String adminEducationPath = '/admin/education';

  static const String adminEducationNewName = 'adminEducationNew';
  static const String adminEducationEditName = 'adminEducationEdit';

  static const String adminModerationName = 'adminModeration';
  static const String adminModerationPath = '/admin/moderation';

  /// Reachable without being signed in.
  static const Set<String> _publicPaths = {
    onboardingPath,
    signInPath,
    signUpPath,
  };

  /// Signed-in users get bounced away from these (e.g. landing back on sign-in).
  static const Set<String> _postAuthEntryPaths = {
    onboardingPath,
    signInPath,
    signUpPath,
  };

  static bool isPublic(String path) => _publicPaths.contains(path);
  static bool isPostAuthEntry(String path) =>
      _postAuthEntryPaths.contains(path);
  static bool isAdminPath(String path) => path.startsWith('/admin');
}

class _RouterRefreshListenable extends ChangeNotifier {
  _RouterRefreshListenable(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}

String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authStateProvider);
  final path = state.matchedLocation;

  if (path == AppRoute.rootPath) {
    if (!auth.isSignedIn) return AppRoute.onboardingPath;
    return auth.isAdmin ? AppRoute.adminPartnersPath : AppRoute.homePath;
  }

  if (!auth.isSignedIn) {
    return AppRoute.isPublic(path) ? null : AppRoute.signInPath;
  }

  if (AppRoute.isPostAuthEntry(path)) {
    return auth.isAdmin ? AppRoute.adminPartnersPath : AppRoute.homePath;
  }

  if (AppRoute.isAdminPath(path) && !auth.isAdmin) {
    return AppRoute.homePath;
  }

  return null;
}

/// Placeholder for every screen not yet built. Swapped out screen-by-screen
/// as `prompts/phase-*` tasks land — do not add per-screen stub files.
class _TodoScreen extends StatelessWidget {
  const _TodoScreen(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text('TODO: $label')),
    );
  }
}

class _ConsumerScaffold extends StatelessWidget {
  const _ConsumerScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bloodtype_outlined),
            selectedIcon: Icon(Icons.bloodtype),
            label: 'Request',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_hospital_outlined),
            selectedIcon: Icon(Icons.local_hospital),
            label: 'Banks',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Donors',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _AdminScaffold extends StatelessWidget {
  const _AdminScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Partners',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stock',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_carousel_outlined),
            selectedIcon: Icon(Icons.view_carousel),
            label: 'Carousel',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Education',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Moderation',
          ),
        ],
      ),
    );
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefreshListenable(ref);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.rootPath,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: AppRoute.rootPath, redirect: (context, state) => null),
      GoRoute(
        path: AppRoute.onboardingPath,
        name: AppRoute.onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoute.signUpPath,
        name: AppRoute.signUpName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoute.signInPath,
        name: AppRoute.signInName,
        builder: (context, state) => const _TodoScreen('Sign in'),
      ),
      GoRoute(
        path: AppRoute.donorProfileSetupPath,
        name: AppRoute.donorProfileSetupName,
        builder: (context, state) => const _TodoScreen('Donor profile setup'),
      ),

      GoRoute(
        path: AppRoute.notificationsPath,
        name: AppRoute.notificationsName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _TodoScreen('Notifications'),
      ),
      GoRoute(
        path: AppRoute.educationHubPath,
        name: AppRoute.educationHubName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _TodoScreen('Education hub'),
        routes: [
          GoRoute(
            path: ':articleId',
            name: AppRoute.educationArticleName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => _TodoScreen(
              'Education article ${state.pathParameters['articleId']}',
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.donationHistoryPath,
        name: AppRoute.donationHistoryName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _TodoScreen('Donation history'),
      ),
      GoRoute(
        path: AppRoute.badgesPath,
        name: AppRoute.badgesName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _TodoScreen('Badges'),
      ),
      GoRoute(
        path: AppRoute.settingsPath,
        name: AppRoute.settingsName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _TodoScreen('Settings'),
      ),
      GoRoute(
        path: AppRoute.helpSupportPath,
        name: AppRoute.helpSupportName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _TodoScreen('Help & support'),
      ),
      GoRoute(
        path: AppRoute.bannerViewerPath,
        name: AppRoute.bannerViewerName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            _TodoScreen('Banner viewer ${state.pathParameters['itemId']}'),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _ConsumerScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _consumerHomeBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.homePath,
                name: AppRoute.homeName,
                builder: (context, state) => const _TodoScreen('Home'),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _consumerRequestBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.requestPath,
                name: AppRoute.requestName,
                builder: (context, state) => const _TodoScreen('Request blood'),
                routes: [
                  GoRoute(
                    path: 'results/:requestId',
                    name: AppRoute.requestResultsName,
                    builder: (context, state) => _TodoScreen(
                      'Matched banks — request ${state.pathParameters['requestId']}',
                    ),
                  ),
                  GoRoute(
                    path: 'status/:requestId',
                    name: AppRoute.requestStatusName,
                    builder: (context, state) => _TodoScreen(
                      'Request status — ${state.pathParameters['requestId']}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _consumerBanksBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.banksPath,
                name: AppRoute.banksName,
                builder: (context, state) => const _TodoScreen('Bank locator'),
                routes: [
                  GoRoute(
                    path: ':bankId',
                    name: AppRoute.bankProfileName,
                    builder: (context, state) => _TodoScreen(
                      'Bank profile ${state.pathParameters['bankId']}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _consumerDonorsBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.donorsPath,
                name: AppRoute.donorsName,
                builder: (context, state) =>
                    const _TodoScreen('Donor directory'),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _consumerProfileBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.profilePath,
                name: AppRoute.profileName,
                builder: (context, state) => const _TodoScreen('Profile'),
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AdminScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _adminPartnersBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminPartnersPath,
                name: AppRoute.adminPartnersName,
                builder: (context, state) =>
                    const _TodoScreen('Admin: Manage partners'),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminPartnerNewName,
                    builder: (context, state) =>
                        const _TodoScreen('Admin: Add partner'),
                  ),
                  GoRoute(
                    path: ':partnerId/edit',
                    name: AppRoute.adminPartnerEditName,
                    builder: (context, state) => _TodoScreen(
                      'Admin: Edit partner ${state.pathParameters['partnerId']}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminStockBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminStockPath,
                name: AppRoute.adminStockName,
                builder: (context, state) =>
                    const _TodoScreen('Admin: Update stock'),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminCarouselBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminCarouselPath,
                name: AppRoute.adminCarouselName,
                builder: (context, state) =>
                    const _TodoScreen('Admin: Manage home carousel'),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminCarouselNewName,
                    builder: (context, state) =>
                        const _TodoScreen('Admin: Upload banner'),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminEducationBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminEducationPath,
                name: AppRoute.adminEducationName,
                builder: (context, state) =>
                    const _TodoScreen('Admin: Manage education hub'),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminEducationNewName,
                    builder: (context, state) =>
                        const _TodoScreen('Admin: New article'),
                  ),
                  GoRoute(
                    path: ':articleId/edit',
                    name: AppRoute.adminEducationEditName,
                    builder: (context, state) => _TodoScreen(
                      'Admin: Edit article ${state.pathParameters['articleId']}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminModerationBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminModerationPath,
                name: AppRoute.adminModerationName,
                builder: (context, state) =>
                    const _TodoScreen('Admin: Moderation'),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
