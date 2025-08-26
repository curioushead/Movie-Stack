enum RequestStatus { loading, loaded, error }

enum GetAllRequestStatus {
  loading,
  loaded,
  error,
  fetchMoreLoading,
  fetchMoreError
}

enum TimeWindow { day, week }

enum MovieCategory {
  nowPlaying,
  popular,
  topRated,
  trending,
}

enum SearchRequestStatus { empty, loading, loaded, error, noResults }
