import '../../data/models/app_connection_enums.dart';
import '../../data/models/app_connection_model.dart';

abstract class AppConnectionsState {}

class AppConnectionsInitial extends AppConnectionsState {}

// ── Loading the full connections list ──
class AppConnectionsLoading extends AppConnectionsState {}

class AppConnectionsLoaded extends AppConnectionsState {
  final List<AppConnectionModel> connections;
  AppConnectionsLoaded(this.connections);
}

class AppConnectionsError extends AppConnectionsState {
  final String message;
  AppConnectionsError(this.message);
}

// ── Connecting a specific provider (OAuth flow in progress) ──
// [provider] لوحده، عشان الشاشة تعرف تحط Loading على الكارت الصحيح بس
class ProviderConnecting extends AppConnectionsState {
  final AppProviderType provider;
  final List<AppConnectionModel> currentConnections; // نسيب القائمة القديمة ظاهرة وقت اللودينج
  ProviderConnecting(this.provider, this.currentConnections);
}

class ProviderConnectSuccess extends AppConnectionsState {
  final List<AppConnectionModel> connections; // القائمة بعد التحديث
  ProviderConnectSuccess(this.connections);
}

class ProviderConnectFailure extends AppConnectionsState {
  final AppProviderType provider;
  final String message;
  final List<AppConnectionModel> currentConnections; // نسيب القائمة القديمة ظاهرة بعد الفشل
  ProviderConnectFailure(this.provider, this.message, this.currentConnections);
}

// ── Disconnecting a specific connection ──
class ProviderDisconnecting extends AppConnectionsState {
  final String connectionId;
  final List<AppConnectionModel> currentConnections;
  ProviderDisconnecting(this.connectionId, this.currentConnections);
}

class ProviderDisconnectSuccess extends AppConnectionsState {
  final List<AppConnectionModel> connections;
  ProviderDisconnectSuccess(this.connections);
}

class ProviderDisconnectFailure extends AppConnectionsState {
  final String connectionId;
  final String message;
  final List<AppConnectionModel> currentConnections;
  ProviderDisconnectFailure(
      this.connectionId,
      this.message,
      this.currentConnections,
      );
}