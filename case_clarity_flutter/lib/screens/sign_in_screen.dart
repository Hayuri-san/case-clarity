import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../core/theme.dart';
import '../widgets/app_components.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _isSignedIn
        ? widget.child
        : Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.x3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: CaseClarityColors.navy,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.gavel_rounded,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.x1),
                                  Text(
                                    'Case Clarity',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Understand your legal notice. Track your case.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: AppSpacing.x2,
                              runSpacing: AppSpacing.x1,
                              children: const [
                                _Benefit(
                                  icon: Icons.menu_book_outlined,
                                  text: 'Understand notices',
                                ),
                                _Benefit(
                                  icon: Icons.event_available_outlined,
                                  text: 'Keep track of deadlines',
                                ),
                                _Benefit(
                                  icon: Icons.timeline_outlined,
                                  text: 'Follow your case',
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 520,
                                ),
                                child: AppCard(
                                  padding: const EdgeInsets.all(AppSpacing.x2),
                                  child: SignInWidget(
                                    client: client,
                                    onAuthenticated: () {
                                      context.showSnackBar(
                                        message: 'You are signed in.',
                                        backgroundColor:
                                            colors.primaryContainer,
                                        foregroundColor:
                                            colors.onPrimaryContainer,
                                      );
                                    },
                                    onError: (_) {
                                      context.showSnackBar(
                                        message:
                                            'We could not sign you in. Check your details and try again.',
                                        backgroundColor: colors.errorContainer,
                                        foregroundColor:
                                            colors.onErrorContainer,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              'General information, not legal advice.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 20),
      const SizedBox(width: 8),
      Text(text, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

extension on BuildContext {
  void showSnackBar({
    required String message,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: foregroundColor)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
