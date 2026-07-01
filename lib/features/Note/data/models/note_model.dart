// lib/features/note/data/models/note_model.dart

import '../../../../core/network/api_keys.dart';

enum NoteType { text, voice, image, handDraw }

class NoteTextContent {
  final String? plainText;
  final String? htmlContent;
  final String? richTextJson;

  const NoteTextContent({
    this.plainText,
    this.htmlContent,
    this.richTextJson,
  });
}

class NoteModel {
  final String  id;
  final String  title;
  final String  type;       // 'Text' | 'Voice' | 'Image' | 'HandDraw'
  final bool    isPinned;
  final String  spaceId;
  final int     workspaceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Text note content
  final NoteTextContent? text;
  String? get plainText => text?.plainText;

  // Voice note
  final String? voiceTranscriptText;

  // Image note
  final String? imageOcrText;
  final String? imageCaption;

  // HandDraw note
  final String? handDrawJson;
  final String? handDrawExtractedText;

  const NoteModel({
    required this.id,
    required this.title,
    required this.type,
    required this.isPinned,
    required this.spaceId,
    required this.workspaceId,
    this.createdAt,
    this.updatedAt,
    this.text,
    this.voiceTranscriptText,
    this.imageOcrText,
    this.imageCaption,
    this.handDrawJson,
    this.handDrawExtractedText,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    // 💡 دالة صغيرة عشان نحول الـ Enum (الأرقام) اللي راجعة من الباك إند لنص مفهوووم
    // Backend enum: Text=0, HandDraw=1, Voice=2, Image=3
    String mapType(dynamic typeVal) {
      final t = typeVal.toString();
      if (t == '0' || t.toLowerCase() == 'text')     return 'Text';
      if (t == '1' || t.toLowerCase() == 'handdraw') return 'HandDraw'; // ✅ FIX: كان 'Voice'
      if (t == '2' || t.toLowerCase() == 'voice')    return 'Voice';    // ✅ FIX: كان 'Image'
      if (t == '3' || t.toLowerCase() == 'image')    return 'Image';    // ✅ FIX: كان 'HandDraw'
      return 'Text'; // القيمة الافتراضية
    }

    return NoteModel(
      id:          json[ApiKeys.id]?.toString() ?? '',
      title:       json[ApiKeys.title] ?? '',
      type:        mapType(json[ApiKeys.type]),
      isPinned:    json[ApiKeys.isPinned] ?? false,
      spaceId:     json[ApiKeys.spaceId]?.toString() ?? '',
      workspaceId: json[ApiKeys.workspaceId] ?? 0,
      createdAt: json[ApiKeys.createdAt] != null
          ? DateTime.tryParse(json[ApiKeys.createdAt])
          : null,
      updatedAt: json[ApiKeys.updatedAt] != null
          ? DateTime.tryParse(json[ApiKeys.updatedAt])
          : null,

      // بنقرا الداتا مباشرة من الـ JSON الرئيسي (السطح) لأن الرد Flat
      text: NoteTextContent(
        plainText:    json[ApiKeys.plainText],
        htmlContent:  json[ApiKeys.htmlContent],
        richTextJson: json[ApiKeys.richTextJson],
      ),
      voiceTranscriptText:   json[ApiKeys.transcriptText],
      imageOcrText:          json[ApiKeys.ocrText],
      imageCaption:          json[ApiKeys.caption], // عدلناها عشان تقرا من السطح
      handDrawJson:          json[ApiKeys.drawingJson],
      handDrawExtractedText: json[ApiKeys.extractedText],
    );
  }

  /// النص القابل للعرض — بيرجع أول محتوى متاح
  String get previewText {
    if (text?.plainText?.isNotEmpty == true) return text!.plainText!;
    if (voiceTranscriptText?.isNotEmpty == true) return voiceTranscriptText!;
    if (imageCaption?.isNotEmpty == true) return imageCaption!;
    if (handDrawExtractedText?.isNotEmpty == true) return handDrawExtractedText!;
    return '';
  }
}