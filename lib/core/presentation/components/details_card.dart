import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/core/presentation/components/slider_card_image.dart';
import 'package:movie_stack/core/resources/app_colors.dart';
import 'package:movie_stack/core/resources/app_values.dart';
import 'package:movie_stack/watchlist/presentation/controllers/watchlist_bloc/watchlist_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsCard extends StatefulWidget {
  const DetailsCard({
    required this.mediaDetails,
    required this.detailsWidget,
    super.key,
  });

  final MediaDetails mediaDetails;
  final Widget detailsWidget;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  late MediaDetails _localMediaDetails;

  @override
  void initState() {
    super.initState();
    _localMediaDetails = widget.mediaDetails;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    context
        .read<WatchlistBloc>()
        .add(CheckItemAddedEvent(tmdbId: _localMediaDetails.tmdbID));

    return SafeArea(
      child: Stack(
        children: [
          SliderCardImage(imageUrl: _localMediaDetails.backdropUrl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: SizedBox(
              height: size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.p8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _localMediaDetails.title,
                            maxLines: 2,
                            style: textTheme.titleMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppPadding.p4,
                              bottom: AppPadding.p6,
                            ),
                            child: widget.detailsWidget,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rate_rounded,
                                color: AppColors.ratingIconColor,
                                size: AppSize.s18,
                              ),
                              Text(
                                '${_localMediaDetails.voteAverage} ',
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                _localMediaDetails.voteCount,
                                style: textTheme.bodySmall,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_localMediaDetails.trailerUrl.isNotEmpty) ...[
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(_localMediaDetails.trailerUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: Container(
                          height: AppSize.s40,
                          width: AppSize.s40,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppPadding.p12,
              left: AppPadding.p16,
              right: AppPadding.p16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.iconContainerColor,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.secondaryText,
                      size: AppSize.s20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _localMediaDetails.isAdded
                        ? context.read<WatchlistBloc>().add(
                            RemoveWatchListItemEvent(
                                _localMediaDetails.id)) // Use the local copy
                        : context.read<WatchlistBloc>().add(
                              AddWatchListItemEvent(
                                  media: Media.fromMediaDetails(
                                      _localMediaDetails)), // Use the local copy
                            );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.iconContainerColor,
                    ),
                    child: BlocConsumer<WatchlistBloc, WatchlistState>(
                      listener: (context, state) {
                        if (state.status == WatchlistRequestStatus.itemAdded) {
                          setState(() {
                            _localMediaDetails = _localMediaDetails.copyWith(
                              id: state.id,
                              isAdded: true,
                            );
                          });
                        } else if (state.status ==
                            WatchlistRequestStatus.itemRemoved) {
                          setState(() {
                            _localMediaDetails = _localMediaDetails.copyWith(
                              id: state.id, // ID is -1 on remove
                              isAdded: false,
                            );
                          });
                        } else if (state.status ==
                                WatchlistRequestStatus.isItemAdded &&
                            state.id != -1) {
                          setState(() {
                            _localMediaDetails = _localMediaDetails.copyWith(
                              id: state.id,
                              isAdded: true,
                            );
                          });
                        }
                      },
                      builder: (context, state) {
                        return Icon(
                          Icons.bookmark_rounded,
                          color: _localMediaDetails.isAdded
                              ? AppColors.bookmarkIconColor
                              : AppColors.secondaryText,
                          size: AppSize.s20,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
