import 'package:flutter/material.dart';

class CustomImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  const CustomImageCarousel({super.key, required this.imageUrls});

  @override
  State<CustomImageCarousel> createState() => _CustomImageCarouselState();
}

class _CustomImageCarouselState extends State<CustomImageCarousel> {
  late PageController _imageController;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _imageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _imageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imageUrls.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentImage == index ? 12 : 8,
              height: _currentImage == index ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImage == index
                    ? Colors.blueGrey
                    : const Color.fromARGB(255, 177, 177, 177),
              ),
            );
          }),
        ),
      ],
    );
  }
}
