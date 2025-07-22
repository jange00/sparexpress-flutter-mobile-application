import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_event.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

class ShippingAddressFormPage extends StatefulWidget {
  final String userId;
  const ShippingAddressFormPage({super.key, required this.userId});

  @override
  State<ShippingAddressFormPage> createState() => _ShippingAddressFormPageState();
}

class _ShippingAddressFormPageState extends State<ShippingAddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  String street = '', city = '', country = '', postal = '', district = '', province = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Shipping Address')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Street'), onSaved: (v) => street = v ?? '', validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(decoration: const InputDecoration(labelText: 'City'), onSaved: (v) => city = v ?? '', validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(decoration: const InputDecoration(labelText: 'Country'), onSaved: (v) => country = v ?? '', validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(decoration: const InputDecoration(labelText: 'Postal Code'), onSaved: (v) => postal = v ?? '', validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(decoration: const InputDecoration(labelText: 'District'), onSaved: (v) => district = v ?? '', validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(decoration: const InputDecoration(labelText: 'Province'), onSaved: (v) => province = v ?? '', validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final address = ShippingAddressEntity(
                      userId: widget.userId,
                      streetAddress: street,
                      city: city,
                      country: country,
                      postalCode: postal,
                      district: district,
                      province: province,
                    );
                    context.read<ShippingAddressBloc>().add(AddAddress(address));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 