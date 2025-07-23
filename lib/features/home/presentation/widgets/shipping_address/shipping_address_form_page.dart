import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_state.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/presentation/widgets/dashboard_header/modern_app_bar.dart';

class ShippingAddressFormPage extends StatefulWidget {
  final String userId;
  const ShippingAddressFormPage({super.key, required this.userId});

  @override
  State<ShippingAddressFormPage> createState() => _ShippingAddressFormPageState();
}

class _ShippingAddressFormPageState extends State<ShippingAddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  String street = '', city = '', country = 'Nepal', postal = '', district = '', province = 'Bagmati';
  bool _isLoading = false;

  final List<String> _countries = ['Nepal', 'India', 'China'];
  final List<String> _provinces = [
    'Bagmati', 'Gandaki', 'Lumbini', 'Karnali', 'Sudurpashchim', 'Province 1', 'Madhesh'
  ];

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _closeDialogIfOpen() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ShippingAddressBloc, ShippingAddressState>(
      listener: (context, state) {
        if (state is ShippingAddressLoading) {
          setState(() => _isLoading = true);
          _showLoadingDialog();
        } else if (state is ShippingAddressLoaded) {
          setState(() => _isLoading = false);
          _closeDialogIfOpen();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Address added successfully!'),
              backgroundColor: theme.colorScheme.secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ShippingAddressError) {
          setState(() => _isLoading = false);
          _closeDialogIfOpen();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const ModernAppBar(
          title: 'Add Shipping Address',
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.location_on_outlined, color: Colors.white),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Shipping Details',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Street',
                            prefixIcon: const Icon(Icons.home_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onSaved: (v) => street = v ?? '',
                          validator: (v) => v!.isEmpty ? 'Street is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            prefixIcon: const Icon(Icons.location_city_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onSaved: (v) => city = v ?? '',
                          validator: (v) => v!.isEmpty ? 'City is required' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: country,
                          items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) => setState(() => country = v ?? 'Nepal'),
                          decoration: InputDecoration(
                            labelText: 'Country',
                            prefixIcon: const Icon(Icons.flag_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Postal Code',
                            prefixIcon: const Icon(Icons.local_post_office_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (v) => postal = v ?? '',
                          validator: (v) => v!.isEmpty ? 'Postal code is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'District',
                            prefixIcon: const Icon(Icons.map_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onSaved: (v) => district = v ?? '',
                          validator: (v) => v!.isEmpty ? 'District is required' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: province,
                          items: _provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                          onChanged: (v) => setState(() => province = v ?? 'Bagmati'),
                          decoration: InputDecoration(
                            labelText: 'Province',
                            prefixIcon: const Icon(Icons.place_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () {
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
                                    }
                                  },
                            child: _isLoading
                                ? const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                                  )
                                : const Text('Save Address'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 