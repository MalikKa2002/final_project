import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart_guide/Buttons/blurry_circle_button.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final VoidCallback onBack;

  const ImageSlider({
    required this.imageUrls,
    required this.onBack,
    super.key,
  });

  @override
  createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.5 * 255).toInt()),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                items: images.map((imageUrl) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 400,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),

              // ← Back arrow in top-left:
              Positioned(
                top: 40,
                left: 20,
                child: BlurryCircleButton(
                  icon: Icons.arrow_back,
                  onPressed: widget.onBack,
                ),
              ),

              // Dots indicator at the bottom
              Positioned(
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
