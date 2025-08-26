import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stack/core/resources/app_colors.dart';
import 'package:movie_stack/core/resources/app_strings.dart';
import 'package:movie_stack/core/resources/app_values.dart';
import 'package:movie_stack/search/presentation/controllers/search_bloc/search_bloc.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: _textController,
      cursorColor: AppColors.primaryText,
      cursorWidth: AppSize.s1,
      style: textTheme.bodyLarge,
      onChanged: (query) {
        context.read<SearchBloc>().add(SearchTextChanged(query));
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.primaryText,
          ),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.primaryText,
          ),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.primaryText,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            _textController.clear();
            context.read<SearchBloc>().add(const SearchTextChanged(''));
          },
          child: const Icon(
            Icons.clear_rounded,
            color: AppColors.primaryText,
          ),
        ),
        hintText: AppStrings.searchHint,
        hintStyle: textTheme.bodyLarge,
      ),
    );
  }
}