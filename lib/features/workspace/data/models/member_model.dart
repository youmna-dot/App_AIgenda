import 'package:ajenda_app/core/network/api_endpoints.dart';

import '../../../../core/network/api_keys.dart';

class MemberModel {
  final String userId;
  final String fullName;
  final String email;
  final bool isOwner;
  final DateTime joinedAt;
  final List<String> permissions;
  final String? avatarUrl;

  MemberModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.isOwner,
    required this.joinedAt,
    required this.permissions,
     this.avatarUrl,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    final avatarRaw = json[ApiKeys.avatarUrl]?.toString();
    String? avatarUrl;
    if (avatarRaw != null && avatarRaw.isNotEmpty) {
      avatarUrl = avatarRaw.startsWith('http')
          ? avatarRaw
          : '${ApiEndpoints.baseUrl}$avatarRaw';
    }

  
    return MemberModel(
      userId: json[ApiKeys.userId],
      fullName: json[ApiKeys.fullName],
      email: json[ApiKeys.email],
      isOwner: json[ApiKeys.isOwner] ?? false,
      joinedAt: DateTime.parse(json[ApiKeys.joinedAt]),
      permissions: List<String>.from(json[ApiKeys.permissions] ?? []),
      avatarUrl: avatarUrl,
    );
  }
}