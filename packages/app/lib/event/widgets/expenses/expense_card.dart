/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/expense_actions.dart';

class ExpenseCard extends StatelessWidget {
  final EventExpense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasProof = expense.proof != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 13,
                      fontVariations: const [FontVariation.weight(650)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_album_rounded,
                        size: 12,
                        color: hasProof
                            ? scheme.secondary
                            : scheme.onPrimary.withValues(alpha: 0.35),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasProof
                            ? 'Avec preuve de paiement'
                            : 'Sans preuve de paiement',
                        style: TextStyle(
                          color: hasProof
                              ? scheme.secondary.withValues(alpha: 0.80)
                              : scheme.onPrimary.withValues(alpha: 0.40),
                          fontSize: 10,
                          fontVariations: const [FontVariation.weight(500)],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${(expense.amount.toDouble() / 100).toStringAsFixed(2)} €',
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
            ExpenseActions(expense: expense),
          ],
        ),
      ),
    );
  }
}
