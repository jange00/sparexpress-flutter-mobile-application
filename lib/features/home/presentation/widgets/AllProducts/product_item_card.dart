import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/presentation/widgets/product_detail/product_detail_view.dart';

class ProductItemCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onAddToCart;
  final VoidCallback onViewDetail;
  final double? width; // optional width for card

  const ProductItemCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onViewDetail,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product.discount != null && product.discount! > 0;
    final discountedPrice = hasDiscount
        ? product.price - (product.price * product.discount! / 100)
        : product.price;

    String formatPrice(double price) {
      if (price == price.roundToDouble()) {
        return price.toStringAsFixed(0);
      } else {
        return price.toString();
      }
    }

    return SizedBox(
      width: width ?? 200, // default width if none provided
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 275, // control fixed height to avoid overflow
          child: GestureDetector(
            onTap: onViewDetail,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with discount badge
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        product.image.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: "http://localhost:3000/${product.image.first}",
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const SizedBox(
                                  height: 90,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  height: 90,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 40),
                                ),
                              )
                            : Container(
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported, size: 40),
                              ),
                        if (hasDiscount)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "-${product.discount!.toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Rs.${formatPrice(discountedPrice)}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: hasDiscount ? Colors.green[700] : Colors.black87,
                        ),
                      ),
                      if (hasDiscount) ...[
                        Text(
                          "Rs.${formatPrice(product.price)}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: product.stock == 0 ? null : onAddToCart,
                          icon: const Icon(Icons.add_shopping_cart, size: 14),
                          label: const Text("Cart", style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailView(product: product),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text("View", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),

                  if (product.stock == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Out of Stock",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
