import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../data/models/banner_item_model.dart';
import '../../../data/repositories/banner_item_repository.dart';
import '../../../shared/widgets/app_button.dart';

typedef BannerViewerEntry = ({String id, BannerItemModel model});

/// Passed via `GoRouterState.extra` when opened from a carousel that already
/// has its active banners loaded, so the viewer shows exactly what the user
/// tapped instead of re-querying Firestore mid-view — an accepted staleness
/// window: if a banner is deactivated by an admin while this viewer is open,
/// it stays visible until the screen is closed and home reloads. If this
/// route is ever reached without `extra` (e.g. a future deep link),
/// [BannerViewerScreen] falls back to a fresh one-shot fetch and looks up
/// [BannerViewerScreen.itemId] in it — a since-deactivated banner then
/// simply won't be found, and the "no longer available" state below shows
/// instead.
typedef BannerViewerArgs = ({
  List<BannerViewerEntry> banners,
  int initialIndex,
});

class BannerViewerScreen extends ConsumerStatefulWidget {
  const BannerViewerScreen({super.key, required this.itemId, this.preloaded});

  final String itemId;
  final BannerViewerArgs? preloaded;

  @override
  ConsumerState<BannerViewerScreen> createState() => _BannerViewerScreenState();
}

class _BannerViewerScreenState extends ConsumerState<BannerViewerScreen> {
  late final PageController _pageController;
  late final Future<List<BannerViewerEntry>> _bannersFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.preloaded?.initialIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    _bannersFuture = _resolveBanners();
  }

  Future<List<BannerViewerEntry>> _resolveBanners() async {
    final preloaded = widget.preloaded;
    if (preloaded != null) return preloaded.banners;

    final all = await ref
        .read(bannerItemRepositoryProvider)
        .listActiveBanners();
    final index = all.indexWhere((entry) => entry.id == widget.itemId);
    if (index < 0) return const [];

    _currentIndex = index;
    if (index != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pageController.jumpToPage(index);
      });
    }
    return all;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openBankProfile(String partnerId) {
    context.goNamed(
      AppRoute.bankProfileName,
      pathParameters: {'bankId': partnerId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<List<BannerViewerEntry>>(
          future: _bannersFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            final banners = snapshot.data!;
            if (banners.isEmpty) {
              return _UnavailableState(
                onClose: () => Navigator.of(context).pop(),
              );
            }

            final current = banners[_currentIndex];
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: banners.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    final entry = banners[index];
                    return InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Center(
                        child: Image.network(
                          entry.model.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.white54,
                                size: 48,
                              ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                if (banners.length > 1)
                  Positioned(
                    bottom: 96,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < banners.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _currentIndex ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _currentIndex
                                  ? Colors.white
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (current.model.linkedPartnerId != null)
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: AppButton(
                      label: 'View bank',
                      onPressed: () =>
                          _openBankProfile(current.model.linkedPartnerId!),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UnavailableState extends StatelessWidget {
  const _UnavailableState({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This banner is no longer available',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onClose,
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
