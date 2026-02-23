/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';
import 'package:native_qr/native_qr.dart';

import '../../shared/utils/is_valid_signup_link.dart';

class SignupLinkDialog extends StatefulWidget {
  final bool canPop;

  const SignupLinkDialog({super.key, required this.canPop});

  @override
  State<SignupLinkDialog> createState() => _SignupLinkDialogState();
}

class _SignupLinkDialogState extends State<SignupLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();

  bool get isValid => _formKey.currentState?.validate() == true;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassDialog(
      title: "Lien d'inscription",
      onClose: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saisissez le lien d'invitation reçu par email ou scannez le QR code associé.",
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.55),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(450)],
            ),
          ),
          const SizedBox(height: 20),

          // Invitation link field
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _linkController,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onEditingComplete: _handleSubmit,
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(500)],
              ),
              validator: _validateInvitationLink,
              decoration: buildGlassInputDecoration(
                context,
                labelText: "Lien d'invitation",
                suffixIcon: Icon(
                  Icons.link_rounded,
                  size: 17,
                  color: scheme.onPrimary.withValues(alpha: 0.30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // "ou" divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'ou',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.35),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(500)],
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // QR code scan row
          GestureDetector(
            onTap: _onScanQrCode,
            child: Container(
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.60),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: scheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: scheme.secondary.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 16,
                      color: scheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scanner un QR code',
                      style: TextStyle(
                        color: scheme.onPrimary.withValues(alpha: 0.80),
                        fontSize: 14,
                        fontVariations: const [FontVariation.weight(550)],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: scheme.onPrimary.withValues(alpha: 0.30),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Cancel — ghost pill
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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
        // Confirm — teal pill
        GestureDetector(
          onTap: _handleSubmit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: scheme.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: scheme.secondary.withValues(alpha: 0.40),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded, size: 14, color: scheme.secondary),
                const SizedBox(width: 6),
                Text(
                  'Confirmer',
                  style: TextStyle(
                    color: scheme.secondary,
                    fontSize: 13,
                    fontVariations: const [FontVariation.weight(650)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onScanQrCode() async {
    final result = await NativeQr().get();
    if (result != null) {
      _handleUrlFound(result);
    }
  }

  void _handleUrlFound(String url) {
    _linkController.text = url;
    HapticFeedback.lightImpact();
    _handleSubmit();
  }

  void _handleSubmit() {
    if (isValid) {
      widget.canPop
          ? context.router.replacePath(
            "${_linkController.text}&popContext=connected",
          )
          : context.router.pushPath(
            "${_linkController.text}&popContext=guard",
          );
    }
  }

  static String? _validateInvitationLink(String? link) {
    if (link == null || link.isEmpty) {
      return "Vous devez saisir un lien d'invitation";
    }
    if (!isValidSignupLink(link)) {
      return "Ce lien d'invitation n'est pas valide";
    }
    return null;
  }
}
