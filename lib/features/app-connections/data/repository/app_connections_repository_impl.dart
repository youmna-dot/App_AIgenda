import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/app_connection_enums.dart';
import '../../data/data_source/app_connections_remote_data_source.dart';
import '../../data/models/app_connection_model.dart';
import '../../domain/repositories/app_connections_repository.dart';


class AppConnectionsRepositoryImpl implements AppConnectionsRepository {
  final AppConnectionsRemoteDataSource remote;

  AppConnectionsRepositoryImpl(this.remote);

  // نفس فلسفة _handleError بتاعة AuthRepositoryImpl بالحرف، عشان نفس
  // شكل رسايل الإيرور يتكرر في كل الـ app (problemDetails -> message -> fallback)
  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;

        if (data is Map<String, dynamic>) {
          final problemDetails = data['problemDetails'];

          if (problemDetails is Map<String, dynamic>) {
            final errors = problemDetails['error'];

            if (errors is List && errors.isNotEmpty) {
              return errors.length >= 2
                  ? errors[1].toString()
                  : errors[0].toString();
            }
            return problemDetails['title'] ?? 'Server error occurred';
          }

          return data['message']?.toString() ??
              data['error']?.toString() ??
              'Something went wrong';
        }

        if (error.response?.statusCode == 500) {
          return 'Internal Server Error (500)';
        }
        if (error.response?.statusCode == 404) {
          return 'Service not found (404)';
        }
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout. Please check your internet.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please connect and try again.';
      }

      return 'Network error: ${error.type.name}';
    }

    return 'Unexpected error. Please try again.';
  }

  //  Get Connections
  @override
  Future<Either<String, List<AppConnectionModel>>> getConnections() async {
    try {
      final result = await remote.getConnections();
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  //  Get Connection By Id
  @override
  Future<Either<String, AppConnectionModel>> getConnectionById(
      String connectionId,
      ) async {
    try {
      final result = await remote.getConnectionById(connectionId);
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  //  Get Authorization Url
  @override
  Future<Either<String, String>> getAuthorizationUrl(
      AppProviderType provider,
      ) async {
    try {
      final result = await remote.getAuthorizationUrl(provider);
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  //  Update Connection
  @override
  Future<Either<String, AppConnectionModel>> updateConnection({
    required String connectionId,
    required AppProviderType provider,
    SyncFrequencyType? syncFrequency,
    String? metadata,
  }) async {
    try {
      final result = await remote.updateConnection(
        connectionId: connectionId,
        provider: provider,
        syncFrequency: syncFrequency,
        metadata: metadata,
      );
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  //  Disconnect
  @override
  Future<Either<String, void>> disconnect(String connectionId) async {
    try {
      await remote.disconnect(connectionId);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  //  Sync Connection
  @override
  Future<Either<String, void>> syncConnection({
    required String connectionId,
    bool forceFullSync = false,
  }) async {
    try {
      await remote.syncConnection(
        connectionId: connectionId,
        forceFullSync: forceFullSync,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  //  Get Sync Status
  @override
  Future<Either<String, SyncStatusType>> getSyncStatus(
      String connectionId,
      ) async {
    try {
      final result = await remote.getSyncStatus(connectionId);
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}