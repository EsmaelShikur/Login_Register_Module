import 'package:flutter/material.dart';
import '../../core/constants/auth_constants.dart';
import '../../core/constants/auth_validators.dart';

/// Animated password strength meter
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool isDark;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.isDark = true,
  });

  Color _getColor(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.empty => Colors.transparent,
      PasswordStrength.weak => AuthColors.strengthWeak,
      PasswordStrength.fair => AuthColors.strengthFair,
      PasswordStrength.good => AuthColors.strengthGood,
      PasswordStrength.strong => AuthColors.strengthStrong,
    };
  }

  @override
  Widget build(BuildContext context) {
    final strength = AuthValidators.getPasswordStrength(password);
    final value = AuthValidators.getStrengthValue(strength);
    final label = AuthValidators.getStrengthLabel(strength);
    final color = _getColor(strength);

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(
                      height: 4,
                      color: isDark
                          ? AuthColors.darkCard
                          : const Color(0xFFE5E7EB),
                    ),
                    AnimatedFractionallySizedBox(
                      duration: AuthDurations.normal,
                      curve: Curves.easeOut,
                      widthFactor: value,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.5),
                                    blurRadius: 6,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: AuthDurations.fast,
              child: Text(
                label,
                key: ValueKey(label),
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildRequirements(strength),
      ],
    );
  }

  Widget _buildRequirements(PasswordStrength strength) {
    final requirements = [
      _Requirement(
        label: '8+ characters',
        met: password.length >= 8,
      ),
      _Requirement(
        label: 'Uppercase letter',
        met: password.contains(RegExp(r'[A-Z]')),
      ),
      _Requirement(
        label: 'Number',
        met: password.contains(RegExp(r'[0-9]')),
      ),
      _Requirement(
        label: 'Special character',
        met: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: requirements
          .map((r) => _RequirementChip(requirement: r, isDark: isDark))
          .toList(),
    );
  }
}

class _Requirement {
  final String label;
  final bool met;
  const _Requirement({required this.label, required this.met});
}

class _RequirementChip extends StatelessWidget {
  final _Requirement requirement;
  final bool isDark;

  const _RequirementChip({required this.requirement, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AuthDurations.normal,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: requirement.met
            ? AuthColors.strengthStrong.withOpacity(0.1)
            : (isDark
                ? AuthColors.darkCard
                : const Color(0xFFF0F0F5)),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: requirement.met
              ? AuthColors.strengthStrong.withOpacity(0.3)
              : (isDark
                  ? AuthColors.darkTextHint.withOpacity(0.2)
                  : const Color(0xFFDDE3EF)),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: AuthDurations.fast,
            child: Icon(
              requirement.met ? Icons.check_circle : Icons.radio_button_unchecked,
              key: ValueKey(requirement.met),
              size: 10,
              color: requirement.met
                  ? AuthColors.strengthStrong
                  : (isDark
                      ? AuthColors.darkTextHint
                      : AuthColors.lightTextHint),
            ),
          ),
          const SizedBox(width: 3),
          Text(
            requirement.label,
            style: TextStyle(
              fontSize: 10,
              color: requirement.met
                  ? AuthColors.strengthStrong
                  : (isDark
                      ? AuthColors.darkTextHint
                      : AuthColors.lightTextHint),
              fontWeight:
                  requirement.met ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
