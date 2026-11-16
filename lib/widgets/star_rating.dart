import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Reusable star rating indicator widget with rating count badge.
class StarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final bool showNumber;
  final int? reviewCount;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 14.0,
    this.showNumber = true,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final starValue = index + 1;
          IconData icon;
          if (rating >= starValue) {
            icon = Icons.star_rounded;
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_outline_rounded;
          }
          return Icon(
            icon,
            color: AppColors.accent,
            size: size,
          );
        }),
        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.9,
              fontWeight: FontWeight.w600,
              color: AppColors.accentDark,
            ),
          ),
        ],
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size * 0.85,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}
