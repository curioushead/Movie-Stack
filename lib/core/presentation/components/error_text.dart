import 'package:flutter/material.dart';
import 'package:movie_stack/core/resources/app_strings.dart';

class ErrorText extends StatelessWidget {
  final String? errorMessage;

  const ErrorText({
    super.key,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.somethingWentWrong,
          style: textTheme.titleMedium,
        ),
        Text(
          errorMessage ?? AppStrings.failedToLoad,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
