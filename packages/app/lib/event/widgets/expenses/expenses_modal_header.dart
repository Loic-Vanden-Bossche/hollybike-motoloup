/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_event.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/edit_budget_modal.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';

import 'add_expense_modal.dart';

enum ExpensesModalAction {
  addExpense,
  editBudget,
  addBudget,
  downloadCSV,
  removeBudget,
}

class ExpensesModalHeader extends StatelessWidget {
  final int? budget;
  final List<EventExpense> expenses;
  final String eventName;

  const ExpensesModalHeader({
    super.key,
    this.budget,
    required this.expenses,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Options menu
        GlassPopupMenuButton<ExpensesModalAction>(
          icon: const GlassPopupMenuTriggerIcon(icon: Icons.tune_rounded),
          onSelected: (value) {
            _onModalActionSelected(context, value, budget, eventName);
          },
          itemBuilder: (context) {
            return _buildBudgetActions(context, scheme, budget, expenses);
          },
        ),
        const Spacer(),
        // Add expense button
        GestureDetector(
          onTap:
              () => _onModalActionSelected(
                context,
                ExpensesModalAction.addExpense,
                budget,
                eventName,
              ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                    fontSize: 12,
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

  void _onModalActionSelected(
    BuildContext context,
    ExpensesModalAction action,
    int? budget,
    String eventName,
  ) {
    switch (action) {
      case ExpensesModalAction.addExpense:
        showDialog(
          context: context,
          builder: (_) {
            return AddExpenseModal(
              onAddExpense: (name, amount, description) {
                context.read<EventExpensesBloc>().add(
                  AddExpense(
                    name: name,
                    amount: amount,
                    description: description,
                  ),
                );
              },
            );
          },
        );
        break;
      case ExpensesModalAction.addBudget:
        showDialog(
          context: context,
          builder: (_) {
            return EditBudgetModal(
              onBudgetChange: (budget) {
                context.read<EventExpensesBloc>().add(
                  EditBudget(budget: budget, successMessage: 'Budget ajouté.'),
                );
              },
              addMode: true,
            );
          },
        );
        break;
      case ExpensesModalAction.removeBudget:
        context.read<EventExpensesBloc>().add(
          EditBudget(budget: null, successMessage: 'Budget supprimé.'),
        );
        break;
      case ExpensesModalAction.editBudget:
        showDialog(
          context: context,
          builder: (_) {
            return EditBudgetModal(
              budget: budget,
              onBudgetChange: (budget) {
                context.read<EventExpensesBloc>().add(
                  EditBudget(budget: budget, successMessage: 'Budget modifié.'),
                );
              },
            );
          },
        );
        break;
      case ExpensesModalAction.downloadCSV:
        context.read<EventExpensesBloc>().add(DownloadReport());
        break;
    }
  }

  List<PopupMenuItem<ExpensesModalAction>> _buildBudgetActions(
    BuildContext context,
    ColorScheme scheme,
    int? budget,
    List<EventExpense> expenses,
  ) {
    final hasBudget = budget != null;

    final actions = <PopupMenuItem<ExpensesModalAction>>[
      hasBudget
          ? glassPopupMenuItem(
            value: ExpensesModalAction.editBudget,
            icon: Icons.edit_outlined,
            label: 'Modifier le budget',
          )
          : glassPopupMenuItem(
            value: ExpensesModalAction.addBudget,
            icon: Icons.savings_outlined,
            label: 'Ajouter un budget',
          ),
    ];

    if (hasBudget) {
      actions.add(
        glassPopupMenuItem(
          value: ExpensesModalAction.removeBudget,
          icon: Icons.remove_circle_outline_rounded,
          label: 'Supprimer le budget',
          color: scheme.error,
        ),
      );
    }

    if (expenses.isNotEmpty) {
      actions.add(
        glassPopupMenuItem(
          value: ExpensesModalAction.downloadCSV,
          icon: Icons.download_outlined,
          label: 'Télécharger le CSV',
        ),
      );
    }

    return actions;
  }
}
