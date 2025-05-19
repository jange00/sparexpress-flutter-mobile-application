import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Product Name',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Categories Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                CategoryItem(title: 'Vehicle Parts', icon: Icons.car_repair),
                CategoryItem(title: 'Computer Parts', icon: Icons.computer),
              ],
            ),

            const SizedBox(height: 20),

            // Featured Products
            const SectionHeader(title: 'Featured Product'),
            SizedBox(
              height: 200,
              child: ProductHorizontalList(products: [
                ProductCard(
                  title: 'Gear Box',
                  price: '15000',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'LCD Screen',
                  price: '2000',
                  imagePath: 'assets/images/mouse.jpg',
                ),
                ProductCard(
                  title: 'Gear Box',
                  price: '15000',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'LCD Screen',
                  price: '2000',
                  imagePath: 'assets/images/mouse.jpg',
                ),
              ]),
            ),

            const SizedBox(height: 20),

            // Best Sellers
            const SectionHeader(title: 'Best Sellers'),
            SizedBox(
              height: 200,
              child: ProductHorizontalList(products: [
                ProductCard(
                  title: 'Wireless Headset',
                  price: '900',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'Headlight',
                  price: '2000',
                  imagePath: 'assets/images/mouse.jpg',
                ),
                ProductCard(
                  title: 'Wireless Headset',
                  price: '900',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'Headlight',
                  price: '2000',
                  imagePath: 'assets/images/mouse.jpg',
                ),
              ]),
            ),

            const SizedBox(height: 20),

            // New Arrivals
            const SectionHeader(title: 'New Arrivals'),
            SizedBox(
              height: 200,
              child: ProductHorizontalList(products: [
                ProductCard(
                  title: 'Earphones',
                  price: '400',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'Drill Machine',
                  price: '1700',
                  imagePath: 'assets/images/mouse.jpg',
                ),
                ProductCard(
                  title: 'Earphones',
                  price: '400',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'Drill Machine',
                  price: '1700',
                  imagePath: 'assets/images/mouse.jpg',
                ),
              ]),
            ),

            const SizedBox(height: 20),

            // Special Offers
            const SectionHeader(title: 'Special Offers'),
            SizedBox(
              height: 200,
              child: ProductHorizontalList(products: [
                ProductCard(
                  title: 'Headlight',
                  price: '1500',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'HD Wireless',
                  price: '1000',
                  imagePath: 'assets/images/mouse.jpg',
                ),
                ProductCard(
                  title: 'Headlight',
                  price: '1500',
                  imagePath: 'assets/images/wire.jpg',
                ),
                ProductCard(
                  title: 'HD Wireless',
                  price: '1000',
                  imagePath: 'assets/images/mouse.jpg',
                ),
              ]),
            ),

            // const SizedBox(height: 30),

            // Latest News
          //   const Text("Latest News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          //   ListTile(
          //     title: const Text("Philosophy That Addresses Topics Such as God"),
          //     subtitle: const Text("19 Jan 2021"),
          //     trailing: ClipRRect(
          //       borderRadius: BorderRadius.circular(8),
          //       child: Image.asset('assets/images/mouse.jpg', width: 50, height: 50, fit: BoxFit.cover),
          //     ),
          //   ),
          //   ListTile(
          //     title: const Text("Many Inquiries Outside Of Academia Are Philosophical"),
          //     subtitle: const Text("18 Jan 2021"),
          //     trailing: ClipRRect(
          //       borderRadius: BorderRadius.circular(8),
          //       child: Image.asset('assets/images/wire.jpg', width: 50, height: 50, fit: BoxFit.cover),
          //     ),
          //   ),
          //   Center(
          //     child: OutlinedButton(
          //       onPressed: () {},
          //       child: const Text('See All News'),
          //     ),
          //   ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String title;
  final IconData icon;

  const CategoryItem({required this.title, required this.icon, super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(widget.icon, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(widget.title),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const ProductCard({
    required this.title,
    required this.price,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 140,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Rs. $price', style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductHorizontalList extends StatelessWidget {
  final List<ProductCard> products;

  const ProductHorizontalList({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: products,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text("See All")),
      ],
    );
  }
}
