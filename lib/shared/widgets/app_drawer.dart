import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/application/auth_controller.dart';

/// `_redirect` in `app_router.dart` reacts to the resulting
/// `authStateProvider` change and routes to sign-in on its own; this drawer
/// doesn't navigate after signing out. ProfileScreen's own "Log out" menu
/// item (3A-5) follows the same pattern.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  /// For consumer-shell tab routes (e.g. Profile) — switches bottom-nav
  /// branch via `go`, same as tapping the tab itself.
  ///
  /// Closes the drawer via `Scaffold.of(context).closeDrawer()`, not
  /// `Navigator.of(context).pop()`. A `Drawer` is dismissed by consuming a
  /// local history entry on the enclosing route, and `Navigator.pop()` only
  /// reliably targets that entry when it's still current; on some
  /// devices/timings the entry can already be gone by the time this handler
  /// runs (e.g. the drawer's own swipe-to-dismiss beat the tap), and the
  /// `pop()` falls through to the real route underneath — silently dropping
  /// Home (or whichever shell page) off the Navigator stack. Confirmed live
  /// on a physical device: Education hub reached this way had no back arrow
  /// and a system-back press exited the app instead of returning to Home.
  /// `closeDrawer()` can't have that ambiguity — it only ever closes the
  /// drawer.
  void _goToTab(BuildContext context, String routeName) {
    Scaffold.of(context).closeDrawer();
    context.goNamed(routeName);
  }

  /// For root-navigator sibling routes (Education hub, Donation history,
  /// Settings, Help & support — none of them nested under a shell branch).
  /// Must be `push`, not `go`: those routes sit outside the shell's route
  /// tree, so `go`ing to one replaces the whole location and drops the
  /// shell (and Home) from the stack, leaving no way back. See the same
  /// note on `_openBanner`/the bell in `home_screen.dart`.
  ///
  /// See `_goToTab`'s doc comment for why this closes the drawer via
  /// `Scaffold.of(context).closeDrawer()` instead of `Navigator.pop()`.
  void _pushOverlay(BuildContext context, String routeName) {
    Scaffold.of(context).closeDrawer();
    context.pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'bloodlink',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Divider(color: colors.border, height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => _goToTab(context, AppRoute.profileName),
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Education hub'),
              onTap: () => _pushOverlay(context, AppRoute.educationHubName),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Donation history'),
              onTap: () => _pushOverlay(context, AppRoute.donationHistoryName),
            ),
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: const Text('Donation camps'),
              onTap: () => _pushOverlay(context, AppRoute.campsName),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => _pushOverlay(context, AppRoute.settingsName),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & support'),
              onTap: () => _pushOverlay(context, AppRoute.helpSupportName),
            ),
            const Spacer(),
            Divider(color: colors.border, height: 1),
            ListTile(
              leading: Icon(Icons.logout, color: colors.error),
              title: Text('Log out', style: TextStyle(color: colors.error)),
              onTap: () {
                Scaffold.of(context).closeDrawer();
                ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
