import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/checkout/checkout_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_bloc.dart';
import 'package:sparexpress/features/home/presentation/widgets/shipping_address/shipping_address_list_page.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/shipping_address/shipping_address_form_page.dart';


class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.shade300)],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard, color: Colors.orange),
                const SizedBox(width: 10),
                const Expanded(child: Text("Add voucher code")),
                Text("Total: \$${state.total.toStringAsFixed(2)}"),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Get cart items and total from state
                    final cartState = context.read<CartBloc>().state;
                    if (cartState is! CartLoaded || cartState.items.isEmpty) return;
                    final cartItems = cartState.items;
                    // For now, just use the first item for demo (single product checkout)
                    // TODO: For multi-product checkout, pass all items to a new checkout flow
                    final profileBloc = BlocProvider.of<ProfileBloc>(context);
                    final shippingAddressBloc = serviceLocator<ShippingAddressBloc>();
                    String userId = cartItems.first.userId;
                    shippingAddressBloc.add(FetchAddresses(userId));
                    final address = await showModalBottomSheet<ShippingAddressEntity>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (sheetContext) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.8,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          expand: false,
                          builder: (context, scrollController) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 16,
                                    offset: Offset(0, -4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Drag handle
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                                    child: Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text('Select Shipping Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            SizedBox(height: 2),
                                            Text('Choose where to deliver your order', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.grey, size: 26),
                                          onPressed: () => Navigator.of(sheetContext).pop(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  Expanded(
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(value: profileBloc),
                                        BlocProvider.value(value: shippingAddressBloc),
                                      ],
                                      child: BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
                                        builder: (context, state) {
                                          if (state is ShippingAddressLoading) {
                                            return const Center(child: CircularProgressIndicator());
                                          } else if (state is ShippingAddressLoaded) {
                                            if (state.addresses.isEmpty) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text('No addresses found.', style: TextStyle(fontSize: 16)),
                                                      const SizedBox(height: 16),
                                                      ElevatedButton.icon(
                                                        icon: const Icon(Icons.add_location_alt),
                                                        style: ElevatedButton.styleFrom(
                                                          foregroundColor: Colors.white,
                                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            sheetContext,
                                                            MaterialPageRoute(
                                                              builder: (_) => BlocProvider(
                                                                create: (_) => serviceLocator<ShippingAddressBloc>(),
                                                                child: ShippingAddressFormPage(userId: userId),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        label: const Text('Add New Address', style: TextStyle(fontSize: 16)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return ListView.separated(
                                              controller: scrollController,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              itemCount: state.addresses.length + 1,
                                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                                              itemBuilder: (context, index) {
                                                if (index == state.addresses.length) {
                                                  // Add New Address button at the end
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: ElevatedButton.icon(
                                                      icon: const Icon(Icons.add_location_alt),
                                                      style: ElevatedButton.styleFrom(
                                                        foregroundColor: Colors.white,
                                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          sheetContext,
                                                          MaterialPageRoute(
                                                            builder: (_) => BlocProvider(
                                                              create: (_) => serviceLocator<ShippingAddressBloc>(),
                                                              child: ShippingAddressFormPage(userId: userId),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      label: const Text('Add New Address', style: TextStyle(fontSize: 16)),
                                                    ),
                                                  );
                                                }
                                                final address = state.addresses[index];
                                                return Card(
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                '${address.streetAddress}, ${address.city}',
                                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(sheetContext).pop(address);
                                                              },
                                                              style: OutlinedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                                foregroundColor: Theme.of(context).colorScheme.primary,
                                                                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                                                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                              ),
                                                              child: const Text('Select'),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 6),
                                                        Text('${address.district}, ${address.province}, ${address.country}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                                        const SizedBox(height: 2),
                                                        Text('Postal Code: ${address.postalCode}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (state is ShippingAddressError) {
                                            // Show dialog asking user to add shipping address first
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              showDialog(
                                                context: sheetContext,
                                                barrierDismissible: false,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Shipping Address Required'),
                                                  content: const Text('Please add a shipping address before proceeding with checkout.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(); // Close dialog
                                                        Navigator.of(sheetContext).pop(); // Close bottom sheet
                                                      },
                                                      child: const Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(); // Close dialog
                                                        Navigator.push(
                                                          sheetContext,
                                                          MaterialPageRoute(
                                                            builder: (_) => BlocProvider(
                                                              create: (_) => serviceLocator<ShippingAddressBloc>(),
                                                              child: ShippingAddressFormPage(userId: userId),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text('Add Address'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                            return const SizedBox.shrink(); // Return empty widget since dialog will show
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                    if (address != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => serviceLocator<CheckoutBloc>(),
                            child: CheckoutPage(
                              userId: userId,
                              cartItems: cartItems,
                              shippingAddressId: address.id!,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Check Out"),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
