/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'package:flutter/material.dart';

import '../../../ui/widgets/inputs/glass_input_decoration.dart';

class EventFormNameField extends StatelessWidget {
  final TextEditingController nameController;

  const EventFormNameField({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: nameController,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Veuillez entrer un nom pour l'évènement";
        }

        if (value.length < 3) {
          return "Le nom de l'évènement doit contenir au moins 3 caractères";
        }

        if (value.length > 100) {
          return "Le nom de l'évènement ne peut pas dépasser 100 caractères";
        }

        return null;
      },
      style: TextStyle(color: scheme.onPrimary),
      decoration: buildGlassInputDecoration(
        context,
        labelText: "Nom de l'évènement",
      ),
    );
  }
}
