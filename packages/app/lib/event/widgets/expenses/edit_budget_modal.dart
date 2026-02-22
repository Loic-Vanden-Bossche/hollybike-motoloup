/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/event/widgets/expenses/currency_input.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';

class EditBudgetModal extends StatefulWidget {
  final bool addMode;
  final int? budget;

  final void Function(int budget) onBudgetChange;

  const EditBudgetModal({
    super.key,
    required this.onBudgetChange,
    this.addMode = false,
    this.budget,
  });

  @override
  State<EditBudgetModal> createState() => _EditBudgetModalState();
}

class _EditBudgetModalState extends State<EditBudgetModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(text: _getDefaultBudget());
  }

  String _getDefaultBudget() {
    if (widget.addMode || widget.budget == null) {
      return '';
    }
    final correctedBudget = widget.budget! * 100;
    return CurrencyInputFormatter.defaultFormat(correctedBudget.toString());
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = widget.addMode ? 'Ajouter un budget' : 'Modifier le budget';
    final confirmLabel = widget.addMode ? 'Ajouter' : 'Modifier';

    return GlassDialog(
      title: label,
      onClose: () => Navigator.of(context).pop(),
      body: Form(
        key: _formKey,
        child: TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
          decoration: buildGlassInputDecoration(
            context,
            labelText: 'Budget',
          ),
          validator: (value) {
            if (value?.isEmpty == true || value == '0,00 €') {
              return 'Veuillez entrer un budget';
            }
            return null;
          },
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
                Icon(
                  widget.addMode ? Icons.add_rounded : Icons.check_rounded,
                  size: 14,
                  color: scheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  confirmLabel,
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

    final budget = int.parse(
      _budgetController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    widget.onBudgetChange((budget / 100).round());
    Navigator.of(context).pop();
  }
}
