/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';
import 'package:hollybike/event/widgets/expenses/expense_card.dart';
import 'package:hollybike/event/widgets/expenses/expenses_modal_header.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/shared/widgets/pinned_header_delegate.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../bloc/event_expenses_bloc/event_expenses_bloc.dart';
import '../../bloc/event_expenses_bloc/event_expenses_state.dart';

class ExpensesModal extends StatefulWidget {
  const ExpensesModal({super.key});

  @override
  State<ExpensesModal> createState() => _ExpensesModalState();
}

class _ExpensesModalState extends State<ExpensesModal> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<EventExpensesBloc, EventExpensesState>(
      listener: (context, state) {
        if (state is EventExpensesOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }
        if (state is EventExpensesOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: GlassBottomModal(
        maxContentHeight: 540,
        child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            final eventName = state.eventDetails?.event.name;
            final expenses = state.eventDetails?.expenses;
            final budget = state.eventDetails?.event.budget;
            final totalExpenses = state.eventDetails?.totalExpense;

            if (expenses == null ||
                totalExpenses == null ||
                eventName == null) {
              return const SizedBox.shrink();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row (options + add button)
                ExpensesModalHeader(
                  budget: budget,
                  expenses: expenses,
                  eventName: eventName,
                ),
                const SizedBox(height: 12),

                // Expenses list with pinned budget progress
                Flexible(
                  child: ThemedRefreshIndicator(
                    onRefresh: () => _refreshEventDetails(context),
                    child: CustomScrollView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        // Pinned budget progress header
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: PinnedHeaderDelegate(
                            height: 110,
                            animationDuration: 300,
                            child: Container(
                              color: scheme.primaryContainer,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: scheme.primaryContainer.withValues(
                                    alpha: 0.60,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: scheme.onPrimary.withValues(
                                      alpha: 0.10,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: BudgetProgress(
                                  expenses: expenses,
                                  budget: budget,
                                  totalExpenses: totalExpenses,
                                  animateStart: false,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Expense cards
                        SliverList.builder(
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              builder: (context, double value, child) {
                                return Transform.translate(
                                  offset: Offset(30 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: ExpenseCard(expense: expense),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: expenses.length,
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        ),
                      ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshEventDetails(BuildContext context) {
    context.read<EventDetailsBloc>().add(LoadEventDetails());

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    return context.read<EventDetailsBloc>().firstWhenNotLoading;
  }
}
