/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/widgets/forgot_password_modal.dart';
import 'package:hollybike/auth/widgets/form_builder.dart';
import 'package:hollybike/auth/widgets/signup_link_dialog.dart';
import 'package:hollybike/shared/widgets/dialog/banner_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types/form_field_config.dart';

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

class _LoginScreenState extends State<LoginScreen> {
  static const String _defaultHost = "api.hollybike.chbrx.com";
  static const String _lastHostKey = "last-login-host";
  static const String _lastEmailKey = "last-login-email";

  String _lastHost = _defaultHost;
  String _lastEmail = "";
  String? _pendingHost;
  String? _pendingEmail;

  @override
  void initState() {
    super.initState();
    _loadSavedLoginDefaults();
  }

  Future<void> _loadSavedLoginDefaults() async {
    final preferences = await SharedPreferences.getInstance();
    final host = preferences.getString(_lastHostKey);
    final email = preferences.getString(_lastEmailKey);

    if (!mounted) return;
    setState(() {
      _lastHost = host?.isNotEmpty == true ? host! : _defaultHost;
      _lastEmail = email ?? "";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          widget.canPop
              ? FloatingActionButton.small(
                onPressed: () => context.router.maybePop(),
                child: const Icon(Icons.arrow_back),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
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
          final error = state is AuthFailure ? state.message : null;

          return BannerDialog(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilder(
                  key: ValueKey("$_lastHost|$_lastEmail"),
                  title: "Bienvenue!",
                  description: "Entrez vos identifiants pour vous connecter.",
                  errorText: error,
                  formTexts: FormTexts(
                    submit: "Se connecter",
                    link: (
                      description: "Vous n'avez pas encore de compte ?",
                      buttonText: "Inscrivez-vous",
                      onDestinationClick:
                          () => _signupLinkDialogBuilder(context),
                    ),
                  ),
                  onFormSubmit: (formValue) {
                    _pendingHost = formValue["host"] as String;
                    _pendingEmail = formValue["email"] as String;

                    BlocProvider.of<AuthBloc>(context).add(
                      AuthLogin(
                        host: _formatHostFromInput(_pendingHost!),
                        loginDto: LoginDto.fromMap(formValue),
                      ),
                    );
                  },
                  formFields: {
                    "host": FormFieldConfig(
                      label: "Adresse du serveur",
                      validator: _inputValidator,
                      defaultValue: _lastHost,
                      autofillHints: [AutofillHints.url],
                      textInputType: TextInputType.url,
                    ),
                    "email": FormFieldConfig(
                      label: "Adresse email",
                      validator: _inputValidator,
                      defaultValue: _lastEmail,
                      autofocus: true,
                      autofillHints: [AutofillHints.email],
                      textInputType: TextInputType.emailAddress,
                    ),
                    "password": FormFieldConfig(
                      label: "Mot de passe",
                      validator: _inputValidator,
                      isSecured: true,
                      autofillHints: [AutofillHints.password],
                    ),
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ForgotPasswordModal(
                            formatHostFromInput: _formatHostFromInput,
                          ),
                    );
                  },
                  child: Text(
                    "Mot de passe oublie ? Reinitialiser",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas etre vide.";
    }
    return null;
  }

  Future<void> _signupLinkDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (BuildContext context) => SignupLinkDialog(canPop: widget.canPop),
    );
  }
}
