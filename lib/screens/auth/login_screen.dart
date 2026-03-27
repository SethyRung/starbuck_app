import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../router/route_names.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    await context.read<AuthProvider>().signIn(
          _emailController.text,
          _passwordController.text,
        );
    if (mounted) context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(LucideIcons.coffee, color: Colors.white, size: 36),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              Text('Welcome back', style: AppTypography.headingLarge(context))
                  .animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: 8),
              Text('Sign in to your account', style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary))
                  .animate(delay: 150.ms).fadeIn(),
              const SizedBox(height: 40),
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefix: Icon(LucideIcons.mail, color: AppColors.textSecondary, size: 20),
              ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefix: Icon(LucideIcons.lock, color: AppColors.textSecondary, size: 20),
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.labelSmall(context).copyWith(color: AppColors.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton.primary(
                label: 'Sign In',
                isLoading: _isLoading,
                onTap: _isLoading ? null : _signIn,
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or continue with', style: AppTypography.bodySmall(context)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ).animate(delay: 350.ms).fadeIn(),
              const SizedBox(height: 24),
              Row(
                children: [
                  _SocialButton(iconWidget: SvgPicture.asset('assets/icons/apple.svg', width: 20, height: 20), label: 'Apple', onTap: _signIn),
                  const SizedBox(width: 12),
                  _SocialButton(iconWidget: SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20), label: 'Google', onTap: _signIn),
                  const SizedBox(width: 12),
                  _SocialButton(iconWidget: SvgPicture.asset('assets/icons/facebook.svg', width: 20, height: 20), label: 'Facebook', onTap: _signIn),
                ],
              ).animate(delay: 400.ms).fadeIn(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: AppTypography.bodyMedium(context)),
                  GestureDetector(
                    onTap: () => context.push(RouteNames.signup),
                    child: Text(
                      'Sign up',
                      style: AppTypography.labelMedium(context).copyWith(color: AppColors.primaryGreen),
                    ),
                  ),
                ],
              ).animate(delay: 450.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.iconWidget, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 6),
              Text(label, style: AppTypography.labelSmall(context)),
            ],
          ),
        ),
      ),
    );
  }
}
