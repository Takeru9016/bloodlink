import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class _OnboardingPageData {
  const _OnboardingPageData({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

const _pages = [
  _OnboardingPageData(
    icon: Icons.bloodtype_outlined,
    title: 'Find blood, save lives',
  ),
  _OnboardingPageData(
    icon: Icons.touch_app_outlined,
    title: 'Need blood? Just a tap away',
  ),
  _OnboardingPageData(
    icon: Icons.local_hospital_outlined,
    title: 'Secure blood for surgeries & emergencies',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignUp() => context.goNamed(AppRoute.signUpName);

  void _onPrimaryPressed() {
    if (_currentPage == _pages.length - 1) {
      _goToSignUp();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextButton(
                  onPressed: _goToSignUp,
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: colors.surfaceMuted,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 72,
                            color: colors.brandRed,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? colors.brandRed : colors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButton(
                label: isLastPage ? 'Get started' : 'Next',
                onPressed: _onPrimaryPressed,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
