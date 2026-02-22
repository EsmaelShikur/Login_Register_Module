import 'package:flutter/material.dart';
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
import '../widgets/password_strength_indicator.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final void Function(AuthUser user) onRegisterSuccess;

  const RegisterScreen({super.key, required this.onRegisterSuccess});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeController.forward(from: 0);
      return;
    }

    await ref.read(authNotifierProvider.notifier).registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      if (current is AuthSuccess) {
        widget.onRegisterSuccess(current.user);
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
          Positioned.fill(child: ParticleBackground(isDark: isDark)),
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
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: isDark
                                  ? AuthColors.darkTextSecondary
                                  : AuthColors.lightTextSecondary,
                              size: 20,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          AuthThemeToggle(
                            isDark: isDark,
                            onToggle: () => ref
                                .read(themeNotifierProvider.notifier)
                                .toggle(),
                          ),
                        ],
                      ),

                      const SizedBox(height: AuthSpacing.md),

                      // Logo
                      Center(child: AuthLogo(isDark: isDark, size: 70)),

                      const SizedBox(height: AuthSpacing.lg),

                      // Title
                      Text(
                        'Create Account',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  foreground: isDark
                                      ? (Paint()
                                        ..shader = const LinearGradient(
                                          colors: [
                                            AuthColors.neonPurple,
                                            AuthColors.neonCyan,
                                          ],
                                        ).createShader(const Rect.fromLTWH(
                                            0, 0, 250, 50)))
                                      : null,
                                ),
                      ),
                      const SizedBox(height: AuthSpacing.xs),
                      Text(
                        'Join us today, it\'s free!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: AuthSpacing.xl),

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
                                hint: 'Create a strong password',
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                focusNode: _passwordFocus,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_confirmFocus),
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
                                  onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword),
                                ),
                                validator: AuthValidators.validatePassword,
                                isDark: isDark,
                                onChanged: (_) => setState(() {}),
                              ),

                              // Password strength indicator
                              ValueListenableBuilder(
                                valueListenable: _passwordController,
                                builder: (_, value, __) =>
                                    PasswordStrengthIndicator(
                                  password: value.text,
                                  isDark: isDark,
                                ),
                              ),

                              const SizedBox(height: AuthSpacing.md),

                              // Confirm password
                              AuthTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Repeat your password',
                                obscureText: _obscureConfirm,
                                textInputAction: TextInputAction.done,
                                focusNode: _confirmFocus,
                                onEditingComplete: _handleRegister,
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: isDark
                                        ? AuthColors.darkTextHint
                                        : AuthColors.lightTextHint,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                                ),
                                validator: (v) =>
                                    AuthValidators.validateConfirmPassword(
                                        v, _passwordController.text),
                                isDark: isDark,
                              ),

                              const SizedBox(height: AuthSpacing.lg),

                              // Register button
                              NeonButton(
                                label: 'Create Account',
                                onPressed: isLoading ? null : _handleRegister,
                                isDark: isDark,
                                color: isDark
                                    ? AuthColors.neonPurple
                                    : null,
                                glowColor: isDark
                                    ? AuthColors.neonPurple
                                    : null,
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
                                      'or sign up with',
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

                              SocialAuthButton(
                                label: 'Sign up with Google',
                                icon: _GoogleIconSimple(),
                                isDark: isDark,
                                onPressed: isLoading
                                    ? null
                                    : () => ref
                                        .read(authNotifierProvider.notifier)
                                        .signInWithGoogle(),
                              ),

                              const SizedBox(height: AuthSpacing.xl),

                              // Login link
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
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
                                            .read(
                                                authNotifierProvider.notifier)
                                            .resetState();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Sign In',
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
}

class _GoogleIconSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.g_mobiledata_rounded,
      color: Color(0xFF4285F4),
      size: 24,
    );
  }
}
