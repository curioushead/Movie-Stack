import 'package:flutter/material.dart';
import 'package:movie_stack/core/resources/app_colors.dart';
import 'package:movie_stack/core/resources/app_strings.dart';
import 'package:movie_stack/core/resources/app_values.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    required this.title,
    this.onSeeAllTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p4,
        horizontal: AppPadding.p12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section Title
          Text(
            title,
            style: textTheme.titleSmall,
          ),

          // "See All >" Button
          if (onSeeAllTap != null)
            TextButton(
              onPressed: onSeeAllTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s4, vertical: AppSize.s8),
                minimumSize: const Size(AppSize.s48, AppSize.s48),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerRight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.seeAll,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryBtnText,
                    ),
                  ),
                  const SizedBox(width: AppSize.s4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppSize.s12,
                    color: AppColors.primaryBtnText,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
