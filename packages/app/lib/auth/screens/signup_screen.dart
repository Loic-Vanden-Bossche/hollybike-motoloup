/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';

// Catppuccin blob accent colors — identical to Hud / LoginScreen constants
const _kDarkMauve = Color(0xffcba6f7);
const _kDarkBlue = Color(0xff89b4fa);
const _kDarkPink = Color(0xfff5c2e7);
const _kLightMauve = Color(0xff8839ef);
const _kLightBlue = Color(0xff1e66f5);
const _kLightPink = Color(0xffea76cb);

@RoutePage()
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  // ── Form state ────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // ── Entry animation ───────────────────────────────────────────────────────
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final values = Map<dynamic, dynamic>.from(
        context.routeData.queryParams.rawMap,
      );
      values['username'] = _usernameController.text;
      values['email'] = _emailController.text;
      values['password'] = _passwordController.text;

      BlocProvider.of<AuthBloc>(context).add(
        AuthSignup(
          host: context.routeData.queryParams.getString('host'),
          signupDto: SignupDto.fromMap(values),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final popContext = context.routeData.queryParams.getString('popContext', '');

    final mauve = isDark ? _kDarkMauve : _kLightMauve;
    final blue = isDark ? _kDarkBlue : _kLightBlue;
    final pink = isDark ? _kDarkPink : _kLightPink;

    return Scaffold(
      backgroundColor: scheme.primary,
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is! AuthFailure) {
            if (popContext == 'connected') {
              context.router.maybePop();
            } else if (popContext.isEmpty) {
              context.router.replaceAll([const EventsRoute()]);
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final error = state is AuthFailure ? state.message : null;

            return Stack(
              children: [
                // ── Ambient background blobs ──────────────────────────────
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: h * -0.10,
                            left: w * -0.10,
                            child: IgnorePointer(
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 80,
                                  sigmaY: 80,
                                ),
                                child: Container(
                                  width: w * 0.55,
                                  height: h * 0.55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: mauve.withValues(alpha: 0.14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: w * -0.05,
                            child: IgnorePointer(
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 80,
                                  sigmaY: 80,
                                ),
                                child: Container(
                                  width: w * 0.45,
                                  height: h * 0.45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: blue.withValues(alpha: 0.14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: h * 0.20,
                            right: w * 0.10,
                            child: IgnorePointer(
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 70,
                                  sigmaY: 70,
                                ),
                                child: Container(
                                  width: w * 0.30,
                                  height: h * 0.30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: pink.withValues(alpha: 0.08),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // ── Scrollable content ────────────────────────────────────
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideIn,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 32),
                                  _buildLogo(context),
                                  const SizedBox(height: 36),
                                  _buildCard(context, error),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ── Back button (popContext == connected) ─────────────────
                if (popContext == 'connected')
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => context.router.maybePop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.onPrimary.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: scheme.onPrimary.withValues(alpha: 0.80),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Logo ──────────────────────────────────────────────────────────────────

  Widget _buildLogo(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: scheme.secondary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.30),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.secondary.withValues(alpha: 0.18),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Icons.route_rounded, size: 32, color: scheme.secondary),
        ),
        const SizedBox(height: 16),
        Text(
          'Hollybike',
          style: TextStyle(
            color: scheme.onPrimary,
            fontSize: 30,
            fontVariations: const [FontVariation.weight(800)],
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Créez votre compte',
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.45),
            fontSize: 13,
            fontVariations: const [FontVariation.weight(500)],
          ),
        ),
      ],
    );
  }

  // ── Glass card ────────────────────────────────────────────────────────────

  Widget _buildCard(BuildContext context, String? error) {
    final scheme = Theme.of(context).colorScheme;

    final formContent = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Inscription',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 22,
              fontVariations: const [FontVariation.weight(750)],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Saisissez les informations de votre nouveau compte.',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.50),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(450)],
            ),
          ),
          const SizedBox(height: 24),

          // Error banner
          if (error != null) ...[
            _buildErrorBanner(context, error),
            const SizedBox(height: 16),
          ],

          // Username
          TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.name,
            autofillHints: const [AutofillHints.newUsername],
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofocus: true,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 14,
              fontVariations: const [FontVariation.weight(500)],
            ),
            onEditingComplete: () => _emailFocus.requestFocus(),
            validator: _inputValidator,
            decoration: buildGlassInputDecoration(
              context,
              labelText: "Nom d'utilisateur",
              suffixIcon: Icon(
                Icons.account_circle_rounded,
                size: 17,
                color: scheme.onPrimary.withValues(alpha: 0.30),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Email
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 14,
              fontVariations: const [FontVariation.weight(500)],
            ),
            onEditingComplete: () => _passwordFocus.requestFocus(),
            validator: _emailValidator,
            decoration: buildGlassInputDecoration(
              context,
              labelText: 'Adresse email',
              suffixIcon: Icon(
                Icons.alternate_email_rounded,
                size: 17,
                color: scheme.onPrimary.withValues(alpha: 0.30),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Password
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 14,
              fontVariations: const [FontVariation.weight(500)],
            ),
            onEditingComplete: () => _confirmFocus.requestFocus(),
            validator: _passwordValidator,
            decoration: buildGlassInputDecoration(
              context,
              labelText: 'Mot de passe',
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 17,
                  color: scheme.onPrimary.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Confirm password
          TextFormField(
            controller: _confirmController,
            focusNode: _confirmFocus,
            obscureText: _obscureConfirm,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 14,
              fontVariations: const [FontVariation.weight(500)],
            ),
            onEditingComplete: () => _onSubmit(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ ne peut pas être vide.';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas.';
              }
              return null;
            },
            decoration: buildGlassInputDecoration(
              context,
              labelText: 'Confirmer le mot de passe',
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                child: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 17,
                  color: scheme.onPrimary.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Submit
          _buildSubmitButton(context),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // Base gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.62),
                    scheme.primary.withValues(alpha: 0.48),
                  ],
                ),
              ),
            ),
          ),
          // Teal blob — top-left
          Positioned(
            top: -70,
            left: -50,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.secondary.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ),
          ),
          // Tertiary blob — bottom-right
          Positioned(
            bottom: -60,
            right: -30,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.tertiary.withValues(alpha: 0.14),
                  ),
                ),
              ),
            ),
          ),
          // Backdrop blur + border + content
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: formContent,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error banner ──────────────────────────────────────────────────────────

  Widget _buildErrorBanner(BuildContext context, String error) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.error.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 16,
            color: scheme.error.withValues(alpha: 0.80),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: scheme.error.withValues(alpha: 0.85),
                fontSize: 13,
                fontVariations: const [FontVariation.weight(500)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Submit button ─────────────────────────────────────────────────────────

  Widget _buildSubmitButton(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _onSubmit(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: scheme.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.secondary.withValues(alpha: 0.40),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_rounded, size: 16, color: scheme.secondary),
            const SizedBox(width: 8),
            Text(
              "S'inscrire",
              style: TextStyle(
                color: scheme.secondary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Validators ────────────────────────────────────────────────────────────

  String? _inputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide.';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide.';
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value)) {
      return 'Adresse email invalide.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide.';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères.';
    }
    if (value == value.toLowerCase()) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule.';
    }
    if (value == value.toUpperCase()) {
      return 'Le mot de passe doit contenir au moins une lettre minuscule.';
    }
    if (!value.contains(RegExp(r'\d'))) {
      return 'Le mot de passe doit contenir au moins un chiffre.';
    }
    return null;
  }
}
