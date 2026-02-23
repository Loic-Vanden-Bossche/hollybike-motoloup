/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/widgets/forgot_password_modal.dart';
import 'package:hollybike/auth/widgets/signup_link_dialog.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Catppuccin blob accent colors — identical to Hud constants
const _kDarkMauve = Color(0xffcba6f7);
const _kDarkBlue = Color(0xff89b4fa);
const _kDarkPink = Color(0xfff5c2e7);
const _kLightMauve = Color(0xff8839ef);
const _kLightBlue = Color(0xff1e66f5);
const _kLightPink = Color(0xffea76cb);

@RoutePage()
class LoginScreen extends StatefulWidget {
  final Function() onAuthSuccess;
  final bool canPop;

  const LoginScreen({
    super.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── Saved defaults ────────────────────────────────────────────────────────
  static const String _defaultHost = "api.hollybike.chbrx.com";
  static const String _lastHostKey = "last-login-host";
  static const String _lastEmailKey = "last-login-email";

  String? _pendingHost;
  String? _pendingEmail;

  // ── Form state ────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hostController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  bool _obscurePassword = true;

  // ── Entry animation ───────────────────────────────────────────────────────
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: _defaultHost);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();

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

    _loadSavedLoginDefaults();
    _animController.forward();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLoginDefaults() async {
    final preferences = await SharedPreferences.getInstance();
    final host = preferences.getString(_lastHostKey);
    final email = preferences.getString(_lastEmailKey);

    if (!mounted) return;
    setState(() {
      _hostController.text = host?.isNotEmpty == true ? host! : _defaultHost;
      _emailController.text = email ?? "";
    });
  }

  Future<void> _saveLoginDefaults() async {
    final pendingHost = _pendingHost;
    final pendingEmail = _pendingEmail;
    if (pendingHost == null || pendingEmail == null) return;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_lastHostKey, pendingHost);
    await preferences.setString(_lastEmailKey, pendingEmail);
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _pendingHost = _hostController.text;
      _pendingEmail = _emailController.text;

      BlocProvider.of<AuthBloc>(context).add(
        AuthLogin(
          host: _formatHostFromInput(_pendingHost!),
          loginDto: LoginDto(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  String _formatHostFromInput(String input) {
    if (kReleaseMode && input.startsWith("http://")) {
      return input.replaceFirst("http://", "https://");
    }
    if (!input.startsWith("http")) {
      if (!kReleaseMode &&
          RegExp(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}").hasMatch(input)) {
        return "http://$input";
      }
      return "https://$input";
    }
    return input;
  }

  String? _inputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mauve = isDark ? _kDarkMauve : _kLightMauve;
    final blue = isDark ? _kDarkBlue : _kLightBlue;
    final pink = isDark ? _kDarkPink : _kLightPink;

    return Scaffold(
      backgroundColor: scheme.primary,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthConnected) {
            _saveLoginDefaults();
            widget.onAuthSuccess();
            if (widget.canPop) {
              context.router.maybePop();
            }
          }
        },
        builder: (context, state) {
          // No dedicated loading state in AuthBloc — button stays active
          const isLoading = false;
          final error = state is AuthFailure ? state.message : null;

          return Stack(
            children: [
              // ── Ambient background blobs (same pattern as Hud) ─────────────
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

              // ── Scrollable content ────────────────────────────────────────
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
                            // constraints.maxHeight shrinks when the keyboard
                            // appears (Scaffold resizeToAvoidBottomInset:true),
                            // so the column naturally scrolls to keep form visible
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 32),
                                _buildLogo(context),
                                const SizedBox(height: 36),
                                _buildCard(context, isLoading, error),
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

              // ── canPop back button ────────────────────────────────────────
              if (widget.canPop)
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
    );
  }

  // ── Logo area ─────────────────────────────────────────────────────────────

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
          'Plateforme de groupe moto',
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

  Widget _buildCard(BuildContext context, bool isLoading, String? error) {
    final scheme = Theme.of(context).colorScheme;

    // Form content extracted to keep nesting readable
    final formContent = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Text(
            'Connexion',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 22,
              fontVariations: const [FontVariation.weight(750)],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Entrez vos identifiants pour accéder à la plateforme.',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.50),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(450)],
            ),
          ),
          const SizedBox(height: 24),

          // ── Error banner ──────────────────────────────────────────────────
          if (error != null) ...[
            _buildErrorBanner(context, error),
            const SizedBox(height: 16),
          ],

          // ── Server field ──────────────────────────────────────────────────
          TextFormField(
            controller: _hostController,
            keyboardType: TextInputType.url,
            autofillHints: const [AutofillHints.url],
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 14,
              fontVariations: const [FontVariation.weight(500)],
            ),
            onEditingComplete: () => _emailFocus.requestFocus(),
            validator: _inputValidator,
            decoration: buildGlassInputDecoration(
              context,
              labelText: 'Adresse du serveur',
              suffixIcon: Icon(
                Icons.dns_rounded,
                size: 17,
                color: scheme.onPrimary.withValues(alpha: 0.30),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Email field ───────────────────────────────────────────────────
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
            validator: _inputValidator,
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

          // ── Password field ────────────────────────────────────────────────
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.password],
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 14,
              fontVariations: const [FontVariation.weight(500)],
            ),
            onEditingComplete: isLoading ? null : _onSubmit,
            validator: _inputValidator,
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
          const SizedBox(height: 8),

          // ── Forgot password ───────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _showForgotPasswordModal(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    color: scheme.secondary,
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(600)],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Submit button ─────────────────────────────────────────────────
          _buildSubmitButton(context, isLoading),
          const SizedBox(height: 20),

          // ── Sign-up row ───────────────────────────────────────────────────
          _buildSignupRow(context),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // Base gradient fill
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
          // Teal blob — top-left (clipped by ClipRRect, bleeds into blur)
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
          // BackdropFilter blurs everything below (gradient + blobs)
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

  Widget _buildSubmitButton(BuildContext context, bool isLoading) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: isLoading ? null : _onSubmit,
      child: AnimatedOpacity(
        opacity: isLoading ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 200),
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
          child:
              isLoading
                  ? Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: scheme.secondary,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 16,
                        color: scheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Se connecter',
                        style: TextStyle(
                          color: scheme.secondary,
                          fontSize: 14,
                          fontVariations: const [FontVariation.weight(700)],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  // ── Sign-up row ───────────────────────────────────────────────────────────

  Widget _buildSignupRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pas encore de compte ? ",
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.45),
            fontSize: 13,
            fontVariations: const [FontVariation.weight(450)],
          ),
        ),
        GestureDetector(
          onTap: () => _signupLinkDialogBuilder(context),
          child: Text(
            "S'inscrire",
            style: TextStyle(
              color: scheme.secondary,
              fontSize: 13,
              fontVariations: const [FontVariation.weight(650)],
            ),
          ),
        ),
      ],
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showForgotPasswordModal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder:
          (_) => ForgotPasswordModal(
            formatHostFromInput: _formatHostFromInput,
          ),
    );
  }

  Future<void> _signupLinkDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (BuildContext context) => SignupLinkDialog(canPop: widget.canPop),
    );
  }
}
