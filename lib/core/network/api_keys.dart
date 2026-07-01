class ApiKeys {
  // Response Keys
  static const String id =
      "id"; //  confirm change email send( id + newemail + code)
  static const String firstName = 'firstName';
  // auth files
  static const String lastName = 'lastName';
  static const String secondName = "secondName";
  static const String email = 'email';
  static const String token = 'token';
  static const String refreshToken = "refreshToken";
  static const String expiredIn = "expiredIn";
  static const String expiryDate = "expiryDate";
  static const String message = "message";

  // Backward compatibility لو عندك ملفات قديمة بتستخدم lastName

  // Request Keys
  static const String userId = "userId"; //  confirm email send(userId + code)
  static const String code = "code";

  static const String password = 'password';
  static const String confirmPassword = "confirmPassword";

  static const String currentPassword = "currentPassword";
  static const String newPassword = "newPassword";

  static const String newEmail = "newemail";
  static const String confirmEmailId = "id";

  static const String jobTitle = "jobTitle";
  static const String dateOfBirth = "dateOfBirth";

  static const String avatarUrl = "avatarUrl";

  // workspace
  //static const id = "id";
  static const name = "name";
  static const description = "description";
  static const iconCode = "iconCode";
  static const visibility = "visibility";
  static const numberOfMembers = "numberofMembers";
  static const numberOfTasks = "numberofTasks";
  static const numberOfSpaces = 'numberOfSpaces';

  static const isOwnedByCurrentUser = "isOwnedByCurrentUser";

  // workspace - dashboard
  static const totalSpaces = "totalSpaces";
  static const totalTasks = "totalTasks";
  static const totalMembers = "totalMembers";
  static const completedTasks = "completedTasks";
  static const inProgressTasks = "inProgressTasks";
  static const todoTasks = "todoTasks";
  static const String lastActivity = 'lastActivity'; // لو هتحتاجيه بعدين

  // Dashboard - Stats
  static const String stats = 'stats';
  static const String focusTimeHours = 'focusTimeHours';
  static const String activeSpaces = 'activeSpaces';
  static const String productivityScore = 'productivityScore';

  // Dashboard - Weekly Focus Time
  static const String weeklyFocusTime = 'weeklyFocusTime';
  static const String days = 'days';

  // Dashboard - Lists
  static const String recentActivities = 'recentActivities';
  static const String priorityTasks = 'priorityTasks';
  static const String spaces = 'spaces';

  // member
  static const fullName = "fullName";
  static const isOwner = "isOwner";
  static const joinedAt = "joinedAt";
  static const permissions = "permissions";
  static const String dashboard = 'dashboard';

  //  space
  static const String isPublic = 'isPublic';
  static const String workspaceId = 'workspaceId';
  static const String targetWorkspaceId = 'targetWorkspaceId';

  // task
  static const String title = 'title';
  static const String priority = 'priority';
  static const String dueDate = 'dueDate';
  static const String status = 'status';
  static const String assignees = 'assignees';
  static const String spaceId = 'spaceId';

  // subtask
  static const String isCompleted = 'isCompleted';
  static const String subTaskId = 'subTaskId';
  static const String subTasks = 'subTasks';

  // api_keys.dart
  // ── Note Response keys (camelCase — للـ fromJson) ──────────
  static const String isPinned        = 'isPinned';    // ✅ response
  static const String type            = 'type';        // ✅ response
  static const String text            = 'text';        // ✅ response
  static const String plainText       = 'plainText';   // ✅ response
  static const String htmlContent     = 'htmlContent'; // ✅ response
  static const String richTextJson    = 'richTextJson';// ✅ response
  static const String voiceTranscript = 'voice';       // ✅ response
  static const String transcriptText  = 'transcriptText'; // ✅ response
  static const String imageOcrText    = 'image';       // ✅ response
  static const String ocrText         = 'ocrText';     // ✅ response
  static const String caption         = 'caption';     // ✅ response
  static const String handDraw        = 'handDraw';    // ✅ response
  static const String drawingJson     = 'drawingJson'; // ✅ response
  static const String extractedText   = 'extractedText'; // ✅ response
  static const String createdAt       = 'createdAt';   // ✅ response
  static const String updatedAt       = 'updatedAt';   // ✅ response

  // ── Note Form Request keys (PascalCase — للـ createNote/updateNote) ──
  static const String noteTitle           = 'Title';
  static const String noteType            = 'Type';
  static const String noteIsPinned        = 'IsPinned';
  static const String notePlainText       = 'Text.PlainText';
  static const String noteHtmlContent     = 'Text.HtmlContent';
  static const String noteRichTextJson    = 'Text.RichTextJson';
  static const String noteVoiceTranscript = 'Voice.TranscriptText';
  static const String noteImageOcr        = 'Image.OcrText';
  static const String noteImageCaption    = 'Image.Caption';
  static const String noteDrawJson        = 'HandDraw.DrawingJson';
  static const String noteDrawText        = 'HandDraw.ExtractedText';

  // filter
  static const String pageNumber = 'PageNumber';
  static const String pageSize = 'PageSize';
  static const String searchValue = 'SearchValue';
  static const String sortColumn = 'SortColumn';
  static const String sortOrder = 'SortOrder';

  // paginated _ response احتمال يتغيروا ع ما أعرف ال
  static const String items = 'items';
  static const String totalCount = 'totalPages';
  static const String hasNextPage = 'hasNext';
  static const String hasPreviousPage = 'hasPrevious';


  // ──────────────── App Connections (Connect Apps / Integrations) ────────────────
  // Response keys (مؤكدة من رد فعلي بالباك إند - Postman)
  static const String connectionId = 'id'; // ⚠️ اسمه "id" في list/detail response
  static const String provider = 'provider'; // int: 0=Google, 1=GitHub
  static const String externalAccountId = 'externalAccountId';
  static const String syncFrequency = 'syncFrequency'; // int: 0-3
  static const String syncStatus = 'syncStatus'; // int: 0-4
  static const String lastSyncAt = 'lastSyncAt';
  static const String lastSyncError = 'lastSyncError';
  static const String isActive = 'isActive'; // ✅ ده اللي يحدد "Connected"
  static const String connectionCreatedAt = 'createdAt';

  // Extra fields only present in GET /app-connections/{id} (detail), not in list
  static const String grantedScopes = 'grantedScopes';
  static const String metadata = 'metadata';
  static const String tokenExpiresAt = 'tokenExpiresAt';

  // SyncStatusResponse uses "connectionId" (different from list/detail's "id")
  static const String syncStatusConnectionId = 'connectionId';
  static const String checkedAt = 'checkedAt';
  static const String recordsSynced = 'recordsSynced';

  // Authorize response: { "authorizationUrl": "..." } — مؤكد من Postman
  static const String authorizationUrl = 'authorizationUrl';

  // Sync request body ({ "forceFullSync": true })
  static const String forceFullSync = 'forceFullSync';

  // OAuth callback deep link query params (aigenda://...?connectionId=..&status=..)
  static const String callbackError = 'error';
  static const String callbackErrorDescription = 'error_description';

}

