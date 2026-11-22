import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../providers/app_providers.dart';
import '../../widgets/async_content.dart';
import '../cases/case_screens.dart';
import '../legal_guides/legal_guide_screens.dart';
import '../lawyer_dashboard/lawyer_dashboard_screen.dart';
import 'name_setup_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(signedInProvider)) return ref.watch(signInScreenProvider);
    final profile = ref.watch(myProfileProvider);
    return profile.when(
      loading: () => const _LoadingGate(),
      error: (error, stack) => Scaffold(
        body: ErrorPanel(
          message: friendlyError(error),
          onRetry: () => ref.invalidate(myProfileProvider),
        ),
      ),
      data: (profile) => profile == null
          ? const NameSetupScreen()
          : RoleRouter(role: profile.role),
    );
  }
}

class _LoadingGate extends StatelessWidget {
  const _LoadingGate();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) => role == UserRole.lawyer
      ? const MainShell(role: UserRole.lawyer)
      : const MainShell(role: UserRole.citizen);
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.role});

  final UserRole role;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  bool get _isLawyer => widget.role == UserRole.lawyer;

  List<Widget> get _pages => _isLawyer
      ? const [LawyerDashboardScreen(), CaseListScreen(), ProfileScreen()]
      : const [
          CitizenHomeScreen(),
          LegalGuideListScreen(),
          CaseListScreen(),
          ProfileScreen(),
        ];

  List<NavigationDestination> get _destinations => _isLawyer
      ? const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Cases',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]
      : const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Guides',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'My cases',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Clarity'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Sign out?'),
                  content: const Text('You can sign back in at any time.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              );
              if (confirmed == true)
                await ref.read(clientProvider).auth.signOutDevice();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
            style: TextButton.styleFrom(foregroundColor: colors.onSurface),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            final page = AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: IndexedStack(
                    key: ValueKey(_selectedIndex),
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ),
            );
            if (!wide) return page;
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: destination.icon,
                          selectedIcon:
                              destination.selectedIcon ?? destination.icon,
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: page),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 840) return const SizedBox.shrink();
          return NavigationBar(
            selectedIndex: _selectedIndex,
            destinations: _destinations,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
          );
        },
      ),
    );
  }
}
