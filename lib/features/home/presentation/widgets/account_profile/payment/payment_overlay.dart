import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/payment_view_model/payment_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/payment_view_model/payment_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/payment_view_model/payment_state.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

class PaymentOverlay extends StatelessWidget {
  const PaymentOverlay({super.key});

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Center(
          child: Dialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600, maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: BlocProvider(
                  create: (_) => PaymentBloc()..add(FetchPaymentHistory()),
                  child: BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                      Widget content;
                      if (state is PaymentLoading) {
                        content = const Center(child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ));
                      } else if (state is PaymentHistoryLoaded) {
                        final payments = state.payments;
                        if (payments.isEmpty) {
                          content = Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 48),
                              Icon(Icons.receipt_long, size: 56, color: colorScheme.primary.withOpacity(0.3)),
                              const SizedBox(height: 16),
                              Text('No payment history.', style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                              const SizedBox(height: 48),
                            ],
                          );
                        } else {
                          content = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Payment History', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.of(context).pop(),
                                      tooltip: 'Close',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  itemCount: payments.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final payment = payments[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      elevation: 2,
                                      child: ListTile(
                                        leading: Icon(Icons.payments, color: colorScheme.primary, size: 32),
                                        title: Text(
                                          'Order: ${payment.orderId}',
                                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Method: ${payment.paymentMethod}', style: textTheme.bodySmall),
                                            Row(
                                              children: [
                                                Text('Status: ', style: textTheme.bodySmall),
                                                Text(
                                                  payment.paymentStatus,
                                                  style: textTheme.bodySmall?.copyWith(
                                                    color: payment.paymentStatus.toLowerCase() == 'paid'
                                                        ? Colors.green
                                                        : Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (payment.paymentId != null)
                                              Text('ID: ${payment.paymentId}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.5))),
                                            if (payment is PaymentEntity && payment.createdAt != null && payment.createdAt!.isNotEmpty)
                                              Text(_formatDate(payment.createdAt), style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.5))),
                                          ],
                                        ),
                                        trailing: Text(
                                          'Rs. ${payment.amount.toStringAsFixed(2)}',
                                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (state is PaymentFailure) {
                        content = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 48),
                            Icon(Icons.error_outline, size: 56, color: colorScheme.error.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text('Failed to load payments.', style: textTheme.titleMedium?.copyWith(color: colorScheme.error)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                              child: Text(state.error, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)), textAlign: TextAlign.center),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              onPressed: () => context.read<PaymentBloc>().add(FetchPaymentHistory()),
                              style: ElevatedButton.styleFrom(minimumSize: const Size(120, 40)),
                            ),
                            const SizedBox(height: 48),
                          ],
                        );
                      } else {
                        content = const SizedBox.shrink();
                      }
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: content,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 