/*
{ // get all
{
    "items": [],
    "pageNumber": 1,
    "pageSize": 10,
    "totalPages": 0,
    "hasPervious": false,
    "hasNext": false
}

    "stats": {
        "totalTasks": 0,
        "focusTimeHours": 0,
        "activeSpaces": 0,
        "productivityScore": 0
    },
    "weeklyFocusTime": {
        "days": []
    },
    "recentActivities": [],
    "priorityTasks": [],
    "spaces": []
}

*/

// class ApiKeys {
//   // Response Keys
//   static const String id =
//       "id"; //  confirm change email send( id + newemail + code)
//   static const String firstName = 'firstName';
//   // auth files
//   static const String lastName = 'lastName';
//   static const String secondName = "secondName";
//   static const String email = 'email';
//   static const String token = 'token';
//   static const String refreshToken = "refreshToken";
//   static const String expiredIn = "expiredIn";
//   static const String expiryDate = "expiryDate";
//   static const String message = "message";

//   // Backward compatibility لو عندك ملفات قديمة بتستخدم lastName

//   // Request Keys
//   static const String userId = "userId"; //  confirm email send(userId + code)
//   static const String code = "code";

//   static const String password = 'password';
//   static const String confirmPassword = "confirmPassword";

//   static const String currentPassword = "currentPassword";
//   static const String newPassword = "newPassword";

//   static const String newEmail = "newemail";
//   static const String confirmEmailId = "id";

//   static const String jobTitle = "jobTitle";
//   static const String dateOfBirth = "dateOfBirth";

//   static const String avatarUrl = "avatarUrl";

//   // workspace
//   //static const id = "id";
//   static const name = "name";
//   static const description = "description";
//   static const iconCode = "iconCode";
//   static const visibility = "visibility";
//   static const numberOfMembers = "numberofMembers";
//   static const numberOfTasks = "numberofTasks";
//   static const numberOfSpaces = 'numberOfSpaces';

//   static const isOwnedByCurrentUser = "isOwnedByCurrentUser";

