/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/event/widgets/expenses/currency_input.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';

class AddExpenseModal extends StatefulWidget {
  final void Function(String name, int amount, String? description)
  onAddExpense;

  const AddExpenseModal({super.key, required this.onAddExpense});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _amountController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassDialog(
      title: 'Ajouter une dépense',
      onClose: () => Navigator.of(context).pop(),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: buildGlassInputDecoration(context, labelText: 'Nom'),
              validator: (value) {
                if (value?.isEmpty == true) return 'Veuillez entrer un nom';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              decoration: buildGlassInputDecoration(
                context,
                labelText: 'Montant',
              ),
              validator: (value) {
                if (value?.isEmpty == true || value == '0,00 €') {
                  return 'Veuillez entrer un montant';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: buildGlassInputDecoration(
                context,
                labelText: 'Description (optionnel)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Cancel
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: scheme.primaryContainer.withValues(alpha: 0.55),
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
        // Confirm
        GestureDetector(
          onTap: _onSubmit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: scheme.secondary.withValues(alpha: 0.15),
              border: Border.all(
                color: scheme.secondary.withValues(alpha: 0.40),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 14, color: scheme.secondary),
                const SizedBox(width: 6),
                Text(
                  'Ajouter',
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

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text;
    final amount = int.parse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final description = _descriptionController.text.isNotEmpty
        ? _descriptionController.text
        : null;

    widget.onAddExpense(name, amount, description);
    Navigator.of(context).pop();
  }
}
