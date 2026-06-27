import 'package:ajenda_app/core/network/api_keys.dart';
/*
class PaginatedResponse<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  // ⚠️ غيري الـ keys دي لو الباك بتاعك بيرجع أسماء تانية
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json[ApiKeys.items] as List? ?? [])
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      pageNumber: json[ApiKeys.pageNumber] ?? 1,
      pageSize: json[ApiKeys.pageSize] ?? 10,
      totalCount: json[ApiKeys.totalCount] ?? 0,
      hasNextPage: json[ApiKeys.hasNextPage] ?? false,
      hasPreviousPage: json[ApiKeys.hasPreviousPage] ?? false,
    );
  }
}*/
// core/models/paginated_response.dart

class PaginatedResponse<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  bool get isLastPage => !hasNext;
  bool get isFirstPage => !hasPrevious;

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PaginatedResponse(
      items: (json[ApiKeys.items] as List? ?? [])
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      pageNumber: json[ApiKeys.pageNumber] ?? 1,
      pageSize: json[ApiKeys.pageSize] ?? 10,
      totalPages: json[ApiKeys.totalCount] ?? 0,
      hasNext: json[ApiKeys.hasNextPage] ?? false,
      hasPrevious: json[ApiKeys.hasPreviousPage] ?? false,
    );
  }
}