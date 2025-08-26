import 'package:equatable/equatable.dart';
import 'package:movie_stack/core/data/network/error_message_model.dart';

class ServerException implements Exception {
  final ErrorMessageModel errorMessageModel;

  const ServerException({required this.errorMessageModel});
}

class LocalDatabaseException extends Equatable implements Exception {
  final String message;

  const LocalDatabaseException(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkException implements Exception {
  final String message;

 const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
class NoInternetException implements Exception {
  final String message;

  const NoInternetException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}
