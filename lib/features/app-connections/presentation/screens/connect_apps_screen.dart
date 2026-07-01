import 'package:ajenda_app/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/app_connection_enums.dart';
import '../../data/models/app_connection_model.dart';
import '../../logic/app_connections_cubit/app_connections_cubit.dart';
import '../../logic/app_connections_cubit/app_connections_state.dart';
import '../widgets/connect_apps_header.dart';
import '../widgets/connection_card.dart';
import 'package:go_router/go_router.dart';

class ConnectAppsScreen extends StatelessWidget {
  const ConnectAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppConnectionsCubit>()..getConnections(),
      child: const _ConnectAppsBody(),
    );
  }
}

class _ConnectAppsBody extends StatelessWidget {
  const _ConnectAppsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Connect Apps', style: AppTextStyles.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<AppConnectionsCubit, AppConnectionsState>(
          listener: (context, state) {
            if (state is ProviderConnectFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is ProviderDisconnectFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AppConnectionsLoading ||
                state is AppConnectionsInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              );
            }

            if (state is AppConnectionsError) {
              return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<AppConnectionsCubit>().getConnections(),
              );
            }

            // كل الـ states التانية (Loaded, ProviderConnecting,
            // ProviderConnectSuccess, ProviderConnectFailure, ProviderDisconnecting,
            // ProviderDisconnectSuccess, ProviderDisconnectFailure) عندها قائمة
            // اتصالات حالية نقدر نعرضها بشكل موحّد
            final connections = _connectionsFromState(state);
            final loadingProvider = _loadingProviderFromState(state);

            return Column(
              children: [
                const ConnectAppsHeader(),
                Expanded(
                  child: _ConnectionsGrid(
                    connections: connections,
                    loadingProvider: loadingProvider,
                    onConnect: (provider) => context
                        .read<AppConnectionsCubit>()
                        .connectToProvider(provider),
                    onDisconnect: (connectionId) => context
                        .read<AppConnectionsCubit>()
                        .disconnect(connectionId),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<AppConnectionModel> _connectionsFromState(AppConnectionsState state) {
    if (state is AppConnectionsLoaded) return state.connections;
    if (state is ProviderConnecting) return state.currentConnections;
    if (state is ProviderConnectSuccess) return state.connections;
    if (state is ProviderConnectFailure) return state.currentConnections;
    if (state is ProviderDisconnecting) return state.currentConnections;
    if (state is ProviderDisconnectSuccess) return state.connections;
    if (state is ProviderDisconnectFailure) return state.currentConnections;
    return const [];
  }

  /// لو فيه provider بيعمل connect دلوقتي بالتحديد، رجّعيه عشان الكارت بتاعه
  /// بس يعرض spinner (الكروت التانية تفضل عادية).
  AppProviderType? _loadingProviderFromState(AppConnectionsState state) {
    if (state is ProviderConnecting) return state.provider;
    return null;
  }
}

class _ConnectionsGrid extends StatelessWidget {
  final List<AppConnectionModel> connections;
  final AppProviderType? loadingProvider;
  final void Function(AppProviderType provider) onConnect;
  final void Function(String connectionId) onDisconnect;

  const _ConnectionsGrid({
    required this.connections,
    required this.loadingProvider,
    required this.onConnect,
    required this.onDisconnect,
  });

  AppConnectionModel? _findByProvider(AppProviderType provider) {
    for (final c in connections) {
      if (c.provider == provider) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final google = _findByProvider(AppProviderType.google);
    final github = _findByProvider(AppProviderType.github);

    final cards = <Widget>[
      // ── Google (Calendar + Gmail) ──
      ConnectionCard(
        icon: Icons.calendar_today_rounded,
        iconColor: const Color(0xFF4285F4),
        title: 'Google Calendar & Gmail',
        description:
        'Sync your meetings, schedule, and emails directly to your tasks.',
        tagLabel: 'Productivity',
        provider: AppProviderType.google,
        isConnected: google?.isConnected ?? false,
        isLoading: loadingProvider == AppProviderType.google,
        onConnect: () => onConnect(AppProviderType.google),
        onDisconnect: google != null ? () => onDisconnect(google.id) : null,
      ),

      // ── GitHub ──
      ConnectionCard(
        icon: Icons.code_rounded,
        iconColor: AppColors.textPrimary,
        title: 'GitHub',
        description:
        'Link repositories, track pull request status, and sync issues with your project tasks.',
        tagLabel: 'Development',
        provider: AppProviderType.github,
        isConnected: github?.isConnected ?? false,
        isLoading: loadingProvider == AppProviderType.github,
        onConnect: () => onConnect(AppProviderType.github),
        onDisconnect: github != null ? () => onDisconnect(github.id) : null,
      ),

      // ── Coming Soon ──
      const ConnectionCard(
        icon: Icons.description_outlined,
        iconColor: Color(0xFF000000),
        title: 'Notion',
        description:
        'Seamlessly import pages and databases from Notion to your project workspace.',
        tagLabel: 'Productivity',
      ),
      const ConnectionCard(
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: Color(0xFF4A154B),
        title: 'Slack',
        description:
        'Get real-time notifications in your channels and create tasks directly from messages.',
        tagLabel: 'Popular integration',
      ),
      const ConnectionCard(
        icon: Icons.mail_outline_rounded,
        iconColor: Color(0xFF0078D4),
        title: 'Outlook & MS Teams',
        description:
        'Collaborate and sync your mail and meetings if your workspace runs on Microsoft 365.',
        tagLabel: 'Collaboration',
      ),
      const ConnectionCard(
        icon: Icons.view_kanban_outlined,
        iconColor: Color(0xFF0079BF),
        title: 'Trello',
        description:
        'Bring your existing Trello boards and cards into your Ai Genda tasks.',
        tagLabel: 'Task management',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) => cards[index],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}