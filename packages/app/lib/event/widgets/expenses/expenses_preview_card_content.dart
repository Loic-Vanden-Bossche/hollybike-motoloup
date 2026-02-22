/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';

class ExpensesPreviewCardContent extends StatelessWidget {
  final List<EventExpense> expenses;
  final int? budget;
  final int totalExpenses;
  final void Function() onTap;

  const ExpensesPreviewCardContent({
    super.key,
    required this.expenses,
    required this.budget,
    required this.totalExpenses,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.56),
                    scheme.primary.withValues(alpha: 0.42),
                  ],
                ),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: BudgetProgress(
                expenses: expenses,
                budget: budget,
                totalExpenses: totalExpenses,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
