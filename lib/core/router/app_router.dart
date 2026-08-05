import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/admin/manage_camps/presentation/camp_form_screen.dart';
import '../../features/admin/manage_camps/presentation/manage_camps_screen.dart';
import '../../features/admin/manage_carousel/presentation/manage_carousel_screen.dart';
import '../../features/admin/manage_carousel/presentation/upload_banner_screen.dart';
import '../../features/admin/manage_education_hub/presentation/article_form_screen.dart';
import '../../features/admin/manage_education_hub/presentation/manage_education_hub_screen.dart';
import '../../features/admin/manage_partners/presentation/manage_partners_screen.dart';
import '../../features/admin/manage_partners/presentation/partner_form_screen.dart';
import '../../features/admin/moderation/presentation/moderation_screen.dart';
import '../../features/admin/update_stock/presentation/update_stock_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/bank_locator/presentation/bank_locator_screen.dart';
import '../../features/bank_locator/presentation/bank_profile_screen.dart';
import '../../features/blood_request/presentation/matched_banks_screen.dart';
import '../../features/blood_request/presentation/request_blood_screen.dart';
import '../../features/blood_request/presentation/request_status_screen.dart';
import '../../features/admin/verify_donors/presentation/verify_donors_screen.dart';
import '../../features/camps/presentation/camp_detail_screen.dart';
import '../../features/camps/presentation/camp_listing_screen.dart';
import '../../features/donor_directory/presentation/donor_directory_screen.dart';
import '../../features/donor_profile/presentation/donor_profile_setup_screen.dart';
import '../../features/donor_profile/presentation/donor_verification_screen.dart';
import '../../features/education_hub/presentation/article_detail_screen.dart';
import '../../features/education_hub/presentation/education_hub_screen.dart';
import '../../features/home/presentation/banner_viewer_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notifications/presentation/notification_center_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'auth_state.dart';

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
final _adminVerifyDonorsBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminVerifyDonors',
);
final _adminCampsBranchKey = GlobalKey<NavigatorState>(
  debugLabel: 'adminCamps',
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
  // 'requestId' is the authoritative path-param name for this route (set in
  // 2A-3). MatchedBanksScreen (2A-4) must read
  // state.pathParameters['requestId'] — do not re-decide this name
  // independently when that task starts. Same treatment as 'bankId' above.
  static const String requestResultsPath = '/request/results/:requestId';

  static const String requestStatusName = 'requestStatus';
  // No :requestId param — 2A-5's screen lists all of the current user's
  // requests, it isn't a per-request detail view. (Earlier scaffolding had
  // this as a per-id path; nothing referenced it yet, so it was safe to
  // correct here rather than carry the mismatch forward.)
  static const String requestStatusPath = '/request/status';

  static const String banksName = 'banks';
  static const String banksPath = '/banks';

  static const String bankProfileName = 'bankProfile';
  // 'bankId' is the authoritative path-param name for this route (set in
  // 1B-8). BankProfileScreen (1B-9) must read state.pathParameters['bankId']
  // — do not re-decide this name independently when that task starts.
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

  static const String settingsName = 'settings';
  static const String settingsPath = '/profile/settings';

  static const String helpSupportName = 'helpSupport';
  static const String helpSupportPath = '/profile/help';

  static const String bannerViewerName = 'bannerViewer';
  static const String bannerViewerPath = '/banner-viewer/:itemId';

  // Linked from ProfileScreen's blood-group/verification badge row (3A-5).
  static const String donorVerificationName = 'donorVerification';
  static const String donorVerificationPath = '/profile/verification';

  // Not in docs/SPEC.md's original consumer nav — added in 4A-2. Entry
  // point is AppDrawer, same treatment as Education hub/Donation history.
  static const String campsName = 'camps';
  static const String campsPath = '/camps';

  static const String campDetailName = 'campDetail';
  // 'campId' is the authoritative path-param name for this route — mirrors
  // 'bankId'/'requestId' above.
  static const String campDetailPath = '/camps/:campId';

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

  // Added in 2A-8 — see docs/SPEC.md Admin section, not part of the
  // original Stage-4 nav list.
  static const String adminVerifyDonorsName = 'adminVerifyDonors';
  static const String adminVerifyDonorsPath = '/admin/verify-donors';

  // Added in 4A-3 — see docs/SPEC.md Admin section, not part of the
  // original Stage-4 nav list (donationCamps didn't exist yet).
  static const String adminCampsName = 'adminCamps';
  static const String adminCampsPath = '/admin/camps';

  static const String adminCampNewName = 'adminCampNew';
  static const String adminCampEditName = 'adminCampEdit';

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

  // Auth stream hasn't resolved yet — stay put rather than guessing signed-out.
  if (auth.isLoading) return null;

  if (path == AppRoute.rootPath) {
    if (!auth.isSignedIn) return AppRoute.onboardingPath;
    if (auth.roles.isEmpty) return AppRoute.donorProfileSetupPath;
    return auth.isAdmin ? AppRoute.adminPartnersPath : AppRoute.homePath;
  }

  if (!auth.isSignedIn) {
    return AppRoute.isPublic(path) ? null : AppRoute.signInPath;
  }

  if (AppRoute.isPostAuthEntry(path)) {
    if (auth.roles.isEmpty) return AppRoute.donorProfileSetupPath;
    return auth.isAdmin ? AppRoute.adminPartnersPath : AppRoute.homePath;
  }

  if (auth.roles.isEmpty && path != AppRoute.donorProfileSetupPath) {
    return AppRoute.donorProfileSetupPath;
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
          NavigationDestination(
            icon: Icon(Icons.verified_user_outlined),
            selectedIcon: Icon(Icons.verified_user),
            label: 'Donors',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Camps',
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
      GoRoute(
        path: AppRoute.rootPath,
        redirect: (context, state) => null,
        // Only rendered while authState is still resolving (redirect above
        // returns null) — never reached once signed-in/out is known.
        builder: (context, state) => const SizedBox.shrink(),
      ),
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
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoute.donorProfileSetupPath,
        name: AppRoute.donorProfileSetupName,
        builder: (context, state) => const DonorProfileSetupScreen(),
      ),

      GoRoute(
        path: AppRoute.notificationsPath,
        name: AppRoute.notificationsName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationCenterScreen(),
      ),
      GoRoute(
        path: AppRoute.educationHubPath,
        name: AppRoute.educationHubName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EducationHubScreen(),
        routes: [
          GoRoute(
            path: ':articleId',
            name: AppRoute.educationArticleName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => ArticleDetailScreen(
              articleId: state.pathParameters['articleId']!,
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
        builder: (context, state) {
          final extra = state.extra;
          final preloaded = extra is BannerViewerArgs ? extra : null;
          return BannerViewerScreen(
            itemId: state.pathParameters['itemId']!,
            preloaded: preloaded,
          );
        },
      ),
      GoRoute(
        path: AppRoute.donorVerificationPath,
        name: AppRoute.donorVerificationName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DonorVerificationScreen(),
      ),
      GoRoute(
        path: AppRoute.campsPath,
        name: AppRoute.campsName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CampListingScreen(),
        routes: [
          GoRoute(
            path: ':campId',
            name: AppRoute.campDetailName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) =>
                CampDetailScreen(campId: state.pathParameters['campId']!),
          ),
        ],
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
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _consumerRequestBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.requestPath,
                name: AppRoute.requestName,
                builder: (context, state) => const RequestBloodScreen(),
                routes: [
                  GoRoute(
                    // Path segment name must stay 'requestId' — see the
                    // AppRoute.requestResultsPath contract note above.
                    path: 'results/:requestId',
                    name: AppRoute.requestResultsName,
                    builder: (context, state) => MatchedBanksScreen(
                      requestId: state.pathParameters['requestId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'status',
                    name: AppRoute.requestStatusName,
                    builder: (context, state) => const RequestStatusScreen(),
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
                builder: (context, state) => const BankLocatorScreen(),
                routes: [
                  GoRoute(
                    // Path segment name must stay 'bankId' — see the
                    // AppRoute.bankProfilePath contract note above.
                    path: ':bankId',
                    name: AppRoute.bankProfileName,
                    builder: (context, state) => BankProfileScreen(
                      bankId: state.pathParameters['bankId']!,
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
                builder: (context, state) => const DonorDirectoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _consumerProfileBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.profilePath,
                name: AppRoute.profileName,
                builder: (context, state) => const ProfileScreen(),
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
                builder: (context, state) => const ManagePartnersScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminPartnerNewName,
                    builder: (context, state) => const PartnerFormScreen(),
                  ),
                  GoRoute(
                    path: ':partnerId/edit',
                    name: AppRoute.adminPartnerEditName,
                    builder: (context, state) => PartnerFormScreen(
                      partnerId: state.pathParameters['partnerId'],
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
                builder: (context, state) => const UpdateStockScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminCarouselBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminCarouselPath,
                name: AppRoute.adminCarouselName,
                builder: (context, state) => const ManageCarouselScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminCarouselNewName,
                    builder: (context, state) => const UploadBannerScreen(),
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
                builder: (context, state) => const ManageEducationHubScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminEducationNewName,
                    builder: (context, state) => const ArticleFormScreen(),
                  ),
                  GoRoute(
                    path: ':articleId/edit',
                    name: AppRoute.adminEducationEditName,
                    builder: (context, state) => ArticleFormScreen(
                      articleId: state.pathParameters['articleId'],
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
                builder: (context, state) => const ModerationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminVerifyDonorsBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminVerifyDonorsPath,
                name: AppRoute.adminVerifyDonorsName,
                builder: (context, state) => const VerifyDonorsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminCampsBranchKey,
            routes: [
              GoRoute(
                path: AppRoute.adminCampsPath,
                name: AppRoute.adminCampsName,
                builder: (context, state) => const ManageCampsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.adminCampNewName,
                    builder: (context, state) => const CampFormScreen(),
                  ),
                  GoRoute(
                    path: ':campId/edit',
                    name: AppRoute.adminCampEditName,
                    builder: (context, state) =>
                        CampFormScreen(campId: state.pathParameters['campId']),
                  ),
                ],
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
