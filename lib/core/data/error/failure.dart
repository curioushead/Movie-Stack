import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String userMessage;

  const Failure(this.message, this.userMessage);

  @override
  List<Object?> get props => [message, userMessage];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, super.userMessage);

  factory ServerFailure.fromDioException(DioException e) {
    final raw = e.message ?? 'Unexpected error occurred.';
    String userFriendly;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        userFriendly =
        'The connection timed out. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        userFriendly =
        'Server error (${e.response?.statusCode ?? ''}). Please try again later.';
        break;
      case DioExceptionType.cancel:
        userFriendly = 'Request was cancelled. Please try again.';
        break;
      case DioExceptionType.badCertificate:
        userFriendly = 'Could not verify server security certificate.';
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        userFriendly = 'Connection failed due to a server or network issue. Please try again.';
        break;
    }

    return ServerFailure(raw, userFriendly);
  }
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message)
      : super(message, 'There was a problem with local storage. Please restart the app.');
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message)
      : super(message, 'No internet connection. Please check your network.');
}
