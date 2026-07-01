import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../../../../core/network/api_service.dart';
import '../models/app_connection_enums.dart';
import '../models/app_connection_model.dart';

class AppConnectionsRemoteDataSource {
  final ApiService apiService;

  AppConnectionsRemoteDataSource(this.apiService);

  /// GET /api/users/current/app-connections
  Future<List<AppConnectionModel>> getConnections() async {
    final data = await apiService.get(ApiEndpoints.appConnections);
    return (data as List).map((e) => AppConnectionModel.fromJson(e)).toList();
  }

  /// GET /api/users/current/app-connections/{connectionId}
  Future<AppConnectionModel> getConnectionById(String connectionId) async {
    final data = await apiService.get(
      ApiEndpoints.appConnectionById(connectionId),
    );
    return AppConnectionModel.fromJson(data);
  }

  /// POST /api/users/current/app-connections/authorize/{provider}
  /// Returns the raw authorization URL string returned by the backend.
  /// Confirmed via Postman: { "authorizationUrl": "https://..." }
  ///
  /// `client=mobile` is required so the backend's AuthCallback knows to
  /// issue a 302 redirect to aigenda://success?... instead of returning
  /// a plain JSON response (which is what `client=web` / default does).
  Future<String> getAuthorizationUrl(AppProviderType provider) async {
    final data = await apiService.post(
      ApiEndpoints.authorizeAppConnection(provider.routeName),
      queryParameters: {'client': 'mobile'},
    );
    return (data as Map<String, dynamic>)[ApiKeys.authorizationUrl] ?? '';
  }

  /// PUT /api/users/current/app-connections/{connectionId}
  Future<AppConnectionModel> updateConnection({
    required String connectionId,
    required AppProviderType provider,
    SyncFrequencyType? syncFrequency,
    String? metadata,
  }) async {
    final data = await apiService.put(
      ApiEndpoints.appConnectionById(connectionId),
      data: {
        ApiKeys.provider: provider.toInt(),
        if (syncFrequency != null)
          ApiKeys.syncFrequency: syncFrequency.toInt(),
        if (metadata != null) ApiKeys.metadata: metadata,
      },
    );
    return AppConnectionModel.fromJson(data);
  }

  /// DELETE /api/users/current/app-connections/{connectionId}
  Future<void> disconnect(String connectionId) async {
    await apiService.delete(ApiEndpoints.appConnectionById(connectionId));
  }

  /// POST /api/users/current/app-connections/{connectionId}/sync
  Future<void> syncConnection({
    required String connectionId,
    bool forceFullSync = false,
  }) async {
    await apiService.post(
      ApiEndpoints.syncAppConnection(connectionId),
      data: {ApiKeys.forceFullSync: forceFullSync},
    );
  }

  /// GET /api/users/current/app-connections/{connectionId}/sync-status
  /// NOTE: backend's SyncStatusResponse uses "connectionId" as the id key
  /// (different from the list/detail endpoints which use "id").
  Future<SyncStatusType> getSyncStatus(String connectionId) async {
    final data = await apiService.get(
      ApiEndpoints.appConnectionSyncStatus(connectionId),
    );
    return SyncStatusTypeX.fromInt(
      (data as Map<String, dynamic>)[ApiKeys.syncStatus],
    );
  }
}