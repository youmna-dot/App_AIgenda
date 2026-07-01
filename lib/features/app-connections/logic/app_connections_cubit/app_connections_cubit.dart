import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../../data/models/app_connection_enums.dart';
import '../../data/models/app_connection_model.dart';
import '../../domain/repositories/app_connections_repository.dart';
import 'app_connections_state.dart';

class AppConnectionsCubit extends Cubit<AppConnectionsState> {
  final AppConnectionsRepository repo;

  // custom scheme المتفق عليه مع الباك إند للـ deep link (aigenda://...)
  static const String _callbackUrlScheme = 'aigenda';

  AppConnectionsCubit(this.repo) : super(AppConnectionsInitial());

  // الحالة الحالية (لو موجودة) عشان نقدر نسيب القائمة ظاهرة وقت الـ loading
  List<AppConnectionModel> _currentConnectionsOrEmpty() {
    final s = state;
    if (s is AppConnectionsLoaded) return s.connections;
    if (s is ProviderConnecting) return s.currentConnections;
    if (s is ProviderConnectSuccess) return s.connections;
    if (s is ProviderConnectFailure) return s.currentConnections;
    if (s is ProviderDisconnecting) return s.currentConnections;
    if (s is ProviderDisconnectSuccess) return s.connections;
    if (s is ProviderDisconnectFailure) return s.currentConnections;
    return const [];
  }

  //  GET CONNECTIONS
  Future<void> getConnections() async {
    emit(AppConnectionsLoading());

    final result = await repo.getConnections();

    result.fold(
          (err) => emit(AppConnectionsError(err)),
          (connections) => emit(AppConnectionsLoaded(connections)),
    );
  }

  //  CONNECT TO PROVIDER (Full OAuth flow)
  //
  // ⚠️ معلّق على تعديل الباك إند: لازم AuthCallback يعمل 302 redirect لـ
  // aigenda://success?connectionId=...&status=... في الآخر بدل ما يرجّع
  // JSON response عادي. لحد ما ده يتعمل، FlutterWebAuth2.authenticate()
  // هتفتح المتصفح صحيح، بس مش هترجع تلقائي للتطبيق (هتعمل timeout أو
  // تفضل واقفة في المتصفح). الكود نفسه صحيح ومجهز، بس مش قابل للتست
  // بشكل كامل غير بعد تعديل الباك إند.
  Future<void> connectToProvider(AppProviderType provider) async {
    final current = _currentConnectionsOrEmpty();
    emit(ProviderConnecting(provider, current));

    // 1. هات رابط الـ authorization من الباك إند
    final urlResult = await repo.getAuthorizationUrl(provider);

    await urlResult.fold(
          (err) async {
        emit(ProviderConnectFailure(provider, err, current));
      },
          (authUrl) async {
        if (authUrl.isEmpty) {
          emit(
            ProviderConnectFailure(
              provider,
              'Authorization URL is empty',
              current,
            ),
          );
          return;
        }

        try {
          // 2. افتحي المتصفح الآمن (Custom Tabs / ASWebAuthenticationSession)
          // وانتظري الـ redirect اللي الباك إند المفروض يعمله لـ aigenda://
          final callbackResult = await FlutterWebAuth2.authenticate(
            url: authUrl,
            callbackUrlScheme: _callbackUrlScheme,
          );

          // 3. استخرجي البيانات من الرابط اللي رجع
          final callbackUri = Uri.parse(callbackResult);
          final connectionId = callbackUri.queryParameters['connectionId'];
          final error = callbackUri.queryParameters['error'];

          if (error != null && error.isNotEmpty) {
            final errorDescription =
                callbackUri.queryParameters['error_description'] ?? error;
            emit(ProviderConnectFailure(provider, errorDescription, current));
            return;
          }

          if (connectionId == null || connectionId.isEmpty) {
            emit(
              ProviderConnectFailure(
                provider,
                'No connectionId received from callback',
                current,
              ),
            );
            return;
          }

          // 4. اعملي refresh للقائمة كاملة عشان تجيبي الحالة المحدّثة
          final refreshed = await repo.getConnections();

          refreshed.fold(
                (err) => emit(ProviderConnectFailure(provider, err, current)),
                (connections) => emit(ProviderConnectSuccess(connections)),
          );
        } catch (e) {
          // ده اللي هيحصل دلوقتي لحد ما الباك إند يعدّل الـ redirect:
          // FlutterWebAuth2 هيرمي exception (عادةً platform exception)
          // لأنها مش لاقية الـ callback scheme بترجع من المتصفح.
          emit(
            ProviderConnectFailure(
              provider,
              'OAuth flow failed: $e',
              current,
            ),
          );
        }
      },
    );
  }

  //  DISCONNECT
  Future<void> disconnect(String connectionId) async {
    final current = _currentConnectionsOrEmpty();
    emit(ProviderDisconnecting(connectionId, current));

    final result = await repo.disconnect(connectionId);

    await result.fold(
          (err) async {
        emit(ProviderDisconnectFailure(connectionId, err, current));
      },
          (_) async {
        final refreshed = await repo.getConnections();
        refreshed.fold(
              (err) => emit(ProviderDisconnectFailure(connectionId, err, current)),
              (connections) => emit(ProviderDisconnectSuccess(connections)),
        );
      },
    );
  }
}