import '../../../../core/network/api_keys.dart';
import 'app_connection_enums.dart';

class AppConnectionModel {
  final String id;
  final AppProviderType provider;
  final String externalAccountId;
  final SyncFrequencyType syncFrequency;
  final SyncStatusType syncStatus;
  final String? lastSyncAt;
  final String? lastSyncError;
  final bool isActive; // ✅ ده اللي يحدد "Connected" فعليًا
  final String createdAt;

  // الحقول دي موجودة بس في GET /app-connections/{id} (detail)، مش في الـ list
  final String? grantedScopes;
  final String? metadata;
  final String? tokenExpiresAt;

  AppConnectionModel({
    required this.id,
    required this.provider,
    required this.externalAccountId,
    required this.syncFrequency,
    required this.syncStatus,
    this.lastSyncAt,
    this.lastSyncError,
    required this.isActive,
    required this.createdAt,
    this.grantedScopes,
    this.metadata,
    this.tokenExpiresAt,
  });

  /// "Connected" في الـ UI = isActive == true (مفيش مفهوم status نصي في الباك إند)
  bool get isConnected => isActive;

  factory AppConnectionModel.fromJson(Map<String, dynamic> json) {
    return AppConnectionModel(
      id: json[ApiKeys.connectionId] ?? '',
      provider: AppProviderTypeX.fromInt(json[ApiKeys.provider]),
      externalAccountId: json[ApiKeys.externalAccountId] ?? '',
      syncFrequency: SyncFrequencyTypeX.fromInt(json[ApiKeys.syncFrequency]),
      syncStatus: SyncStatusTypeX.fromInt(json[ApiKeys.syncStatus]),
      lastSyncAt: json[ApiKeys.lastSyncAt],
      lastSyncError: json[ApiKeys.lastSyncError],
      isActive: json[ApiKeys.isActive] ?? false,
      createdAt: json[ApiKeys.connectionCreatedAt] ?? '',
      grantedScopes: json[ApiKeys.grantedScopes],
      metadata: json[ApiKeys.metadata],
      tokenExpiresAt: json[ApiKeys.tokenExpiresAt],
    );
  }
}