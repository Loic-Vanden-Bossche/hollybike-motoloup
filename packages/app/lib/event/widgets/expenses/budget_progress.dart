/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/shared/widgets/gradient_progress_bar.dart';

class BudgetProgress extends StatelessWidget {
  final List<EventExpense> expenses;
  final int? budget;
  final int totalExpenses;
  final bool animateStart;

  const BudgetProgress({
    super.key,
    required this.expenses,
    required this.budget,
    required this.totalExpenses,
    this.animateStart = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final expensesInEuro = totalExpenses.toDouble() / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Header row: label + budget cap ──────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _expensesLabel(),
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.50),
                fontSize: 9,
                fontVariations: const [FontVariation.weight(700)],
                letterSpacing: 1.2,
              ),
            ),
            _buildBudgetCap(context, scheme),
          ],
        ),
        const SizedBox(height: 6),
        // ── Hero amount ──────────────────────────────────────────────
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: expensesInEuro.toStringAsFixed(2),
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 22,
                  fontVariations: const [FontVariation.weight(750)],
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: ' €',
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.55),
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(600)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // ── Progress bar ─────────────────────────────────────────────
        GradientProgressBar(
          animateStart: animateStart,
          maxValue: budget?.toDouble() ?? 1,
          value: budget == null ? 0 : expensesInEuro,
          colors: [
            Colors.green.shade400,
            Colors.yellow.shade400,
            Colors.red.shade400,
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCap(BuildContext context, ColorScheme scheme) {
    if (budget == null) {
      return Text(
        'Sans limite',
        style: TextStyle(
          color: scheme.onPrimary.withValues(alpha: 0.38),
          fontSize: 9,
          fontVariations: const [FontVariation.weight(600)],
          letterSpacing: 0.5,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Budget: ',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.45),
              fontSize: 9,
              fontVariations: const [FontVariation.weight(600)],
            ),
          ),
          TextSpan(
            text: '${budget?.toStringAsFixed(2)} €',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.75),
              fontSize: 9,
              fontVariations: const [FontVariation.weight(700)],
            ),
          ),
        ],
      ),
    );
  }

  String _expensesLabel() {
    if (expenses.isEmpty) return 'AUCUNE DÉPENSE';
    if (expenses.length == 1) return '1 DÉPENSE';
    return '${expenses.length} DÉPENSES';
  }
}
