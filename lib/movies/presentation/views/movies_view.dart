import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/presentation/components/custom_slider.dart';
import 'package:movie_stack/core/presentation/components/error_screen.dart';
import 'package:movie_stack/core/presentation/components/loading_indicator.dart';
import 'package:movie_stack/core/presentation/components/section_header.dart';
import 'package:movie_stack/core/presentation/components/section_listview.dart';
import 'package:movie_stack/core/presentation/components/section_listview_card.dart';
import 'package:movie_stack/core/presentation/components/slider_card.dart';
import 'package:movie_stack/core/resources/app_colors.dart';
import 'package:movie_stack/core/resources/app_routes.dart';
import 'package:movie_stack/core/resources/app_strings.dart';
import 'package:movie_stack/core/resources/app_values.dart';
import 'package:movie_stack/core/services/service_locator.dart';
import 'package:movie_stack/core/utils/enums.dart';
import 'package:movie_stack/movies/presentation/controllers/movies_bloc/movies_bloc.dart';
import 'package:movie_stack/movies/presentation/controllers/movies_bloc/movies_event.dart';
import 'package:movie_stack/movies/presentation/controllers/movies_bloc/movies_state.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()..add(const GetMoviesEvent()),
      child: Scaffold(
        body: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            switch (state.status) {
              case RequestStatus.loading:
                return const LoadingIndicator();
              case RequestStatus.loaded:
                return MoviesWidget(
                  nowPlayingMovies: state.nowPlayingMovies,
                  trendingMovies: state.trendingMovies,
                  trendingStatus: state.trendingStatus,
                  trendingMessage: state.trendingMessage,
                  popularMovies: state.popularMovies,
                  topRatedMovies: state.topRatedMovies,
                  popularMoviesStatus: state.popularMoviesStatus,
                  popularMoviesMessage: state.popularMoviesMessage,
                );
              case RequestStatus.error:
                return ErrorScreen(
                  onTryAgainPressed: () {
                    context.read<MoviesBloc>().add(const GetMoviesEvent());
                  },
                  errorMessage: state.message,
                );
            }
          },
        ),
      ),
    );
  }
}

class MoviesWidget extends StatefulWidget {
  final List<Media> nowPlayingMovies;
  final Map<TimeWindow, List<Media>> trendingMovies;
  final Map<TimeWindow, RequestStatus> trendingStatus;
  final Map<TimeWindow, String> trendingMessage;
  final List<Media> popularMovies;
  final List<Media> topRatedMovies;
  final RequestStatus popularMoviesStatus;
  final String popularMoviesMessage;

  const MoviesWidget({
    super.key,
    required this.nowPlayingMovies,
    required this.trendingMovies,
    required this.trendingStatus,
    required this.trendingMessage,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.popularMoviesStatus,
    required this.popularMoviesMessage,
  });

  @override
  State<MoviesWidget> createState() => _MoviesWidgetState();
}

class _MoviesWidgetState extends State<MoviesWidget> {
  TimeWindow selectedTimeWindow = TimeWindow.day;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Now Playing Movies
          if (widget.nowPlayingMovies.isNotEmpty)
            CustomSlider(
              itemBuilder: (context, itemIndex, _) {
                return SliderCard(
                  media: widget.nowPlayingMovies[itemIndex],
                  itemIndex: itemIndex,
                );
              },
            ),

          // 2. Trending Movies Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppPadding.p4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.trendingMovies,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                DropdownButton<TimeWindow>(
                  dropdownColor: AppColors.secondaryBackground,
                  value: selectedTimeWindow,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.primaryText),
                  onChanged: (TimeWindow? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedTimeWindow = newValue;
                      });
                      // Dispatch fetch event for selected timeWindow
                      context
                          .read<MoviesBloc>()
                          .add(GetTrendingMoviesEvent(timeWindow: newValue));
                    }
                  },
                  items: [
                    DropdownMenuItem<TimeWindow>(
                      value: TimeWindow.day,
                      child: Text(
                        AppStrings.today,
                        style: TextStyle(
                          color: selectedTimeWindow == TimeWindow.day
                              ? Colors.red
                              : AppColors.primaryText,
                        ),
                      ),
                    ),
                    DropdownMenuItem<TimeWindow>(
                      value: TimeWindow.week,
                      child: Text(
                        AppStrings.thisWeek,
                        style: TextStyle(
                          color: selectedTimeWindow == TimeWindow.week
                              ? Colors.red
                              : AppColors.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<MoviesBloc, MoviesState>(
            buildWhen: (previous, current) =>
                previous.trendingMovies != current.trendingMovies ||
                previous.trendingStatus[selectedTimeWindow] !=
                    current.trendingStatus[selectedTimeWindow] ||
                previous.trendingMessage[selectedTimeWindow] !=
                    current.trendingMessage[selectedTimeWindow],
            builder: (context, state) {
              final trendingMoviesToShow =
                  state.trendingMovies[selectedTimeWindow] ?? [];

              final status = state.trendingStatus[selectedTimeWindow] ??
                  RequestStatus.loading;
              final message = state.trendingMessage[selectedTimeWindow] ?? '';

              if (status == RequestStatus.loading &&
                  trendingMoviesToShow.isEmpty) {
                return const LoadingIndicator();
              }
              if (status == RequestStatus.error &&
                  trendingMoviesToShow.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Failed to load trending movies: $message',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return SectionListView(
                height: AppSize.s240,
                itemCount: trendingMoviesToShow.length,
                itemBuilder: (context, index) {
                  return SectionListViewCard(
                      media: trendingMoviesToShow[index]);
                },
              );
            },
          ),

          // 3. Popular Movies Section
          SectionHeader(
            title: AppStrings.popularMovies,
            onSeeAllTap: () {
              context.goNamed(AppRoutes.popularMoviesRoute);
            },
          ),
          if (widget.popularMovies.isNotEmpty)
            SectionListView(
              height: AppSize.s240,
              itemCount: widget.popularMovies.length,
              itemBuilder: (context, index) {
                return SectionListViewCard(media: widget.popularMovies[index]);
              },
            )
          else if (widget.popularMoviesStatus == RequestStatus.error)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p20),
              child: Text(
                'Failed to load popular movies: ${widget.popularMoviesMessage}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.primaryText),
                textAlign: TextAlign.center,
              ),
            ),

          // 4. Top Rated Movies Section
          if (widget.topRatedMovies.isNotEmpty) ...[
            SectionHeader(
              title: AppStrings.topRatedMovies,
              onSeeAllTap: () {
                context.goNamed(AppRoutes.topRatedMoviesRoute);
              },
            ),
            SectionListView(
              height: AppSize.s240,
              itemCount: widget.topRatedMovies.length,
              itemBuilder: (context, index) {
                return SectionListViewCard(media: widget.topRatedMovies[index]);
              },
            ),
          ],
        ],
      ),
    );
  }
}
