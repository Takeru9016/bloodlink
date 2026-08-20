import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Lets each admin branch-root screen (each owns its own `Scaffold`/`AppBar`
/// for its title + FAB) open the *outer* shell's drawer, since
/// `Scaffold.of(context)` from inside a nested `Scaffold` resolves to itself,
/// not the ancestor holding `AdminDrawer`.
class AdminShellScope extends InheritedWidget {
  const AdminShellScope({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  final VoidCallback openDrawer;

  static AdminShellScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AdminShellScope>();
    assert(scope != null, 'AdminShellScope.of() called outside the admin shell');
    return scope!;
  }

  @override
  bool updateShouldNotify(AdminShellScope oldWidget) =>
      openDrawer != oldWidget.openDrawer;
}

class AdminDrawerItem {
  const AdminDrawerItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Admin's 8 sections were an 8-item bottom `NavigationBar` — past the point
/// styling alone fixes (see DESIGN_SYSTEM.md §Navigation). This mirrors
/// `AppDrawer`'s pattern instead: a drawer opened from a top `AppBar`,
/// listing every section with the current one highlighted.
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<AdminDrawerItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text('Admin', style: textTheme.headlineSmall),
            ),
            Divider(color: colors.border, height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? colors.brandRed : colors.textSecondary,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? colors.brandRed : colors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: colors.brandRed.withValues(alpha: 0.06),
                    onTap: () {
                      // Scaffold.of(context).closeDrawer(), not
                      // Navigator.pop() — see AppDrawer's doc comment
                      // (app_drawer.dart) for why: on some devices/timings
                      // Navigator.pop() can fall through and pop the real
                      // page underneath instead of just closing the drawer.
                      Scaffold.of(context).closeDrawer();
                      onSelect(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
