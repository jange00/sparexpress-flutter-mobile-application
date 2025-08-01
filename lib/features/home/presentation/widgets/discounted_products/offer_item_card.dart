import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
// import 'package:sparexpress/features/home/presentation/view/product_detail_view.dart';

class OfferItemCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const OfferItemCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product.discount != null && product.discount! > 0;
    final double discountedPrice = hasDiscount
        ? product.price - (product.price * product.discount! / 100)
        : product.price;

    String formatPrice(double price) {
      if (price == price.roundToDouble()) {
        return price.toStringAsFixed(0);
      } else {
        return price.toString();
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.13),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Make column take minimum space
          children: [
            // Image with discount badge
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: "${ApiEndpoints.serverAddress}/${product.image.first}",
                    height: 90, // Reduced from 100
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 90, // Reduced from 100
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 6, // Reduced from 8
                      left: 6, // Reduced from 8
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Reduced padding
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF7043), Color(0xFFFFA726)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6), // Reduced from 8
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "-${product.discount!.toStringAsFixed(0)}% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11, // Reduced from 13
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Reduced from 10
            // Product Name
            Text(
              product.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.2), // Reduced from 15
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4), // Reduced from 6
            // Price Row
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Rs.${formatPrice(discountedPrice)}",
                    style: TextStyle(
                      fontSize: 14, // Reduced from 15
                      fontWeight: FontWeight.w700,
                      color: Colors.deepOrange[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6), // Reduced from 8
                if (hasDiscount)
                  Flexible(
                    child: Text(
                      "Rs.${formatPrice(product.price)}",
                      style: const TextStyle(
                        fontSize: 11, // Reduced from 12
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6), // Reduced from 8
            if (product.stock == 0)
              Container(
                margin: const EdgeInsets.only(top: 2), // Reduced from 4
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(4), // Reduced from 6
                ),
                child: const Text(
                  "Out of Stock",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Reduced from 11
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (product.stock > 0)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Reduced from 8
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Shop Now",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Reduced from 13
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
