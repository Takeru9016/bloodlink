import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/partner_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../application/home_controller.dart';
import 'banner_viewer_screen.dart';

const _autoRotateInterval = Duration(seconds: 5);
const _bannerHeight = 160.0;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _pageController = PageController();
  Timer? _autoRotateTimer;
  int _currentBannerIndex = 0;
  int _knownBannerCount = -1;

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _syncAutoRotate(int bannerCount) {
    if (bannerCount == _knownBannerCount) return;
    _knownBannerCount = bannerCount;
    _autoRotateTimer?.cancel();
    if (bannerCount <= 1) return;
    _autoRotateTimer = Timer.periodic(_autoRotateInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      // Skip a tick while something (e.g. BannerViewerScreen) is pushed on
      // top — otherwise the carousel keeps advancing behind the viewer and
      // lands on a different page than the one the user tapped by the time
      // they close it.
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) return;
      final next = (_currentBannerIndex + 1) % bannerCount;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _openBanner(List<BannerViewerEntry> banners, int index) {
    // pushNamed, not goNamed — bannerViewerPath is a root-navigator sibling
    // route, not nested under home, so `go` would replace the whole
    // location (dropping Home from the stack) and leave BannerViewerScreen's
    // Navigator.pop()-based close button with nothing to pop back to.
    context.pushNamed(
      AppRoute.bannerViewerName,
      pathParameters: {'itemId': banners[index].id},
      extra: (banners: banners, initialIndex: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final homeAsync = ref.watch(homeControllerProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  // pushNamed for the same reason as the banner viewer above
                  // — notificationsPath is a root-navigator sibling route,
                  // and `go`ing to it would strand the user with no way
                  // back to Home.
                  onPressed: () =>
                      context.pushNamed(AppRoute.notificationsName),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: homeAsync.when(
          data: (state) {
            _syncAutoRotate(state.banners.length);
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(homeControllerProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _BannerCarousel(
                    banners: state.banners,
                    pageController: _pageController,
                    currentIndex: _currentBannerIndex,
                    onPageChanged: (index) =>
                        setState(() => _currentBannerIndex = index),
                    onTapBanner: (index) => _openBanner(state.banners, index),
                  ),
                  const SizedBox(height: 24),
                  _QuickActionsRow(
                    onRequestBlood: () => context.goNamed(AppRoute.requestName),
                    onFindBank: () => context.goNamed(AppRoute.banksName),
                    onDonorList: () => context.goNamed(AppRoute.donorsName),
                  ),
                  const SizedBox(height: 24),
                  _DemandSnapshotCard(
                    locationStatus: state.locationStatus,
                    pendingNearbyCount: state.pendingNearbyCount,
                  ),
                  const SizedBox(height: 24),
                  Text('Trusted partners', style: textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _TrustedPartnersGrid(partners: state.trustedPartners),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load home: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({
    required this.banners,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onTapBanner,
  });

  final List<BannerViewerEntry> banners;
  final PageController pageController;
  final int currentIndex;
  final void Function(int index) onPageChanged;
  final void Function(int index) onTapBanner;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (banners.isEmpty) {
      return AppCard(
        child: SizedBox(
          height: _bannerHeight,
          child: Center(
            child: Text(
              'No announcements right now',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: _bannerHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: banners.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return GestureDetector(
                onTap: () => onTapBanner(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: Image.network(
                    banner.model.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colors.surfaceMuted,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < banners.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == currentIndex ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == currentIndex ? colors.brandRed : colors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onRequestBlood,
    required this.onFindBank,
    required this.onDonorList,
  });

  final VoidCallback onRequestBlood;
  final VoidCallback onFindBank;
  final VoidCallback onDonorList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: Icons.bloodtype_outlined,
            label: 'Request blood',
            onTap: onRequestBlood,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.local_hospital_outlined,
            label: 'Find bank',
            onTap: onFindBank,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.people_outline,
            label: 'Donor list',
            onTap: onDonorList,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: colors.brandRed),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _DemandSnapshotCard extends StatelessWidget {
  const _DemandSnapshotCard({
    required this.locationStatus,
    required this.pendingNearbyCount,
  });

  final HomeLocationStatus locationStatus;
  final int? pendingNearbyCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final String label = switch (locationStatus) {
      HomeLocationStatus.resolving => 'Checking local demand…',
      HomeLocationStatus.unavailable =>
        'Local demand unavailable — enable location to see nearby need',
      HomeLocationStatus.available =>
        '${pendingNearbyCount ?? 0} pending blood ${(pendingNearbyCount ?? 0) == 1 ? 'request' : 'requests'} near you',
    };

    return AppCard(
      child: Row(
        children: [
          Icon(Icons.query_stats, color: colors.brandRed),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustedPartnersGrid extends StatelessWidget {
  const _TrustedPartnersGrid({required this.partners});

  final List<({String id, PartnerModel partner})> partners;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (partners.isEmpty) {
      return AppCard(
        child: Text(
          'No verified partners yet',
          style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: partners.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final partner = partners[index].partner;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                partner.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge,
              ),
              const AppBadge(
                label: 'Verified',
                variant: AppBadgeVariant.verified,
              ),
            ],
          ),
        );
      },
    );
  }
}
