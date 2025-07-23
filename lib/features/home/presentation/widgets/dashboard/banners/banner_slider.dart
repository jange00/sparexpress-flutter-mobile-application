import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerSliderWidget extends StatelessWidget {
  final List<String> bannerImages;

  const BannerSliderWidget({super.key, required this.bannerImages});

  @override
  Widget build(BuildContext context) {
    if (bannerImages.isEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
        ),
        items: List.generate(2, (index) => index).map((_) {
          return Builder(
            builder: (BuildContext context) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[300],
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: bannerImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
