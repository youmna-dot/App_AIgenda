import 'package:dartz/dartz.dart';
import '../../data/models/app_connection_enums.dart';
import '../../data/models/app_connection_model.dart';

/// Abstract contract for App Connections data operations.
/// Implemented by [AppConnectionsRepositoryImpl] in the data layer.
abstract class AppConnectionsRepository {
  /// GET /api/users/current/app-connections
  /// Returns the list of all connections (connected + not connected) for
  /// the current user.
  Future<Either<String, List<AppConnectionModel>>> getConnections();

  /// GET /api/users/current/app-connections/{connectionId}
  Future<Either<String, AppConnectionModel>> getConnectionById(
      String connectionId,
      );

  /// POST /api/users/current/app-connections/authorize/{provider}
  /// Returns the authorization URL to open in the browser
  /// (used afterwards with FlutterWebAuth2 by the Cubit — this method
  /// only talks to the backend, it does NOT open any browser itself).
  /// [provider] is sent as its route name (e.g. "google", "github").
  Future<Either<String, String>> getAuthorizationUrl(
      AppProviderType provider,
      );

  /// PUT /api/users/current/app-connections/{connectionId}
  Future<Either<String, AppConnectionModel>> updateConnection({
    required String connectionId,
    required AppProviderType provider,
    SyncFrequencyType? syncFrequency,
    String? metadata,
  });

  /// DELETE /api/users/current/app-connections/{connectionId}
  Future<Either<String, void>> disconnect(String connectionId);

  /// POST /api/users/current/app-connections/{connectionId}/sync
  Future<Either<String, void>> syncConnection({
    required String connectionId,
    bool forceFullSync = false,
  });

  /// GET /api/users/current/app-connections/{connectionId}/sync-status
  Future<Either<String, SyncStatusType>> getSyncStatus(String connectionId);
}