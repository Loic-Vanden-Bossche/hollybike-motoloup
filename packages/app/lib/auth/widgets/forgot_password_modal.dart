import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';

class ForgotPasswordModal extends StatefulWidget {
  final String Function(String) formatHostFromInput;

  const ForgotPasswordModal({super.key, required this.formatHostFromInput});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hostController;
  late final TextEditingController _emailController;
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: 'api.hollybike.chbrx.com');
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext blocContext) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<EditProfileBloc>(blocContext).add(
        ResetPassword(
          email: _emailController.text,
          host: widget.formatHostFromInput(_hostController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => EditProfileBloc(
            profileRepository: RepositoryProvider.of<ProfileRepository>(
              context,
            ),
          ),
      child: Builder(
        builder: (blocContext) {
          return BlocConsumer<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                Toast.showSuccessToast(
                  context,
                  "Un email de réinitialisation vous a été envoyé.",
                );
                Navigator.of(context).pop();
              }
              if (state is ResetPasswordFailure) {
                Toast.showErrorToast(context, state.errorMessage);
              }
              if (state is ResetPasswordNotAvailable) {
                Toast.showErrorToast(
                  context,
                  "La réinitialisation de mot de passe n'est pas disponible, veuillez contacter votre administrateur.",
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ResetPasswordInProgress;
              final scheme = Theme.of(context).colorScheme;

              return GlassDialog(
                title: 'Mot de passe oublié',
                onClose: () => Navigator.of(context).pop(),
                body: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entrez votre adresse email pour recevoir un lien de réinitialisation.',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.55),
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(450)],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Server field
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

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 14,
                          fontVariations: const [FontVariation.weight(500)],
                        ),
                        onEditingComplete:
                            isLoading ? null : () => _onSubmit(blocContext),
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
                    ],
                  ),
                ),
                actions: [
                  // Cancel — ghost pill
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: scheme.onPrimary.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.65),
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(600)],
                        ),
                      ),
                    ),
                  ),
                  // Submit — teal pill with inline loading
                  GestureDetector(
                    onTap: isLoading ? null : () => _onSubmit(blocContext),
                    child: AnimatedOpacity(
                      opacity: isLoading ? 0.6 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: scheme.secondary.withValues(alpha: 0.40),
                            width: 1,
                          ),
                        ),
                        child:
                            isLoading
                                ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    color: scheme.secondary,
                                    strokeWidth: 1.8,
                                  ),
                                )
                                : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.send_rounded,
                                      size: 14,
                                      color: scheme.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Envoyer',
                                      style: TextStyle(
                                        color: scheme.secondary,
                                        fontSize: 13,
                                        fontVariations: const [
                                          FontVariation.weight(650),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    return null;
  }

  String? _emailValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(inputText)) {
      return "Adresse email invalide.";
    }
    return null;
  }
}
