// lib/widgets/experience_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

import '../models/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.isSelected,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  Future<String> _fetchImageOnce(String url) async {
    final cachedImage =
        await CachedNetworkImageProvider(url).obtainKey(const ImageConfiguration());
    return url;
  }

  @override
  Widget build(BuildContext context) {
    double rotationAngle = (index % 2 == 0) ? -0.05 : 0.05;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Experience image with tilt
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12, top: 8, bottom: 8, left: 6),
              child: Transform.rotate(
                angle: rotationAngle, // Apply the tilt based on the index
                child: FutureBuilder(
                  future: _fetchImageOnce(experience.imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Icon(Icons.error);
                    } else {
                      return CachedNetworkImage(
                        imageUrl: snapshot.data as String,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        fit: BoxFit.cover,
                        color: isSelected ? null : Colors.grey,
                        colorBlendMode:
                            isSelected ? null : BlendMode.saturation,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
