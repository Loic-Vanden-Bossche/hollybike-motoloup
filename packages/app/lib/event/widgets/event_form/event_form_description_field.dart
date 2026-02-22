/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'package:flutter/material.dart';

import '../../../ui/widgets/inputs/glass_input_decoration.dart';

class EventFormDescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;

  const EventFormDescriptionField({
    super.key,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: descriptionController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.length > 1000) {
          return "La description ne peut pas dépasser 1000 caractères";
        }

        return null;
      },
      style: TextStyle(color: scheme.onPrimary),
      decoration: buildGlassInputDecoration(
        context,
        labelText: 'Description (optionnel)',
        suffixIcon: Icon(
          Icons.description_outlined,
          color: scheme.onPrimary.withValues(alpha: 0.62),
          size: 18,
        ),
      ),
    );
  }
}
