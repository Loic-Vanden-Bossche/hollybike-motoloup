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
        PopupMenuButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.55),
              shape: BoxShape.circle,
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 16,
              color: scheme.onPrimary.withValues(alpha: 0.65),
            ),
          ),
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
          onTap: () => _onModalActionSelected(
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

  List<PopupMenuItem> _buildBudgetActions(
    BuildContext context,
    ColorScheme scheme,
    int? budget,
    List<EventExpense> expenses,
  ) {
    final hasBudget = budget != null;

    final actions = <PopupMenuItem>[
      hasBudget
          ? PopupMenuItem(
            value: ExpensesModalAction.editBudget,
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 18, color: scheme.onPrimary),
                const SizedBox(width: 8),
                const Text('Modifier le budget'),
              ],
            ),
          )
          : PopupMenuItem(
            value: ExpensesModalAction.addBudget,
            child: Row(
              children: [
                Icon(Icons.savings_outlined, size: 18, color: scheme.onPrimary),
                const SizedBox(width: 8),
                const Text('Ajouter un budget'),
              ],
            ),
          ),
    ];

    if (hasBudget) {
      actions.add(
        PopupMenuItem(
          value: ExpensesModalAction.removeBudget,
          child: Row(
            children: [
              Icon(Icons.remove_circle_outline_rounded, size: 18, color: scheme.error),
              const SizedBox(width: 8),
              Text('Supprimer le budget', style: TextStyle(color: scheme.error)),
            ],
          ),
        ),
      );
    }

    if (expenses.isNotEmpty) {
      actions.add(
        PopupMenuItem(
          value: ExpensesModalAction.downloadCSV,
          child: Row(
            children: [
              Icon(Icons.download_outlined, size: 18, color: scheme.onPrimary),
              const SizedBox(width: 8),
              const Text('Télécharger le CSV'),
            ],
          ),
        ),
      );
    }

    return actions;
  }
}
