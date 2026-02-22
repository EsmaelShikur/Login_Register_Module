// ignore_for_file: deprecated_member_use

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/animations/auth_animations.dart';
import '../../core/animations/particle_background.dart';
import '../../core/constants/auth_constants.dart';
import '../../core/constants/auth_validators.dart';
import '../../domain/entities/auth_user.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final void Function(AuthUser user) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final savedEmail = await AuthNotifier.getSavedEmail();
    if (savedEmail != null && mounted) {
      _emailController.text = savedEmail;
      setState(() => _rememberMe = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeController.forward(from: 0);
      return;
    }

    await ref.read(authNotifierProvider.notifier).signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          rememberMe: _rememberMe,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      if (current is AuthSuccess) {
        widget.onLoginSuccess(current.user);
      } else if (current is AuthError) {
        _shakeController.forward(from: 0);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(current.message),
              backgroundColor: AuthColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: Stack(
        children: [
          // Particle background
          Positioned.fill(
            child: ParticleBackground(isDark: isDark),
          ),

          // Content
          SafeArea(
            child: AuthLoadingOverlay(
              isLoading: isLoading,
              isDark: isDark,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AuthSpacing.lg,
                    vertical: AuthSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar with theme toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AuthThemeToggle(
                            isDark: isDark,
                            onToggle: () => ref
                                .read(themeNotifierProvider.notifier)
                                .toggle(),
                          ),
                        ],
                      ),

                      const SizedBox(height: AuthSpacing.lg),

                      // Logo
                      Center(
                        child: AuthLogo(isDark: isDark, size: 80),
                      ),

                      const SizedBox(height: AuthSpacing.xl),

                      // Title
                      Text(
                        'Welcome Back',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  foreground: isDark
                                      ? (Paint()
                                        ..shader = const LinearGradient(
                                          colors: [
                                            AuthColors.neonCyan,
                                            AuthColors.neonPurple,
                                          ],
                                        ).createShader(
                                            const Rect.fromLTWH(0, 0, 200, 50)))
                                      : null,
                                ),
                      ),
                      const SizedBox(height: AuthSpacing.xs),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: AuthSpacing.xl),

                      // Form
                      ShakeAnimWidget(
                        animation: _shakeAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email
                              AuthTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'you@example.com',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                focusNode: _emailFocus,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocus),
                                prefixIcon: const Icon(Icons.email_outlined),
                                validator: AuthValidators.validateEmail,
                                isDark: isDark,
                              ),

                              const SizedBox(height: AuthSpacing.md),

                              // Password
                              AuthTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                focusNode: _passwordFocus,
                                onEditingComplete: _handleLogin,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: isDark
                                        ? AuthColors.darkTextHint
                                        : AuthColors.lightTextHint,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                                validator: AuthValidators.validatePassword,
                                isDark: isDark,
                              ),

                              const SizedBox(height: AuthSpacing.sm),

                              // Remember me + forgot password row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) => setState(
                                              () => _rememberMe = v ?? false),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remember me',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? AuthColors.darkTextSecondary
                                              : AuthColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Forgot password hook
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: isDark
                                            ? AuthColors.neonCyan
                                            : AuthColors.lightPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AuthSpacing.lg),

                              // Login button
                              NeonButton(
                                label: 'Sign In',
                                onPressed: isLoading ? null : _handleLogin,
                                isDark: isDark,
                              ),

                              const SizedBox(height: AuthSpacing.lg),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: isDark
                                          ? AuthColors.darkTextHint
                                              .withOpacity(0.2)
                                          : const Color(0xFFDDE3EF),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      'or continue with',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AuthColors.darkTextHint
                                            : AuthColors.lightTextHint,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: isDark
                                          ? AuthColors.darkTextHint
                                              .withOpacity(0.2)
                                          : const Color(0xFFDDE3EF),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AuthSpacing.md),

                              // Social buttons
                              _buildSocialButtons(isDark, isLoading),

                              const SizedBox(height: AuthSpacing.xl),

                              // Sign up link
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: isDark
                                            ? AuthColors.darkTextSecondary
                                            : AuthColors.lightTextSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(authNotifierProvider.notifier)
                                            .resetState();
                                        Navigator.of(context).push(
                                          AuthPageRoute(
                                            page: RegisterScreen(
                                              onRegisterSuccess:
                                                  widget.onLoginSuccess,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: isDark
                                              ? AuthColors.neonCyan
                                              : AuthColors.lightPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AuthSpacing.lg),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons(bool isDark, bool isLoading) {
    final isIOS = _isIOS();

    if (isIOS) {
      return Column(
        children: [
          SocialAuthButton(
            label: 'Continue with Google',
            icon: _GoogleIcon(),
            isDark: isDark,
            onPressed: isLoading
                ? null
                : () =>
                    ref.read(authNotifierProvider.notifier).signInWithGoogle(),
          ),
          const SizedBox(height: AuthSpacing.sm),
          SocialAuthButton(
            label: 'Continue with Apple',
            icon: _AppleIcon(isDark: isDark),
            isDark: isDark,
            onPressed: isLoading
                ? null
                : () =>
                    ref.read(authNotifierProvider.notifier).signInWithApple(),
          ),
        ],
      );
    }

    return SocialAuthButton(
      label: 'Continue with Google',
      icon: _GoogleIcon(),
      isDark: isDark,
      onPressed: isLoading
          ? null
          : () => ref.read(authNotifierProvider.notifier).signInWithGoogle(),
    );
  }

  bool _isIOS() {
    try {
      return Platform.isIOS;
    } catch (_) {
      return false;
    }
  }
}

/// Google icon SVG-equivalent using CustomPaint
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GoogleIconPainter());
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    final blueP = Paint()..color = const Color(0xFF4285F4);
    final redP = Paint()..color = const Color(0xFFEA4335);
    final yellowP = Paint()..color = const Color(0xFFFBBC05);
    final greenP = Paint()..color = const Color(0xFF34A853);

    // Simplified G logo using arcs
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -0.25,
        1.6,
        false,
        blueP
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.25);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        1.35,
        1.2,
        false,
        greenP
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.25);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        2.55,
        0.85,
        false,
        yellowP
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.25);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        3.4,
        0.85,
        false,
        redP
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.25);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AppleIcon extends StatelessWidget {
  final bool isDark;
  const _AppleIcon({this.isDark = true});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.apple,
      size: 22,
      color: isDark ? Colors.white : Colors.black,
    );
  }
}
