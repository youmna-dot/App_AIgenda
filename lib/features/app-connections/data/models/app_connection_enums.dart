/// Mirrors the backend's `AppProvider` enum exactly (Abstractions/Enums/AppProviderEnums.cs).
/// The backend serializes this as an int in JSON (0, 1, ...), so the order
/// here MUST stay in sync with the backend — never reorder existing values,
/// only append new ones at the end.
enum AppProviderType {
  google, // 0
  github, // 1
  unknown, // fallback for any future/unrecognized value
}

extension AppProviderTypeX on AppProviderType {
  static AppProviderType fromInt(int? value) {
    switch (value) {
      case 0:
        return AppProviderType.google;
      case 1:
        return AppProviderType.github;
      default:
        return AppProviderType.unknown;
    }
  }

  int toInt() {
    switch (this) {
      case AppProviderType.google:
        return 0;
      case AppProviderType.github:
        return 1;
      case AppProviderType.unknown:
        return -1;
    }
  }

  /// The string name expected by the backend route, e.g.
  /// POST /authorize/{provider} -> "google" / "github"
  String get routeName {
    switch (this) {
      case AppProviderType.google:
        return 'google';
      case AppProviderType.github:
        return 'github';
      case AppProviderType.unknown:
        return '';
    }
  }
}

/// Mirrors the backend's `SyncFrequency` enum.
enum SyncFrequencyType {
  manual, // 0
  hourly, // 1
  daily, // 2
  weekly, // 3
  unknown,
}

extension SyncFrequencyTypeX on SyncFrequencyType {
  static SyncFrequencyType fromInt(int? value) {
    switch (value) {
      case 0:
        return SyncFrequencyType.manual;
      case 1:
        return SyncFrequencyType.hourly;
      case 2:
        return SyncFrequencyType.daily;
      case 3:
        return SyncFrequencyType.weekly;
      default:
        return SyncFrequencyType.unknown;
    }
  }

  int toInt() {
    switch (this) {
      case SyncFrequencyType.manual:
        return 0;
      case SyncFrequencyType.hourly:
        return 1;
      case SyncFrequencyType.daily:
        return 2;
      case SyncFrequencyType.weekly:
        return 3;
      case SyncFrequencyType.unknown:
        return -1;
    }
  }
}

/// Mirrors the backend's `SyncStatus` enum.
enum SyncStatusType {
  pending, // 0
  syncing, // 1
  success, // 2
  failed, // 3
  paused, // 4
  unknown,
}

extension SyncStatusTypeX on SyncStatusType {
  static SyncStatusType fromInt(int? value) {
    switch (value) {
      case 0:
        return SyncStatusType.pending;
      case 1:
        return SyncStatusType.syncing;
      case 2:
        return SyncStatusType.success;
      case 3:
        return SyncStatusType.failed;
      case 4:
        return SyncStatusType.paused;
      default:
        return SyncStatusType.unknown;
    }
  }

  int toInt() {
    switch (this) {
      case SyncStatusType.pending:
        return 0;
      case SyncStatusType.syncing:
        return 1;
      case SyncStatusType.success:
        return 2;
      case SyncStatusType.failed:
        return 3;
      case SyncStatusType.paused:
        return 4;
      case SyncStatusType.unknown:
        return -1;
    }
  }
}