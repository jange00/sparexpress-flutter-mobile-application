import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_detail/product_detail_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_detail/product_detail_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_detail/product_detail_state.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/cart_view.dart';
import 'dart:math';
import 'package:shimmer/shimmer.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/shipping_address/shipping_address_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/shipping_address/shipping_address_list_page.dart';
import 'package:sparexpress/features/home/presentation/widgets/checkout/checkout_page.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_bloc.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';


class ProductDetailView extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailBloc(product),
      child: const ProductDetailViewBody(),
    );
  }
}

class ProductDetailViewBody extends StatefulWidget {
  const ProductDetailViewBody({Key? key}) : super(key: key);

  @override
  State<ProductDetailViewBody> createState() => _ProductDetailViewBodyState();
}

class _ProductDetailViewBodyState extends State<ProductDetailViewBody> {
  int _selectedImage = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailBloc, ProductDetailState>(
      listener: (context, state) {
        if (state.error != null) {
          final isAlreadyInCart = state.error == 'Product is already in cart.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: isAlreadyInCart
                ? Theme.of(context).colorScheme.error.withOpacity(0.9)
                : Theme.of(context).colorScheme.error,
            ),
          );
        }
        if (state.addToCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.product.name} added to cart!'),
              backgroundColor: const Color(0xFFFFC107),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartView()),
          );
        }
      },
      builder: (context, state) {
        // Simulate loading for demo; replace with state.isLoading if available
        final bool isLoading = state.isLoading;
        if (isLoading) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text('Loading...', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0.5,
            ),
            body: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 260,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          height: 28,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 28,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 28,
                              width: 180,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 18,
                              width: 120,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 22,
                              width: 100,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 22,
                              width: 120,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 22,
                              width: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 22,
                              width: 100,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 40),
                            Container(
                              height: 80,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final product = state.product;
        final bool hasDiscount = product.discount != null && product.discount! > 0;
        final discountedPrice = hasDiscount
            ? product.price - (product.price * product.discount! / 100)
            : product.price;
        final totalPrice = discountedPrice * state.quantity;

        String formatPrice(double price) {
          if (price == price.roundToDouble()) {
            return price.toStringAsFixed(0);
          } else {
            return price.toString();
          }
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0.5,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 260,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: max(product.image.length, 1),
                                  onPageChanged: (index) {
                                    setState(() {
                                      _selectedImage = index;
                                    });
                                  },
                                  itemBuilder: (context, i) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: product.image.isNotEmpty
                                            ? "http://localhost:3000/${product.image[i]}"
                                            : '',
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => const SizedBox(
                                          height: 260,
                                          child: Center(child: CircularProgressIndicator()),
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          height: 260,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image, size: 60),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (product.image.length > 1)
                                  Positioned(
                                    right: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_forward_ios, size: 22, color: Colors.black54),
                                        onPressed: _selectedImage < product.image.length - 1
                                            ? () {
                                                _pageController?.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                if (product.image.length > 1)
                                  Positioned(
                                    left: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back_ios, size: 22, color: Colors.black54),
                                        onPressed: _selectedImage > 0
                                            ? () {
                                                _pageController?.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (product.image.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(product.image.length, (i) {
                                  return GestureDetector(
                                    onTap: () {
                                      _pageController?.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                      setState(() {
                                        _selectedImage = i;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: i == _selectedImage ? Colors.orange : Colors.grey[300]!,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: "http://localhost:3000/${product.image[i]}",
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Badges
                    Row(
                      children: [
                        if (hasDiscount)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF7043), Color(0xFFFFA726)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "-${product.discount!.toStringAsFixed(0)}% OFF",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        if (product.stock == 0)
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Out of Stock",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Info Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (product.brandTitle.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      product.brandTitle,
                                      style: const TextStyle(fontSize: 13, color: Colors.deepOrange, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                if (product.categoryTitle.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      product.categoryTitle,
                                      style: const TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                                if (product.subCategoryTitle.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      product.subCategoryTitle,
                                      style: const TextStyle(fontSize: 13, color: Colors.orangeAccent, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  "Rs.${formatPrice(discountedPrice)}",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: hasDiscount ? Colors.green[700] : Colors.black87,
                                  ),
                                ),
                                if (hasDiscount) ...[
                                  const SizedBox(width: 10),
                                  Text(
                                    "Rs.${formatPrice(product.price)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Stock: ${product.stock}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: product.stock > 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Shipping: Rs.${formatPrice(product.shippingCharge)}',
                                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Quantity Selector
                            Row(
                              children: [
                                const Text('Quantity:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange, width: 1.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        splashRadius: 18,
                                        onPressed: state.quantity > 1
                                            ? () {
                                                context.read<ProductDetailBloc>().add(ProductDetailQuantityChanged(state.quantity - 1));
                                              }
                                            : null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('${state.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        splashRadius: 18,
                                        onPressed: state.quantity < product.stock
                                            ? () {
                                                context.read<ProductDetailBloc>().add(ProductDetailQuantityChanged(state.quantity + 1));
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                if (product.stock > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('In stock: ${product.stock}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Total Price
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Total: Rs.${formatPrice(totalPrice)}',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                              ),
                            ),
                            const Divider(height: 28, thickness: 1),
                            // Description
                            if (product.description != null && product.description!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.description!,
                                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                                  ),
                                ],
                              ),
                            const Divider(height: 28, thickness: 1),
                            // All details
                            Text('Product ID: ${product.productId ?? "-"}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('Brand ID: ${product.brandId}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            Text('Category ID: ${product.categoryId}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            Text('Subcategory ID: ${product.subCategoryId}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            // Placeholder for reviews/ratings
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Text('(123 reviews)', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              // Sticky Action Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: product.stock == 0 || state.isLoading
                              ? null
                              : () {
                                  context.read<ProductDetailBloc>().add(ProductDetailAddToCart(state.quantity));
                                },
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: state.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text("Add to Cart", style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, profileState) {
                          final isLoaded = profileState is ProfileLoaded;
                          // Capture the blocs before calling the bottom sheet
                          final profileBloc = BlocProvider.of<ProfileBloc>(context);
                          final shippingAddressBloc = serviceLocator<ShippingAddressBloc>();
                          return Expanded(
                            child: ElevatedButton.icon(
                              onPressed: product.stock == 0 || !isLoaded
                                  ? null
                                  : () async {
                                      final checkoutBloc = serviceLocator<CheckoutBloc>();
                                      final loadedState = profileState as ProfileLoaded;
                                      final userId = loadedState.customer.customerId ?? '';
                                      shippingAddressBloc.add(FetchAddresses(userId));
                                      final address = await showModalBottomSheet<ShippingAddressEntity>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (sheetContext) {
                                          return DraggableScrollableSheet(
                                            initialChildSize: 0.7,
                                            minChildSize: 0.4,
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
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Text('Select Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                          IconButton(
                                                            icon: const Icon(Icons.close),
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
                                                        child: ShippingAddressListPage(
                                                          userId: userId,
                                                          onAddressSelected: (address) {
                                                            Navigator.of(sheetContext).pop(address);
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
                                            builder: (_) => MultiBlocProvider(
                                              providers: [
                                                BlocProvider.value(value: profileBloc),
                                                BlocProvider.value(value: shippingAddressBloc),
                                                BlocProvider.value(value: checkoutBloc),
                                              ],
                                              child: CheckoutPage(
                                                userId: userId,
                                                productId: product.productId!,
                                                quantity: state.quantity,
                                                shippingAddressId: address.id!,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              icon: const Icon(Icons.flash_on, color: Colors.white),
                              label: isLoaded
                                  ? const Text("Buy Now", style: TextStyle(fontSize: 16))
                                  : const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 