//   // workspace - dashboard
//   static const totalSpaces = "totalSpaces";
//   static const totalTasks = "totalTasks";
//   static const totalMembers = "totalMembers";
//   static const completedTasks = "completedTasks";
//   static const inProgressTasks = "inProgressTasks";
//   static const todoTasks = "todoTasks";
//   static const String lastActivity = 'lastActivity'; // لو هتحتاجيه بعدين

//   // Dashboard - Stats
//   static const String stats = 'stats';
//   static const String focusTimeHours = 'focusTimeHours';
//   static const String activeSpaces = 'activeSpaces';
//   static const String productivityScore = 'productivityScore';

//   // Dashboard - Weekly Focus Time
//   static const String weeklyFocusTime = 'weeklyFocusTime';
//   static const String days = 'days';

//   // Dashboard - Lists
//   static const String recentActivities = 'recentActivities';
//   static const String priorityTasks = 'priorityTasks';
//   static const String spaces = 'spaces';

//   // member
//   static const fullName = "fullName";
//   static const isOwner = "isOwner";
//   static const joinedAt = "joinedAt";
//   static const permissions = "permissions";
//   static const String dashboard = 'dashboard';

//   //  space
//   static const String isPublic = 'isPublic';
//   static const String workspaceId = 'workspaceId';
//   static const String targetWorkspaceId = 'targetWorkspaceId';

//   // task
//   static const String title = 'title';
//   static const String priority = 'priority';
//   static const String dueDate = 'dueDate';
//   static const String status = 'status';
//   static const String assignees = 'assignees';
//   static const String spaceId = 'spaceId';

//   // subtask
//   static const String isCompleted = 'isCompleted';
//   static const String subTaskId = 'subTaskId';
//   static const String subTasks = 'subTasks';

// // api_keys.dart

// // ── Note Response keys (camelCase — للـ fromJson) ──────────
//   static const String isPinned        = 'isPinned';    // ✅ response
//   static const String type            = 'type';        // ✅ response
//   static const String text            = 'text';        // ✅ response
//   static const String plainText       = 'plainText';   // ✅ response
//   static const String htmlContent     = 'htmlContent'; // ✅ response
//   static const String richTextJson    = 'richTextJson';// ✅ response
//   static const String voiceTranscript = 'voice';       // ✅ response
//   static const String transcriptText  = 'transcriptText'; // ✅ response
//   static const String imageOcrText    = 'image';       // ✅ response
//   static const String ocrText         = 'ocrText';     // ✅ response
//   static const String caption         = 'caption';     // ✅ response
//   static const String handDraw        = 'handDraw';    // ✅ response
//   static const String drawingJson     = 'drawingJson'; // ✅ response
//   static const String extractedText   = 'extractedText'; // ✅ response
//   static const String createdAt       = 'createdAt';   // ✅ response
//   static const String updatedAt       = 'updatedAt';   // ✅ response

// // ── Note Form Request keys (PascalCase — للـ createNote/updateNote) ──
//   static const String noteTitle           = 'Title';
//   static const String noteType            = 'Type';
//   static const String noteIsPinned        = 'IsPinned';
//   static const String notePlainText       = 'Text.PlainText';
//   static const String noteHtmlContent     = 'Text.HtmlContent';
//   static const String noteRichTextJson    = 'Text.RichTextJson';
//   static const String noteVoiceTranscript = 'Voice.TranscriptText';
//   static const String noteImageOcr        = 'Image.OcrText';
//   static const String noteImageCaption    = 'Image.Caption';
//   static const String noteDrawJson        = 'HandDraw.DrawingJson';
//   static const String noteDrawText        = 'HandDraw.ExtractedText';

//   // filter
//   static const String pageNumber = 'PageNumber';
//   static const String pageSize = 'PageSize';
//   static const String searchValue = 'SearchValue';
//   static const String sortColumn = 'SortColumn';
//   static const String sortOrder = 'SortOrder';

//   // paginated _ response احتمال يتغيروا ع ما أعرف ال
//   static const String items = 'items';
//   static const String totalCount = 'totalPages';
//   static const String hasNextPage = 'hasNext';
//   static const String hasPreviousPage = 'hasPrevious';
// }

// /*
// {
// // get all
// {
//     "items": [],
//     "pageNumber": 1,
//     "pageSize": 10,
//     "totalPages": 0,
//     "hasPervious": false,
//     "hasNext": false
// }

//     "stats": {
//         "totalTasks": 0,
//         "focusTimeHours": 0,
//         "activeSpaces": 0,
//         "productivityScore": 0
//     },
//     "weeklyFocusTime": {
//         "days": []
//     },
//     "recentActivities": [],
//     "priorityTasks": [],
//     "spaces": []
// }
//  */
