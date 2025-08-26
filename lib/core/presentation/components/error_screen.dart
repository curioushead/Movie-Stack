import 'package:flutter/material.dart';
import 'package:movie_stack/core/presentation/components/error_text.dart';
import 'package:movie_stack/core/resources/app_colors.dart';
import 'package:movie_stack/core/resources/app_constants.dart';
import 'package:movie_stack/core/resources/app_strings.dart';
import 'package:movie_stack/core/resources/app_values.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.onTryAgainPressed,
    this.errorMessage,
  });

  final Function() onTryAgainPressed;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppPadding.p18),
              child: Image.asset(
                color: AppColors.primary,
                AppConstants.errorImagePath,
                fit: BoxFit.contain,
              ),
            ),
            ErrorText(errorMessage: errorMessage),
            const SizedBox(height: AppSize.s15),
            ElevatedButton(
              onPressed: onTryAgainPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s30),
                ),
              ),
              child: Text(
                AppStrings.tryAgain,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
