import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_state.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/widgets/shipping_address/shipping_address_form_page.dart';

class ShippingAddressListPage extends StatelessWidget {
  final String userId;
  final Function(ShippingAddressEntity) onAddressSelected;

  const ShippingAddressListPage({super.key, required this.userId, required this.onAddressSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
        builder: (context, state) {
          if (state is ShippingAddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ShippingAddressLoaded) {
            if (state.addresses.isEmpty) {
              // No addresses, prompt to add new
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => serviceLocator<ShippingAddressBloc>(),
                          child: ShippingAddressFormPage(userId: userId),
                        ),
                      ),
                    );
                  },
                  child: const Text('Add Shipping Address'),
                ),
              );
            }
            return ListView(
              children: [
                ...state.addresses.map((address) => ListTile(
                  title: Text(address.streetAddress),
                  subtitle: Text('${address.city}, ${address.country}'),
                  onTap: () => onAddressSelected(address),
                )),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => serviceLocator<ShippingAddressBloc>(),
                          child: ShippingAddressFormPage(userId: userId),
                        ),
                      ),
                    );
                  },
                  child: const Text('Add New Address'),
                ),
              ],
            );
          } else if (state is ShippingAddressError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 