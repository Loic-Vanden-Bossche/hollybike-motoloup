/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/proof_view_modal.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';

import '../../bloc/event_expenses_bloc/event_expenses_event.dart';
import 'expenses_image_picker_modal.dart';

enum ExpenseAction { delete, addProof, seeProof }

class ExpenseActions extends StatelessWidget {
  final EventExpense expense;

  const ExpenseActions({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return GlassPopupMenuButton<ExpenseAction>(
      onSelected: (value) => _onSelected(context, value),
      itemBuilder: (context) {
        return _buildExpenseActions(expense);
      },
    );
  }

  List<PopupMenuItem<ExpenseAction>> _buildExpenseActions(
    EventExpense expense,
  ) {
    final actions = <PopupMenuItem<ExpenseAction>>[];

    if (expense.proof != null) {
      actions.add(
        glassPopupMenuItem(
          value: ExpenseAction.seeProof,
          icon: Icons.photo_album_rounded,
          label: 'Voir la preuve de paiement',
        ),
      );
    }

    actions.addAll([
      glassPopupMenuItem(
        value: ExpenseAction.addProof,
        icon: Icons.photo_album_rounded,
        label:
            expense.proof == null
                ? 'Ajouter une preuve de paiement'
                : 'Modifier la preuve de paiement',
      ),
      glassPopupMenuItem(
        value: ExpenseAction.delete,
        icon: Icons.delete,
        label: 'Supprimer',
      ),
    ]);

    return actions;
  }

  void _onSelected(BuildContext context, ExpenseAction value) {
    switch (value) {
      case ExpenseAction.delete:
        _onDelete(context);
        break;
      case ExpenseAction.addProof:
        _onAddProof(context);
        break;
      case ExpenseAction.seeProof:
        _onSeeProof(context);
        break;
    }
  }

  void _onDelete(BuildContext context) {
    context.read<EventExpensesBloc>().add(DeleteExpense(expenseId: expense.id));
  }

  void _onAddProof(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<EventExpensesBloc>(),
          child: ExpensesImagePickerModal(
            expenseId: expense.id,
            isEditingExpense: expense.proof != null,
          ),
        );
      },
    );
  }

  void _onSeeProof(BuildContext context) {
    if (expense.proof == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return ProofViewModal(expenseId: expense.id, proof: expense.proof!);
      },
    );
  }
}
